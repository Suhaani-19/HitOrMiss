`timescale 1ns/1ps

module tb_forwarding_unit;

reg [4:0] rs1, rs2, exrd, wbrd;
reg exwe, wbwe;
wire [1:0] fa, fb;

forwarding_unit dut(
    rs1, rs2, exrd, exwe, wbrd, wbwe, fa, fb
);

initial begin

    $dumpfile("results/waveforms/tb_forwarding_unit.vcd");
    $dumpvars(0, tb_forwarding_unit);

    // Test 1: Simultaneous forwarding
    rs1=5; rs2=6; exrd=5; wbrd=6;
    exwe=1; wbwe=1; #5;
    if (fa!==2'b10 || fb!==2'b01)
        $fatal(1,"Simultaneous forwarding failed");
    $display("PASS 1: Simultaneous forwarding");

    // Test 2: EX/MEM priority for rs2
    exrd=6; wbrd=6; #5;
    if (fa!==2'b00 || fb!==2'b10)
        $fatal(1,"EX/MEM priority failed");
    $display("PASS 2: EX/MEM priority for rs2");

    // Test 3: Ignore register x0
    rs1=0; rs2=0; exrd=0; wbrd=0; #5;
    if (fa!==2'b00 || fb!==2'b00)
        $fatal(1,"x0 must not be forwarded");
    $display("PASS 3: Register x0 ignored");

    // Test 4: Write enables disabled
    rs1=5; rs2=6; exrd=5; wbrd=6;
    exwe=0; wbwe=0; #5;
    if (fa!==2'b00 || fb!==2'b00)
        $fatal(1,"Disabled write enable failed");
    $display("PASS 4: Write enables disabled");

    // Test 5: No register dependency
    rs1=1; rs2=2; exrd=3; wbrd=4;
    exwe=1; wbwe=1; #5;
    if (fa!==2'b00 || fb!==2'b00)
        $fatal(1,"No dependency test failed");
    $display("PASS 5: No register dependency");

    // Test 6: EX/MEM priority for rs1
    rs1=5; rs2=6; exrd=5; wbrd=5; #5;
    if (fa!==2'b10 || fb!==2'b00)
        $fatal(1,"EX/MEM priority for rs1 failed");
    $display("PASS 6: EX/MEM priority for rs1");

    // Test 7: MEM/WB forwarding for rs1
    exwe=0; wbwe=1; #5;
    if (fa!==2'b01 || fb!==2'b00)
        $fatal(1,"MEM/WB forwarding failed");
    $display("PASS 7: MEM/WB forwarding for rs1");

    $display("PASS: All 7 forwarding unit tests");
    $finish;

end

endmodule
