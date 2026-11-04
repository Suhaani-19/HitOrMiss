module hazard_detection_unit(
    input idex_memread, input [4:0] idex_rd,
    input [4:0] ifid_rs1, input [4:0] ifid_rs2,
    input ifid_uses_rs1, input ifid_uses_rs2,
    output reg stall
);
always @(*) begin
    stall = idex_memread && (idex_rd != 0) &&
            ((ifid_uses_rs1 && (idex_rd == ifid_rs1)) ||
             (ifid_uses_rs2 && (idex_rd == ifid_rs2)));
end
endmodule