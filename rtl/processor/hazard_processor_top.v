module hazard_processor_top(
    input clk, input reset,
    output [31:0] debug_pc,
    output [31:0] cycles, output [31:0] retired_instructions,
    output [31:0] stall_cycles, output [31:0] forwarding_events
);
reg [31:0] pc;
wire [31:0] instruction;
wire [31:0] ifid_pc, ifid_instr;
wire stall;

instruction_memory imem(.address(pc), .instruction(instruction));
if_id_register ifid(.clk(clk), .reset(reset), .enable(!stall),
    .pc_in(pc), .instr_in(instruction), .pc_out(ifid_pc), .instr_out(ifid_instr));

wire [6:0] opcode = ifid_instr[6:0];
wire [4:0] rd = ifid_instr[11:7];
wire [2:0] funct3 = ifid_instr[14:12];
wire [4:0] rs1 = ifid_instr[19:15];
wire [4:0] rs2 = ifid_instr[24:20];
wire [6:0] funct7 = ifid_instr[31:25];
wire dec_regwrite, dec_memread, dec_memwrite, dec_memtoreg, dec_alusrc;
wire [3:0] dec_alucontrol;
wire uses_rs1, uses_rs2;
control_unit cu(.opcode(opcode), .funct3(funct3), .funct7(funct7),
    .regwrite(dec_regwrite), .memread(dec_memread), .memwrite(dec_memwrite),
    .memtoreg(dec_memtoreg), .alusrc(dec_alusrc), .alucontrol(dec_alucontrol),
    .uses_rs1(uses_rs1), .uses_rs2(uses_rs2));

wire [31:0] wb_data, regdata1, regdata2;
wire wb_regwrite, wb_memtoreg;
wire [31:0] wb_alu, wb_mem;
wire [4:0] wb_rd;
assign wb_data = wb_memtoreg ? wb_mem : wb_alu;
register_file rf(.clk(clk), .reset(reset), .regwrite(wb_regwrite),
    .read_reg1(rs1), .read_reg2(rs2), .write_reg(wb_rd), .write_data(wb_data),
    .read_data1(regdata1), .read_data2(regdata2));

wire idex_regwrite, idex_memread, idex_memwrite, idex_memtoreg, idex_alusrc;
wire [3:0] idex_alucontrol;
wire [31:0] idex_pc, idex_regdata1, idex_regdata2, idex_imm;
wire [4:0] idex_rs1, idex_rs2, idex_rd;
wire [31:0] imm_i = {{20{ifid_instr[31]}}, ifid_instr[31:20]};
wire [31:0] imm_s = {{20{ifid_instr[31]}}, ifid_instr[31:25], ifid_instr[11:7]};
wire [31:0] dec_imm = (opcode == 7'b0100011) ? imm_s : imm_i;

hazard_detection_unit hdu(.idex_memread(idex_memread), .idex_rd(idex_rd),
    .ifid_rs1(rs1), .ifid_rs2(rs2), .ifid_uses_rs1(uses_rs1),
    .ifid_uses_rs2(uses_rs2), .stall(stall));

id_ex_register idex(.clk(clk), .reset(reset), .flush(stall),
    .regwrite_in(dec_regwrite), .memread_in(dec_memread), .memwrite_in(dec_memwrite),
    .memtoreg_in(dec_memtoreg), .alusrc_in(dec_alusrc), .alucontrol_in(dec_alucontrol),
    .pc_in(ifid_pc), .regdata1_in(regdata1), .regdata2_in(regdata2),
    .imm_in(dec_imm), .rs1_in(rs1), .rs2_in(rs2), .rd_in(rd),
    .regwrite_out(idex_regwrite), .memread_out(idex_memread), .memwrite_out(idex_memwrite),
    .memtoreg_out(idex_memtoreg), .alusrc_out(idex_alusrc), .alucontrol_out(idex_alucontrol),
    .pc_out(idex_pc), .regdata1_out(idex_regdata1), .regdata2_out(idex_regdata2),
    .imm_out(idex_imm), .rs1_out(idex_rs1), .rs2_out(idex_rs2), .rd_out(idex_rd));

wire [1:0] forward_a, forward_b;
wire [31:0] mem_data;
wire exmem_regwrite, exmem_memread, exmem_memwrite, exmem_memtoreg;
wire [31:0] exmem_alu, exmem_writedata;
wire [4:0] exmem_rd;
forwarding_unit fu(.idex_rs1(idex_rs1), .idex_rs2(idex_rs2),
    .exmem_rd(exmem_rd), .exmem_regwrite(exmem_regwrite),
    .memwb_rd(wb_rd), .memwb_regwrite(wb_regwrite),
    .forward_a(forward_a), .forward_b(forward_b));

// For an EX/MEM load, forward the value returned by data memory, not its address.
wire [31:0] exmem_forward_value = exmem_memread ? mem_data : exmem_alu;
wire [31:0] forwarded_a = (forward_a == 2'b10) ? exmem_forward_value :
                            (forward_a == 2'b01) ? wb_data : idex_regdata1;
wire [31:0] forwarded_b = (forward_b == 2'b10) ? exmem_forward_value :
                            (forward_b == 2'b01) ? wb_data : idex_regdata2;
wire [31:0] alu_b = idex_alusrc ? idex_imm : forwarded_b;
wire [31:0] alu_result;
alu alu0(.a(forwarded_a), .b(alu_b), .control(idex_alucontrol), .result(alu_result));

ex_mem_register exmem(.clk(clk), .reset(reset),
    .regwrite_in(idex_regwrite), .memread_in(idex_memread), .memwrite_in(idex_memwrite),
    .memtoreg_in(idex_memtoreg), .alu_result_in(alu_result),
    .write_data_in(forwarded_b), .rd_in(idex_rd),
    .regwrite_out(exmem_regwrite), .memread_out(exmem_memread),
    .memwrite_out(exmem_memwrite), .memtoreg_out(exmem_memtoreg),
    .alu_result_out(exmem_alu), .write_data_out(exmem_writedata), .rd_out(exmem_rd));

data_memory dmem(.clk(clk), .memread(exmem_memread), .memwrite(exmem_memwrite),
    .address(exmem_alu), .write_data(exmem_writedata), .read_data(mem_data));

mem_wb_register memwb(.clk(clk), .reset(reset),
    .regwrite_in(exmem_regwrite), .memtoreg_in(exmem_memtoreg),
    .alu_result_in(exmem_alu), .mem_data_in(mem_data), .rd_in(exmem_rd),
    .regwrite_out(wb_regwrite), .memtoreg_out(wb_memtoreg),
    .alu_result_out(wb_alu), .mem_data_out(wb_mem), .rd_out(wb_rd));

always @(posedge clk) begin
    if (reset) pc <= 0;
    else if (!stall) pc <= pc + 4;
end

wire forwarding_event = (forward_a != 0) || (forward_b != 0);
performance_counters perf(.clk(clk), .reset(reset),
    .retired(wb_regwrite), .stall(stall), .forwarding_event(forwarding_event),
    .cycles(cycles), .retired_instructions(retired_instructions),
    .stall_cycles(stall_cycles), .forwarding_events(forwarding_events));

assign debug_pc = pc;
endmodule
