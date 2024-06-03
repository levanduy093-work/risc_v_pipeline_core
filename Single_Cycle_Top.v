`include "PC.v"
`include "PC_Adder.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "Mux.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"

module Single_Cycle_Top(clk,rst);
    
    input clk,rst;

    wire [31:0] PC_Top,RD_Instr,RD1_Top,RD2_Top,Imm_Ext_Top,PCPlus4,SrcB,ALUResult,ReadData,Result;
    wire RegWrite,MemWrite,ALUSrc,ResultSrc;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl_Top;

    PC_Module PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_Next(PCPlus4)
    );

    PC_Adder PC_Adder(
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4)
    );

    Instruction_Memory Instruction_Memory(
        .rst(rst),
        .A(PC_Top),
        .RD(RD_Instr)
    );

    Register_File Register_File(
        .clk(clk),
        .rst(rst),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),
        .A3(RD_Instr[11:7]),
        .RD1(RD1_Top),
        .RD2(RD2_Top),
        .WD3(Result),
        .WE3(RegWrite)
    );

    Sign_Extend Sign_Extend(
        .In(RD_Instr),
        .Imm_Ext(Imm_Ext_Top),
        .ImmSrc(ImmSrc)
    );

    Mux Mux_Register_to_ALU(
        .a(RD2_Top),
        .b(Imm_Ext_Top),
        .s(ALUSrc),
        .c(SrcB)
    );

    ALU ALU(
        .A(RD1_Top),
        .B(SrcB),
        .ALUControl(ALUControl_Top),
        .Result(ALUResult),
        .Negative(),
        .Zero(),
        .Carry(),
        .OverFlow()
    );

    Control_Unit_Top Control_Unit_Top(
        .Op(RD_Instr[6:0]),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(),
        .funct3(RD_Instr[14:12]),
        .funct7(RD_Instr[6:0]),
        .ALUControl(ALUControl_Top)
    );

    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .A(ALUResult),
        .WD(RD2_Top),
        .WE(MemWrite),
        .RD(ReadData)
    );

    Mux Mux_DataMemory_to_Register(
        .a(ALUResult),
        .b(ReadData),
        .s(ResultSrc),
        .c(Result)
    );

endmodule