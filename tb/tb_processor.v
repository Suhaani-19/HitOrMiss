`timescale 1ns/1ps
module tb_processor;
reg clk=0, reset=1;
wire [31:0] pc, cycles, retired, stalls, forwards;
hazard_processor_top dut(clk,reset,pc,cycles,retired,stalls,forwards);
always #5 clk=~clk;
initial begin
    $dumpfile("results/waveforms/tb_processor.vcd");
    $dumpvars(0,tb_processor);
    // Program memory is preloaded from programs/mixed_dependencies.hex.
    // Initialize data word 0 for the LW in the sample program.
    #12;
    dut.dmem.mem[0] = 20;
    reset=0;
    repeat(35) @(posedge clk);
    #1;
    if (dut.rf.regs[1] !== 7) $fatal(1,"x1 expected 7, got %0d",dut.rf.regs[1]);
    if (dut.rf.regs[2] !== 3) $fatal(1,"x2 expected 3, got %0d",dut.rf.regs[2]);
    if (dut.rf.regs[3] !== 10) $fatal(1,"x3 expected 10, got %0d",dut.rf.regs[3]);
    if (dut.rf.regs[4] !== 7) $fatal(1,"x4 expected 7, got %0d",dut.rf.regs[4]);
    if (dut.rf.regs[5] !== 7) $fatal(1,"x5 expected 7, got %0d",dut.rf.regs[5]);
    $display("PASS: processor integration");
    $display("cycles=%0d retired=%0d stalls=%0d forwarding_events=%0d",
        cycles,retired,stalls,forwards);
    $finish;
end
initial begin #1000; $fatal(1,"Timeout"); end
endmodule
