`timescale 1ns/1ps
module tb_alu;
reg [31:0] a,b; reg [3:0] op; wire [31:0] y;
alu dut(a,b,op,y);
initial begin
 a=12; b=5; op=0; #2; if(y!==17) $fatal;
 op=1; #2; if(y!==7) $fatal;
 op=2; #2; if(y!==4) $fatal;
 op=3; #2; if(y!==13) $fatal;
 $display("PASS: ALU"); $finish;
end
endmodule
