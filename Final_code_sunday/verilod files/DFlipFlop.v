`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DFlipFlop.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: D flip-flop with asynchronous reset.
*
**********************************************************************/


module DFlipFlop(input clk, input rst, input D, output reg Q);
    always @ (posedge clk or posedge rst)
        if (rst) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
endmodule 
