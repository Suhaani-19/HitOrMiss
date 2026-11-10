`timescale 1ns/1ps
module tb_store_load_processor;
reg clk=0,reset=1;
wire [31:0] pc,cycles,retired,stalls,forwards;
hazard_processor_top #(.PROGRAM_FILE("programs/store_load.hex")) dut(clk,reset,pc,cycles,retired,stalls,forwards);
always #5 clk=~clk;
initial begin
$dumpfile("results/waveforms/tb_store_load_processor.vcd");$dumpvars(0,tb_store_load_processor);
#12;reset=0;
repeat(35) @(posedge clk);#1;
if(dut.dmem.mem[0]!==42)$fatal(1,"Stored memory word expected 42, got %0d",dut.dmem.mem[0]);
if(dut.rf.regs[3]!==42)$fatal(1,"Loaded register x3 expected 42, got %0d",dut.rf.regs[3]);
$display("PASS: integrated store/load");
$finish;
end
initial begin #1000;$fatal(1,"Timeout");end
endmodule
