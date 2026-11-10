`timescale 1ns/1ps
module tb_load_use_processor;
reg clk=0,reset=1;
wire [31:0] pc,cycles,retired,stalls,forwards;
hazard_processor_top #(.PROGRAM_FILE("programs/load_use.hex")) dut(clk,reset,pc,cycles,retired,stalls,forwards);
always #5 clk=~clk;
initial begin
$dumpfile("results/waveforms/tb_load_use_processor.vcd");$dumpvars(0,tb_load_use_processor);
#12;dut.dmem.mem[0]=20;reset=0;
repeat(35) @(posedge clk);#1;
if(dut.rf.regs[1]!==20)$fatal(1,"LW result x1 expected 20, got %0d",dut.rf.regs[1]);
if(dut.rf.regs[3]!==20)$fatal(1,"Dependent ADD result x3 expected 20, got %0d",dut.rf.regs[3]);
if(stalls!==1)$fatal(1,"Expected exactly one load-use stall, got %0d",stalls);
if(forwards<1)$fatal(1,"Expected forwarding after the load-use stall, got %0d",forwards);
$display("PASS: integrated load-use hazard (stall=%0d, forwarding_cycles=%0d)",stalls,forwards);
$finish;
end
initial begin #1000;$fatal(1,"Timeout");end
endmodule
