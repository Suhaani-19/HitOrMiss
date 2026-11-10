`timescale 1ns/1ps
module tb_control_unit;
reg [6:0] opcode,funct7;reg [2:0] funct3;
wire regwrite,memread,memwrite,memtoreg,alusrc;wire [3:0] alucontrol;wire uses_rs1,uses_rs2;
control_unit dut(.opcode(opcode),.funct3(funct3),.funct7(funct7),.regwrite(regwrite),.memread(memread),.memwrite(memwrite),.memtoreg(memtoreg),.alusrc(alusrc),.alucontrol(alucontrol),.uses_rs1(uses_rs1),.uses_rs2(uses_rs2));
initial begin
opcode=7'b0110011;funct3=0;funct7=0;#2;if(!regwrite||!uses_rs1||!uses_rs2||alucontrol!==0)$fatal(1,"ADD decode failed");
funct7=7'b0100000;#2;if(alucontrol!==1)$fatal(1,"SUB decode failed");
opcode=7'b0010011;funct3=0;funct7=0;#2;if(!regwrite||!alusrc||!uses_rs1||uses_rs2)$fatal(1,"ADDI decode failed");
opcode=7'b0000011;#2;if(!regwrite||!memread||!memtoreg||!alusrc||!uses_rs1||uses_rs2)$fatal(1,"LW decode failed");
opcode=7'b0100011;#2;if(regwrite||!memwrite||!alusrc||!uses_rs1||!uses_rs2)$fatal(1,"SW decode failed");
opcode=7'b0000000;#2;if(regwrite||memread||memwrite||uses_rs1||uses_rs2)$fatal(1,"Invalid opcode should be inert");
$display("PASS: control unit");$finish;
end
endmodule
