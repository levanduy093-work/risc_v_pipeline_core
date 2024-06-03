module fetch_cycle(clk,rst,PCSrcE,PCTargetE,InstrD,PCD,PCPlus4D);

    // Declaring input and output ports
    input clk,rst;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD,PCD,PCPlus4D;

    // Declaring interim wires
    wire [31:0] PC_F,PCF,PCPlus4F;
    wire [31:0] InstrF;

    // Declaration of Register
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg,PCPlus4F_reg;

    // Initiation of Modules
    // Declaring PC Mux

    Mux PC_MUX(
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );

    // Declaring PC Counter
    PC_Module Program_Counter(
        .clk(clk),
        .rst(rst),
        .PC(PCF),
        .PC_Next(PC_F)
    );

    // Declaring Instruction Memory
    Instruction_Memory IMEM(
        .rst(rst),
        .A(PCF),
        .RD(InstrF)
    );

    // Declaring PC Adder
    PC_Adder PC_adder(
        .a(PCF),
        .b(32'h00000004),
        .c(PCPlus4F)
    );

    // Fetch Cycle Registers Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    // Assign Registers Value to the Output Ports
    assign InstrD = (rst == 1'b0) ? 32'h00000000 : InstrF_reg;
    assign PCD = (rst == 1'b0) ? 32'h00000000 : PCF_reg;
    assign PCPlus4D = (rst == 1'b0) ? 32'h00000000 : PCPlus4F_reg;


endmodule