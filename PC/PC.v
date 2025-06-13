`timescale 1ns / 1ps

module PC(
    input clk,
    input reset_n,
    input [31:0] nextPC,
    output reg [31:0] currPC
    );
    
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            currPC <= 0;
        end
        else begin
            currPC <= nextPC;
        end
    end
    
endmodule