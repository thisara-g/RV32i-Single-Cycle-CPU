`timescale 1ns / 1ps

module ALUContrl_tb;

    // Testbench signals
    reg [3:0] funct;
    reg [3:0] ALUOp;
    wire [3:0] ALUcntl;

    // Instantiate the ALUContrl module
    ALUContrl uut (
        .funct(funct),
        .ALUOp(ALUOp),
        .ALUcntl(ALUcntl)
    );

    // Task to display results
    task display_result;
        input [3:0] expected;
        begin
            $display("ALUOp = %b, funct = %b, ALUcntl = %b, Expected = %b [%s]",
                     ALUOp, funct, ALUcntl, expected, (ALUcntl == expected) ? "PASS" : "FAIL");
        end
    endtask

    initial begin
        // Test cases
        $display("Starting ALUContrl testbench...");
        
        // Test case 1: Load instruction (ALUOp = 0000)
        ALUOp = 4'b0000; funct = 4'b0000; #10;
        display_result(4'b0110); // ADD expected

        // Test case 2: ADDI instruction (ALUOp = 0001, funct = 0000)
        ALUOp = 4'b0001; funct = 4'b0000; #10;
        display_result(4'b0110); // ADD expected

        // Test case 3: ORI instruction (ALUOp = 0001, funct = 110)
        ALUOp = 4'b0001; funct = 4'b0110; #10;
        display_result(4'b0001); // OR expected

        // Test case 4: Subtraction instruction (ALUOp = 0100, funct = 1000)
        ALUOp = 4'b0100; funct = 4'b1000; #10;
        display_result(4'b0111); // SUB expected

        // Test case 5: Logical Shift Left (ALUOp = 0001, funct = 0010)
        ALUOp = 4'b0001; funct = 4'b0010; #10;
        display_result(4'b0011); // LSL expected

        // Test case 6: Invalid ALUOp
        ALUOp = 4'b1111; funct = 4'b0000; #10;
        display_result(4'bxxxx); // Undefined behavior

        // End of testing
        $display("ALUContrl testbench completed.");
        $stop;
    end

endmodule
