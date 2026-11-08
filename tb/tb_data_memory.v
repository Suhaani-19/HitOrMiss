`timescale 1ns/1ps
module tb_data_memory;
reg clk,memread,memwrite;reg [31:0] address,write_data;wire [31:0] read_data;
data_memory dut(.clk(clk),.memread(memread),.memwrite(memwrite),.address(address),.write_data(write_data),.read_data(read_data));
always #5 clk=~clk;
initial begin
$dumpfile("results/waveforms/tb_data_memory.vcd");$dumpvars(0,tb_data_memory);
clk=0;memread=0;memwrite=0;address=0;write_data=0;
@(negedge clk);address=0;write_data=100;memwrite=1;
@(posedge clk);#1;memwrite=0;memread=1;#1;
if(read_data!==100)$fatal(1,"Read after write failed at address 0");
@(negedge clk);address=4;write_data=250;memwrite=1;memread=0;
@(posedge clk);#1;memwrite=0;memread=1;#1;
if(read_data!==250)$fatal(1,"Read after write failed at address 4");
address=0;#1;if(read_data!==100)$fatal(1,"Stored value at address 0 was not retained");
$display("PASS: data memory");$finish;
end
endmodule
