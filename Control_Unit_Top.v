`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module Control_Unit_Top(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,funct3,funct7,ALUControl);

    input [6:0] Op,funct7;
    input [2:0] funct3;
    output [1:0] ImmSrc;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
    output [2:0] ALUControl;

    wire [1:0] ALUOp;

    Main_Decoder Main_Decoder(
        .Op(Op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    ALU_Decoder ALU_Decoder(
        .Op(Op),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

endmodule