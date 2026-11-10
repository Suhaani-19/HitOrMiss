module alu(input [31:0] a, input [31:0] b, input [3:0] control, output reg [31:0] result);
always @(*) begin
    case (control)
        4'b0000: result = a + b; // ADD
        4'b0001: result = a - b; // SUB
        4'b0010: result = a & b; // AND
        4'b0011: result = a | b; // OR
        default: result = 0;
    endcase
end
endmodule
