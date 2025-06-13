`timescale 1ns / 1ps

module ALU_tb;

    // Testbench signals
    reg [2:0] funct;
    reg [31:0] op1, op2;
    reg [3:0] ALUcntl;
    wire [31:0] ALUResult;
    wire ExeBranch;

    // Instantiate the ALU module
    ALU uut (
        .funct(funct),
        .op1(op1),
        .op2(op2),
        .ALUcntl(ALUcntl),
        .ALUResult(ALUResult),
        .ExeBranch(ExeBranch)
    );

    // Initial values and test procedure
    initial begin
        // Test case 1: AND operation
        $display("Test 1: AND operation");
        op1 = 32'hF0F0F0F0;
        op2 = 32'h0F0F0F0F;
        ALUcntl = 4'b0000; // AND operation
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'h00000000

        // Test case 2: OR operation
        $display("Test 2: OR operation");
        ALUcntl = 4'b0001; // OR operation
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'h0F0F0F0F

        // Test case 3: XOR operation
        $display("Test 3: XOR operation");
        ALUcntl = 4'b0010; // XOR operation
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'hFFFFFFFF

        // Test case 4: Left Shift operation
        $display("Test 4: Left Shift operation");
        op2 = 32'd2;  // Shift by 2
        ALUcntl = 4'b0011; // LSL operation
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'hF0F0F0F0 shifted left by 2

        // Test case 5: Right Shift operation
        $display("Test 5: Right Shift operation");
        ALUcntl = 4'b0100; // RSL operation
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'h03C0C0C0

        // Test case 6: Arithmetic Right Shift operation
        $display("Test 6: Arithmetic Right Shift operation");
        ALUcntl = 4'b0101; // RSA operation
        #10;
        $display("ALUResult = %h", ALUResult);

        // Test case 7: Addition operation
        $display("Test 7: Addition operation");
        op1 = 32'd10;
        op2 = 32'd20;
        ALUcntl = 4'b0110; // ADD operation
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'd30

        // Test case 8: Subtraction operation
        $display("Test 8: Subtraction operation");
        ALUcntl = 4'b0111; // SUB operation
        funct = 3'b010;    // ALU performs subtraction
        #10;
        $display("ALUResult = %h", ALUResult);  // Expect 32'd-10

        // Test case 9: Branch equal (BEQ)
        $display("Test 9: Branch Equal (BEQ)");
        ALUcntl = 4'b0111; // SUB operation
        funct = 3'b000;    // BEQ operation (ALUResult == 0)
        op1 = 32'd5;
        op2 = 32'd5;
        #10;
        $display("ExeBranch = %b", ExeBranch);  // Expect ExeBranch = 1 (true)

        // Test case 10: Branch not equal (BNE)
        $display("Test 10: Branch Not Equal (BNE)");
        funct = 3'b001;    // BNE operation (ALUResult != 0)
        op2 = 32'd10;
        #10;
        $display("ExeBranch = %b", ExeBranch);  // Expect ExeBranch = 0 (false)

        // Test case 11: Branch Less Than (BLT)
        $display("Test 11: Branch Less Than (BLT)");
        funct = 3'b100;    // BLT operation (ALUResult < 0)
        op1 = 32'd5;
        op2 = 32'd10;
        #10;
        $display("ExeBranch = %b", ExeBranch);  // Expect ExeBranch = 1 (true)

        // Test case 12: Branch Greater Than or Equal (BGE)
        $display("Test 12: Branch Greater Than or Equal (BGE)");
        funct = 3'b101;    // BGE operation (ALUResult >= 0)
        op1 = 32'd10;
        op2 = 32'd5;
        #10;
        $display("ExeBranch = %b", ExeBranch);  // Expect ExeBranch = 1 (true)

        // Test case 13: Branch Less Than Unsigned (BLTU)
        $display("Test 13: Branch Less Than Unsigned (BLTU)");
        funct = 3'b110;    // BLTU operation (unsigned ALUResult < 0)
        op1 = 32'd15;
        op2 = 32'd20;
        #10;
        $display("ExeBranch = %b", ExeBranch);  // Expect ExeBranch = 1 (true)

        // Test case 14: Branch Greater Than or Equal Unsigned (BGEU)
        $display("Test 14: Branch Greater Than or Equal Unsigned (BGEU)");
        funct = 3'b111;    // BGEU operation (unsigned ALUResult >= 0)
        op1 = 32'd25;
        op2 = 32'd20;
        #10;
        $display("ExeBranch = %b", ExeBranch);  // Expect ExeBranch = 1 (true)

        // End simulation
        $finish;
    end

endmodule
