`timescale 1ns/1ps
module tb_register_file;
reg clk,reset,regwrite;reg [4:0] read_reg1,read_reg2,write_reg;reg [31:0] write_data;
wire [31:0] read_data1,read_data2;
register_file dut(.clk(clk),.reset(reset),.regwrite(regwrite),.read_reg1(read_reg1),.read_reg2(read_reg2),.write_reg(write_reg),.write_data(write_data),.read_data1(read_data1),.read_data2(read_data2));
always #5 clk=~clk;
initial begin
clk=0;reset=1;regwrite=0;read_reg1=0;read_reg2=1;write_reg=1;write_data=123;
@(posedge clk);#1;reset=0;regwrite=1;@(posedge clk);#1;regwrite=0;
if(read_data2!==123)$fatal(1,"Register write/read failed");
read_reg1=0;#1;if(read_data1!==0)$fatal(1,"x0 must always read as zero");
write_reg=0;write_data=999;regwrite=1;@(posedge clk);#1;regwrite=0;
read_reg1=0;#1;if(read_data1!==0)$fatal(1,"x0 must not be writable");
$display("PASS: register file");$finish;
end
endmodule
