`timescale 1ns/1ps
module tb_forwarding_unit;
reg [4:0] rs1, rs2, exrd, wbrd;
reg exwe, wbwe;
wire [1:0] fa, fb;
forwarding_unit dut(rs1,rs2,exrd,exwe,wbrd,wbwe,fa,fb);
initial begin
    rs1=5; rs2=6; exrd=5; exwe=1; wbrd=6; wbwe=1; #5;
    if (fa!==2'b10 || fb!==2'b01) $fatal(1,"Forwarding selection failed");
    exrd=6; wbrd=6; #5;
    if (fb!==2'b10) $fatal(1,"EX/MEM priority failed");
    exrd=0; wbrd=0; #5;
    if (fa!==0 || fb!==0) $fatal(1,"x0 must not be forwarded");
    $display("PASS: forwarding unit"); $finish;
end
endmodule
