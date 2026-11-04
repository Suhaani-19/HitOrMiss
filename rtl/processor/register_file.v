module register_file(
    input clk, input reset,
    input regwrite, input [4:0] read_reg1, input [4:0] read_reg2,
    input [4:0] write_reg, input [31:0] write_data,
    output [31:0] read_data1, output [31:0] read_data2
);
reg [31:0] regs [0:31];
integer i;
always @(posedge clk) begin
    if (reset) begin
        for (i=0; i<32; i=i+1) regs[i] <= 0;
    end else if (regwrite && (write_reg != 0)) begin
        regs[write_reg] <= write_data;
    end
end
assign read_data1 = (read_reg1 == 0) ? 0 : regs[read_reg1];
assign read_data2 = (read_reg2 == 0) ? 0 : regs[read_reg2];
endmodule
