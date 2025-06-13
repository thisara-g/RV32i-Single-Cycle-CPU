`timescale 1ns / 1ps

module processor_tb;

    // Testbench variables
    reg clk;
    reg reset_n;

    // Instantiate the processor module
    processor uut (
        .clk(clk),
        .reset_n(reset_n)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Reset logic and test sequence
    initial begin
        // Apply reset
        reset_n = 0;
        #15; // Hold reset for 15ns
        reset_n = 1;

        // Monitor signals (Optional, for debugging)
        $monitor("Time=%0t | currPC=%h | currInstr=%h | ALUResult=%h | MemWrite=%b | MemRead=%b | Branch=%b",
                 $time, uut.currPC, uut.currInstr, uut.ALUResult, uut.cntl_MemWrite, uut.cntl_RegWrite, uut.cntl_Branch);

        // Run for a fixed number of clock cycles
        #15000; // Simulate for 200ns
        $finish;
    end

    initial begin
        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);
    end

endmodule