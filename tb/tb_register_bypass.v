`timescale 1ns/1ps
module tb_register_bypass;
reg clk=0, reset=1;
wire [31:0] pc, cycles, retired, stalls, forwards;
hazard_processor_top #(.PROGRAM_FILE("programs/gap3.hex")) dut(clk,reset,pc,cycles,retired,stalls,forwards);
always #5 clk=~clk;
initial begin
    #12 reset=0;
    repeat(20) @(posedge clk);
    #1;
    if (dut.rf.regs[1] !== 7)  $fatal(1,"x1 expected 7, got %0d", dut.rf.regs[1]);
    if (dut.rf.regs[3] !== 14) $fatal(1,"x3 expected 14, got %0d", dut.rf.regs[3]);
    $display("PASS: register-file write-through (consumer 3 instructions after producer)");
    $finish;
end
initial begin #1000; $fatal(1,"Timeout"); end
endmodule