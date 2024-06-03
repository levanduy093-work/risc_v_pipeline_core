module tb();

    // Declaring the inputs and outputs
    reg clk=0,rst,PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD,PCD,PCPlus4D;
    
    // Declae the design under test
    fetch_cycle dut(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Generation of clock
    always begin
        clk = ~clk;
        #50;
    end

    // Provider the Stimulus
    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        PCSrcE <= 1'b0;
        PCTargetE <= 32'h00000000;
        #500;
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

endmodule