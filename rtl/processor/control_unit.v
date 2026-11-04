module control_unit(
    input [6:0] opcode, input [2:0] funct3, input [6:0] funct7,
    output reg regwrite, output reg memread, output reg memwrite,
    output reg memtoreg, output reg alusrc, output reg [3:0] alucontrol,
    output reg uses_rs1, output reg uses_rs2
);
always @(*) begin
    regwrite=0; memread=0; memwrite=0; memtoreg=0; alusrc=0;
    alucontrol=4'b0000; uses_rs1=0; uses_rs2=0;
    case (opcode)
        7'b0110011: begin // R type
            regwrite=1; uses_rs1=1; uses_rs2=1;
            case (funct3)
                3'b000: alucontrol = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000;
                3'b111: alucontrol = 4'b0010;
                3'b110: alucontrol = 4'b0011;
                default: begin regwrite=0; alucontrol=0; end
            endcase
        end
        7'b0010011: begin // ADDI
            regwrite=1; alusrc=1; uses_rs1=1; alucontrol=4'b0000;
        end
        7'b0000011: begin // LW
            regwrite=1; memread=1; memtoreg=1; alusrc=1; uses_rs1=1;
            alucontrol=4'b0000;
        end
        7'b0100011: begin // SW
            memwrite=1; alusrc=1; uses_rs1=1; uses_rs2=1; alucontrol=4'b0000;
        end
        default: begin end
    endcase
end
endmodule
