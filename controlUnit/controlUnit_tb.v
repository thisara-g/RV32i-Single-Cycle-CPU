`timescale 1ns / 1ps

module controlUnit_tb;

    // Testbench signals
    reg [6:0] opcode;
    reg [2:0] funct;
    wire cntl_MemWrite;
    wire cntl_RegWrite;
    wire cntl_Branch;
    wire [2:0] sel_MemToReg;
    wire [1:0] sel_ALUSrc;
    wire [1:0] sel_jump;
    wire [3:0] ALUOp;

    // Instantiate the controlUnit
    controlUnit uut (
        .funct(funct),
        .opcode(opcode),
        .cntl_MemWrite(cntl_MemWrite),
        .cntl_RegWrite(cntl_RegWrite),
        .cntl_Branch(cntl_Branch),
        .sel_MemToReg(sel_MemToReg),
        .sel_ALUSrc(sel_ALUSrc),
        .sel_jump(sel_jump),
        .ALUOp(ALUOp)
    );

    // Task to display results
    task display_results;
        input [6:0] opcode_in;
        input [2:0] funct_in;
        begin
            $display("Opcode: %b, Funct: %b, MemWrite: %b, RegWrite: %b, Branch: %b, MemToReg: %b, ALUSrc: %b, Jump: %b, ALUOp: %b",
                      opcode_in, funct_in, cntl_MemWrite, cntl_RegWrite, cntl_Branch, sel_MemToReg, sel_ALUSrc, sel_jump, ALUOp);
        end
    endtask

    initial begin
        $display("Starting controlUnit testbench...");

        // Test case 1: Load instruction
        opcode = 7'b000_0011; funct = 3'b000; #10;
        display_results(opcode, funct);

        // Test case 2: Store instruction
        opcode = 7'b010_0011; funct = 3'b010; #10;
        display_results(opcode, funct);

        // Test case 3: R-type instruction
        opcode = 7'b011_0011; funct = 3'b000; #10;
        display_results(opcode, funct);

        // Test case 4: Branch instruction
        opcode = 7'b110_0011; funct = 3'b000; #10;
        display_results(opcode, funct);

        // Test case 5: AUIPC instruction
        opcode = 7'b001_0111; funct = 3'bxxx; #10;
        display_results(opcode, funct);

        // Test case 6: Invalid instruction
        opcode = 7'b111_1111; funct = 3'b111; #10;
        display_results(opcode, funct);

        $display("controlUnit testbench completed.");
        $stop;
    end

endmodule
