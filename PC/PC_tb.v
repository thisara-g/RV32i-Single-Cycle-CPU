`timescale 1ns / 1ps

module PC_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg [31:0] nextPC;
    wire [31:0] currPC;

    // Instantiate the PC module
    PC uut (
        .clk(clk),
        .reset_n(reset_n),
        .nextPC(nextPC),
        .currPC(currPC)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock (10ns period)
    end

    // Initial values and test procedure
    initial begin
        // Initial values
        clk = 0;
        reset_n = 0;
        nextPC = 32'd0;

        // Apply reset
        $display("Applying reset...");
        #10;
        reset_n = 1;  // Deassert reset

        // Test 1: Set nextPC to 32'h1000 and check currPC
        nextPC = 32'h1000;
        #10;
        $display("Test 1: nextPC = %h, currPC = %h", nextPC, currPC); // Expect currPC = 0x1000

        // Test 2: Set nextPC to 32'h2000 and check currPC
        nextPC = 32'h2000;
        #10;
        $display("Test 2: nextPC = %h, currPC = %h", nextPC, currPC); // Expect currPC = 0x2000

        // Test 3: Apply reset again
        reset_n = 0;
        #10;
        $display("Test 3: After reset, currPC = %h", currPC); // Expect currPC = 0x0000

        // Test 4: Set nextPC to 32'h3000 and check currPC
        reset_n = 1;
        nextPC = 32'h3000;
        #10;
        $display("Test 4: nextPC = %h, currPC = %h", nextPC, currPC); // Expect currPC = 0x3000

        // Test 5: Set nextPC to 32'h4000 and check currPC
        nextPC = 32'h4000;
        #10;
        $display("Test 5: nextPC = %h, currPC = %h", nextPC, currPC); // Expect currPC = 0x4000

        // End simulation
        $finish;
    end

endmodule
