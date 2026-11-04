module mem_wb_register(
    input clk, input reset,
    input regwrite_in, input memtoreg_in,
    input [31:0] alu_result_in, input [31:0] mem_data_in, input [4:0] rd_in,
    output reg regwrite_out, output reg memtoreg_out,
    output reg [31:0] alu_result_out, output reg [31:0] mem_data_out, output reg [4:0] rd_out
);
always @(posedge clk) begin
    if (reset) begin
        regwrite_out<=0; memtoreg_out<=0; alu_result_out<=0; mem_data_out<=0; rd_out<=0;
    end else begin
        regwrite_out<=regwrite_in; memtoreg_out<=memtoreg_in;
        alu_result_out<=alu_result_in; mem_data_out<=mem_data_in; rd_out<=rd_in;
    end
end
endmodule
