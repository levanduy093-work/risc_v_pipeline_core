module writeback_cycle(clk,rst,ResultSrcW,ALU_ResultW,ReadDataW,PCPlus4W,ResultW);

    // Declaration input and output ports
    input clk, rst, ResultSrcW;
    input [31:0] ALU_ResultW, ReadDataW, PCPlus4W;

    output [31:0] ResultW;

    // Declaration of module
    Mux result_mux (
        .a(ALU_ResultW),
        .b(ReadDataW),
        .s(ResultSrcW),
        .c(ResultW)
    );

endmodule