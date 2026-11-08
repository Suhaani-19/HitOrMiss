`timescale 1ns/1ps
module tb_performance_counters;
reg clk,reset,retired,stall,forwarding_event;
wire [31:0] cycles,retired_instructions,stall_cycles,forwarding_events;
performance_counters dut(.clk(clk),.reset(reset),.retired(retired),.stall(stall),.forwarding_event(forwarding_event),.cycles(cycles),.retired_instructions(retired_instructions),.stall_cycles(stall_cycles),.forwarding_events(forwarding_events));
always #5 clk=~clk;
initial begin
$dumpfile("results/waveforms/tb_performance_counters.vcd");$dumpvars(0,tb_performance_counters);
clk=0;reset=1;retired=0;stall=0;forwarding_event=0;
@(posedge clk);#1;reset=0;
@(negedge clk);retired=1;
@(negedge clk);retired=0;stall=1;
@(negedge clk);stall=0;retired=1;forwarding_event=1;
@(negedge clk);forwarding_event=0;retired=1;
@(negedge clk);retired=0;
@(negedge clk);retired=1;
@(posedge clk);#1;
if(cycles!==6)$fatal(1,"Expected 6 cycles, got %0d",cycles);
if(retired_instructions!==4)$fatal(1,"Expected 4 retirement events, got %0d",retired_instructions);
if(stall_cycles!==1)$fatal(1,"Expected 1 stall, got %0d",stall_cycles);
if(forwarding_events!==1)$fatal(1,"Expected 1 forwarding event, got %0d",forwarding_events);
$display("PASS: performance counters");
$display("cycles=%0d retired_events=%0d stall_cycles=%0d forwarding_events=%0d",cycles,retired_instructions,stall_cycles,forwarding_events);
$finish;
end
endmodule
