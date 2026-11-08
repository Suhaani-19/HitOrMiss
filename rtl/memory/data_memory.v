module data_memory(
    input clk, input memread, input memwrite,
    input [31:0] address, input [31:0] write_data,
    output [31:0] read_data
);
parameter DEPTH = 256;
reg [31:0] mem [0:DEPTH-1];
integer i;
initial begin
    for (i=0; i<DEPTH; i=i+1) mem[i] = 0;
end
always @(posedge clk) begin
    if (memwrite) mem[address[9:2]] <= write_data;
end
assign read_data = memread ? mem[address[9:2]] : 32'b0;
endmodule
