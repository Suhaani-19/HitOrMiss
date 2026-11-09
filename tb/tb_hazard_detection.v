`timescale 1ns/1ps
module tb_hazard_detection;
reg memread; reg [4:0] rd, rs1, rs2; reg u1,u2; wire stall;
hazard_detection_unit dut(memread,rd,rs1,rs2,u1,u2,stall);
initial begin
    memread=1; rd=3; rs1=3; rs2=0; u1=1; u2=0; #5;
    if (!stall) $fatal(1,"Expected load-use stall");
    rs1=4; #5; if (stall) $fatal(1,"Unexpected stall");
    rs1=3; u1=0; u2=1; rs2=3; #5; if (!stall) $fatal(1,"rs2 dependency missed");
    rd=0; #5; if (stall) $fatal(1,"x0 must not cause stall");
    $display("PASS: hazard detection unit"); $finish;
end
endmodule
