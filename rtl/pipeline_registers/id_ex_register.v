module id_ex_register(
    input clk, input reset, input flush,
    input regwrite_in, input memread_in, input memwrite_in, input memtoreg_in,
    input alusrc_in, input [3:0] alucontrol_in,
    input [31:0] pc_in, input [31:0] regdata1_in, input [31:0] regdata2_in,
    input [31:0] imm_in, input [4:0] rs1_in, input [4:0] rs2_in, input [4:0] rd_in,
    output reg regwrite_out, output reg memread_out, output reg memwrite_out,
    output reg memtoreg_out, output reg alusrc_out, output reg [3:0] alucontrol_out,
    output reg [31:0] pc_out, output reg [31:0] regdata1_out, output reg [31:0] regdata2_out,
    output reg [31:0] imm_out, output reg [4:0] rs1_out, output reg [4:0] rs2_out, output reg [4:0] rd_out
);
always @(posedge clk) begin
    if (reset || flush) begin
        regwrite_out<=0; memread_out<=0; memwrite_out<=0; memtoreg_out<=0;
        alusrc_out<=0; alucontrol_out<=0; pc_out<=0; regdata1_out<=0;
        regdata2_out<=0; imm_out<=0; rs1_out<=0; rs2_out<=0; rd_out<=0;
    end else begin
        regwrite_out<=regwrite_in; memread_out<=memread_in; memwrite_out<=memwrite_in;
        memtoreg_out<=memtoreg_in; alusrc_out<=alusrc_in; alucontrol_out<=alucontrol_in;
        pc_out<=pc_in; regdata1_out<=regdata1_in; regdata2_out<=regdata2_in;
        imm_out<=imm_in; rs1_out<=rs1_in; rs2_out<=rs2_in; rd_out<=rd_in;
    end
end
endmodule
