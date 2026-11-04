module forwarding_unit(
    input [4:0] idex_rs1, input [4:0] idex_rs2,
    input [4:0] exmem_rd, input exmem_regwrite,
    input [4:0] memwb_rd, input memwb_regwrite,
    output reg [1:0] forward_a, output reg [1:0] forward_b
);
// 00 = ID/EX value, 10 = EX/MEM value, 01 = MEM/WB value.
// EX/MEM is checked first, so it has priority when both stages match.
always @(*) begin
    forward_a = 2'b00;
    forward_b = 2'b00;
    if (exmem_regwrite && (exmem_rd != 0) && (exmem_rd == idex_rs1))
        forward_a = 2'b10;
    else if (memwb_regwrite && (memwb_rd != 0) && (memwb_rd == idex_rs1))
        forward_a = 2'b01;

    if (exmem_regwrite && (exmem_rd != 0) && (exmem_rd == idex_rs2))
        forward_b = 2'b10;
    else if (memwb_regwrite && (memwb_rd != 0) && (memwb_rd == idex_rs2))
        forward_b = 2'b01;
end
endmodule
