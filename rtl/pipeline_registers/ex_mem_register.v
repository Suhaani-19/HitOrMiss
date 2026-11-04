module ex_mem_register(
    input clk, input reset,
    input regwrite_in, input memread_in, input memwrite_in, input memtoreg_in,
    input [31:0] alu_result_in, input [31:0] write_data_in, input [4:0] rd_in,
    output reg regwrite_out, output reg memread_out, output reg memwrite_out,
    output reg memtoreg_out, output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out, output reg [4:0] rd_out
);
always @(posedge clk) begin
    if (reset) begin
        regwrite_out<=0; memread_out<=0; memwrite_out<=0; memtoreg_out<=0;
        alu_result_out<=0; write_data_out<=0; rd_out<=0;
    end else begin
        regwrite_out<=regwrite_in; memread_out<=memread_in; memwrite_out<=memwrite_in;
        memtoreg_out<=memtoreg_in; alu_result_out<=alu_result_in;
        write_data_out<=write_data_in; rd_out<=rd_in;
    end
end
endmodule
