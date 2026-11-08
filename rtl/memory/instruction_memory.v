module instruction_memory #(parameter PROGRAM_FILE = "programs/mixed_dependencies.hex")(
    input [31:0] address, output [31:0] instruction
);
parameter DEPTH = 256;
reg [31:0] mem [0:DEPTH-1];
integer i;
initial begin
    for (i=0; i<DEPTH; i=i+1) mem[i] = 32'h00000013; // harmless ADDI x0,x0,0
    $readmemh(PROGRAM_FILE, mem);
end
assign instruction = mem[address[9:2]];
endmodule
