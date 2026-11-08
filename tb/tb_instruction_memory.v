`timescale 1ns/1ps
module tb_instruction_memory;
reg [31:0] address; wire [31:0] instruction;
instruction_memory dut(.address(address),.instruction(instruction));
initial begin
$dumpfile("results/waveforms/tb_instruction_memory.vcd");$dumpvars(0,tb_instruction_memory);
address=0;#2;if(instruction!==32'h00700093)$fatal(1,"Instruction at address 0 incorrect");
address=4;#2;if(instruction!==32'h00300113)$fatal(1,"Instruction at address 4 incorrect");
address=8;#2;if(instruction!==32'h002081B3)$fatal(1,"Instruction at address 8 incorrect");
address=12;#2;if(instruction!==32'h40218233)$fatal(1,"Instruction at address 12 incorrect");
address=16;#2;if(instruction!==32'h001272B3)$fatal(1,"Instruction at address 16 incorrect");
$display("PASS: instruction memory");$finish;
end
endmodule
