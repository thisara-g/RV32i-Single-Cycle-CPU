`timescale 1ns / 1ps


module processor(
    input clk, 
    input reset_n
    );
    
    /* PC-related wires */ 
    wire [31:0] PCplus4;
    wire [31:0] currPC;
    wire [31:0] nextPC;
    
    /* Instruction memory related wires*/
    wire [31:0] currInstr;
    
    /* Data memory related wires*/
    wire [31:0] DMemReadData;
    wire [31:0] DMemReadData_width;
    wire [31:0] DMemWriteData_width;
    
    /* Register File related wires */
    wire [31:0] ReadRegData1;
    wire [31:0] ReadRegData2;
    wire [31:0] WriteData;
    wire [31:0] StoreData;
    wire [31:0] WriteRegData;
    
    /* ALU-related wires */
    wire [3:0] ALUOp;
    wire [3:0] ALUcntl;
    wire [31:0] ALUop2;
    wire [31:0] ALUResult;
    
    
    /* immeduate wire */
    wire [31:0] immediate;
    
    /* Control signal wires */
    wire cntl_MemWrite;
    wire cntl_RegWrite;
    wire cntl_Branch;
    wire [1:0] sel_ALUSrc;          //00: ReadData2, 01: immediate, 10: shamt
    wire [2:0] sel_MemToReg;        //000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    wire [1:0] sel_jump;
    
    /* Branch address */
    wire ExeBranch;
    wire [31:0] BranchAddr;

    /* Next PC = PC + 4 */
    Adder PCAdder(.op1(currPC), .op2(32'd4), .result(PCplus4));
    
    /* update PC */
    assign nextPC = (sel_jump == 2'b01) ? ALUResult : 
                    (sel_jump == 2'b10) ? BranchAddr : 
                    ((cntl_Branch & ExeBranch) == 1) ? BranchAddr : PCplus4;
    PC PC(.clk(clk), .reset_n(reset_n), .nextPC(nextPC), .currPC(currPC));
    
    /* Instruction Memory access */
    instrMem IMem(.iaddr(currPC), .dout(currInstr));
    
    /* Immediate generation */
    immGen ImmGen(.currInstr(currInstr), .immediate(immediate));
    
    /* Register File */
    assign WriteRegData =   (sel_MemToReg == 3'b000) ? ALUResult : 
                            (sel_MemToReg == 3'b001) ? DMemReadData_width :
                            (sel_MemToReg == 3'b010) ? immediate : 
                            (sel_MemToReg == 3'b011) ? BranchAddr : 
                            (sel_MemToReg == 3'b100) ? PCplus4 : 32'hxxxx_xxxx;
    regFile RF(.clk(clk), .rs1(currInstr[19:15]), .rs2(currInstr[24:20]), .wraddr(currInstr[11:7]), .wrdata(WriteRegData), .we(cntl_RegWrite), .rdout1(ReadRegData1), .rdout2(ReadRegData2));
    
    /* Control Unit */
    controlUnit control(.funct(currInstr[14:12]), .opcode(currInstr[6:0]), .ALUOp(ALUOp), .cntl_MemWrite(cntl_MemWrite), .cntl_RegWrite(cntl_RegWrite), .cntl_Branch(cntl_Branch), .sel_jump(sel_jump), .sel_MemToReg(sel_MemToReg), .sel_ALUSrc(sel_ALUSrc));
    
    /* ALU control */
    ALUContrl ALUcontrol(.funct({currInstr[30], currInstr[14:12]}), .ALUOp(ALUOp), .ALUcntl(ALUcntl));
    
    /* ALU */
    assign ALUop2 = (sel_ALUSrc == 2'b00) ? ReadRegData2 :
                    (sel_ALUSrc == 2'b01) ? immediate : 
                    (sel_ALUSrc == 2'b10) ? {27'b0, currInstr[24:20]} : 32'hxxxx_xxxx;      // I - type SLL & SRL
    ALU alu(.op1(ReadRegData1), .op2(ALUop2), .funct(currInstr[14:12]), .ALUcntl(ALUcntl), .ALUResult(ALUResult), .ExeBranch(ExeBranch));
    
    /* Branch PC = PC + Immediate */
    Adder BranchAdder(.op1(currPC), .op2(immediate), .result(BranchAddr));
    
    /*  Width Cntrol for Data Memory Write Data */
    widthContrl DMemWriteWidth(.funct3(currInstr[14:12]), .word(ReadRegData2), .OutputWord(DMemWriteData_width));
    
    /* Data Memory access */
    dataMem DMem(.clk(clk), .MemWrite(cntl_MemWrite), .addr(ALUResult), .din(DMemWriteData_width), .dout(DMemReadData));
    
    /* Width Cntrol for Register File Write Data */
    widthContrl RFWriteWidth(.funct3(currInstr[14:12]), .word(DMemReadData), .OutputWord(DMemReadData_width));

endmodule