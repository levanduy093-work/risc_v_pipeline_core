module ALU(A,B,ALUControl,Result,Negative,Zero,Carry,OverFlow);

    input [31:0] A,B;
    input [2:0] ALUControl;
    output [31:0] Result;
    output Negative,Zero,Carry,OverFlow;

    wire Cout;
    wire [31:0] Sum;

    assign {Cout,Sum} = (ALUControl[0] == 1'b0) ? A + B : (A + ((~B)+1));

    assign Result = (ALUControl == 3'b000) ? Sum :
                    (ALUControl == 3'b001) ? Sum :
                    (ALUControl == 3'b010) ? A & B :
                    (ALUControl == 3'b011) ? A | B :
                    (ALUControl == 3'b101) ? {{31{1'b0}},(Sum[31])} : {32{1'b0}};

    assign OverFlow = ((~ALUControl[1]) &
                      (Sum[31] ^ A[31]) &
                      (~(ALUControl[0] ^ A[31] ^ B[31])));

    assign Carry = (Cout & (~ALUControl[1]));

    assign Negative = Result[31];

    assign Zero = &(~Result);


endmodule