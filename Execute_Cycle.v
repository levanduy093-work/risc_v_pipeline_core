module execute_cycle(clk,rst,RegWriteE,ALUSrcE,MemWriteE,ResultSrcE,BranchE,ALUControlE,RD1_E,RD2_E,Imm_Ext_E,
    RD_E,PCE,PCPlus4E,PCSrcE,PCTargetE,RegWriteM,MemWriteM,ResultSrcM,RD_M,PCPlus4M,WriteDataM,ALU_ResultM);

    // Declaration input and output ports
    input clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    input [2:0] ALUControlE;
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;

    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    output [4:0] RD_M;
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output [31:0] PCTargetE;

    // Declaration of Interim Wires
    wire [31:0] Src_B;
    wire [31:0] ResultE;
    wire ZeroE;

    // Declaration of Registers
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;


    // Declaration of Module
    // ALU Src Mux
    Mux alu_src_mux (
        .a(RD2_E),
        .b(Imm_Ext_E),
        .s(ALUSrcE),
        .c(Src_B)
    );

    // ALU Unit
    ALU alu (
        .A(RD1_E),
        .B(Src_B),
        .ALUControl(ALUControlE),
        .Result(ResultE),
        .Negative(),
        .Zero(ZeroE),
        .Carry(),
        .OverFlow()
    );

    // Adder
    PC_Adder branch_adder (
        .a(PCE),
        .b(Imm_Ext_E),
        .c(PCTargetE)
    );

    // Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteE_r <= 1'b0;
            MemWriteE_r <= 1'b0;
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'b0;
            PCPlus4E_r <= 32'b0;
            RD2_E_r <= 32'b0;
            ResultE_r <= 32'b0;
        end else begin
            RegWriteE_r <= RegWriteE;
            MemWriteE_r <= MemWriteE;
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E;
            RD2_E_r <= RD2_E;
            ResultE_r <= ResultE;
        end
    end

    // Output Assignment
    assign PCSrcE = BranchE & ZeroE;
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule