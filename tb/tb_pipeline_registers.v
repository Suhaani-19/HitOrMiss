`timescale 1ns/1ps
module tb_pipeline_registers;
reg clk,reset,ifid_enable,idex_flush;
reg regwrite_in,memread_in,memwrite_in,memtoreg_in,alusrc_in;
reg [3:0] alucontrol_in;
reg [31:0] pc_in,instr_in,regdata1_in,regdata2_in,imm_in,alu_result_in,write_data_in,mem_data_in;
reg [4:0] rs1_in,rs2_in,rd_in;
wire [31:0] ifid_pc_out,ifid_instr_out;
wire idex_regwrite_out,idex_memread_out,idex_memwrite_out,idex_memtoreg_out,idex_alusrc_out;
wire [3:0] idex_alucontrol_out;
wire [31:0] idex_pc_out,idex_regdata1_out,idex_regdata2_out,idex_imm_out;
wire [4:0] idex_rs1_out,idex_rs2_out,idex_rd_out;
wire exmem_regwrite_out,exmem_memread_out,exmem_memwrite_out,exmem_memtoreg_out;
wire [31:0] exmem_alu_result_out,exmem_write_data_out; wire [4:0] exmem_rd_out;
wire memwb_regwrite_out,memwb_memtoreg_out;
wire [31:0] memwb_alu_result_out,memwb_mem_data_out; wire [4:0] memwb_rd_out;
if_id_register ifid(.clk(clk),.reset(reset),.enable(ifid_enable),.pc_in(pc_in),.instr_in(instr_in),.pc_out(ifid_pc_out),.instr_out(ifid_instr_out));
id_ex_register idex(.clk(clk),.reset(reset),.flush(idex_flush),.regwrite_in(regwrite_in),.memread_in(memread_in),.memwrite_in(memwrite_in),.memtoreg_in(memtoreg_in),.alusrc_in(alusrc_in),.alucontrol_in(alucontrol_in),.pc_in(pc_in),.regdata1_in(regdata1_in),.regdata2_in(regdata2_in),.imm_in(imm_in),.rs1_in(rs1_in),.rs2_in(rs2_in),.rd_in(rd_in),.regwrite_out(idex_regwrite_out),.memread_out(idex_memread_out),.memwrite_out(idex_memwrite_out),.memtoreg_out(idex_memtoreg_out),.alusrc_out(idex_alusrc_out),.alucontrol_out(idex_alucontrol_out),.pc_out(idex_pc_out),.regdata1_out(idex_regdata1_out),.regdata2_out(idex_regdata2_out),.imm_out(idex_imm_out),.rs1_out(idex_rs1_out),.rs2_out(idex_rs2_out),.rd_out(idex_rd_out));
ex_mem_register exmem(.clk(clk),.reset(reset),.regwrite_in(regwrite_in),.memread_in(memread_in),.memwrite_in(memwrite_in),.memtoreg_in(memtoreg_in),.alu_result_in(alu_result_in),.write_data_in(write_data_in),.rd_in(rd_in),.regwrite_out(exmem_regwrite_out),.memread_out(exmem_memread_out),.memwrite_out(exmem_memwrite_out),.memtoreg_out(exmem_memtoreg_out),.alu_result_out(exmem_alu_result_out),.write_data_out(exmem_write_data_out),.rd_out(exmem_rd_out));
mem_wb_register memwb(.clk(clk),.reset(reset),.regwrite_in(regwrite_in),.memtoreg_in(memtoreg_in),.alu_result_in(alu_result_in),.mem_data_in(mem_data_in),.rd_in(rd_in),.regwrite_out(memwb_regwrite_out),.memtoreg_out(memwb_memtoreg_out),.alu_result_out(memwb_alu_result_out),.mem_data_out(memwb_mem_data_out),.rd_out(memwb_rd_out));
always #5 clk=~clk;
initial begin
$dumpfile("results/waveforms/tb_pipeline_registers.vcd");
$dumpvars(0, tb_pipeline_registers);
clk=0;reset=1;ifid_enable=1;idex_flush=0;regwrite_in=1;memread_in=1;memwrite_in=0;memtoreg_in=1;alusrc_in=1;alucontrol_in=0;pc_in=32'h100;instr_in=32'h12345678;regdata1_in=11;regdata2_in=22;imm_in=33;rs1_in=1;rs2_in=2;rd_in=3;alu_result_in=44;write_data_in=55;mem_data_in=66;
@(posedge clk);#1;
if(ifid_pc_out!==0||ifid_instr_out!==0||idex_regwrite_out!==0||exmem_regwrite_out!==0||memwb_regwrite_out!==0)$fatal(1,"Reset failed");
reset=0;@(posedge clk);#1;
if(ifid_pc_out!==32'h100||ifid_instr_out!==32'h12345678)$fatal(1,"IF/ID transfer failed");
if(idex_pc_out!==32'h100||idex_rd_out!==3||idex_regdata2_out!==22)$fatal(1,"ID/EX transfer failed");
if(exmem_alu_result_out!==44||exmem_write_data_out!==55||exmem_rd_out!==3)$fatal(1,"EX/MEM transfer failed");
if(memwb_mem_data_out!==66||memwb_rd_out!==3)$fatal(1,"MEM/WB transfer failed");
ifid_enable=0;pc_in=32'h200;instr_in=32'h87654321;@(posedge clk);#1;
if(ifid_pc_out!==32'h100||ifid_instr_out!==32'h12345678)$fatal(1,"IF/ID hold failed");
idex_flush=1;@(posedge clk);#1;
if(idex_regwrite_out!==0||idex_memread_out!==0||idex_memwrite_out!==0||idex_memtoreg_out!==0||idex_rd_out!==0)$fatal(1,"ID/EX flush failed");
$display("PASS: pipeline registers");$finish;
end
endmodule
