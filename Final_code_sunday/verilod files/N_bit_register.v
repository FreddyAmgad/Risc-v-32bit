`timescale 1ns / 1ps
/*******************************************************************
*
* Module: N_bit_register.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: N-bit register module with synchronous load functionality.
*
**********************************************************************/


module N_bit_register#(parameter N=32)(
    input clk, rst, load,
    input [N-1:0] D,
    output [N-1:0] Q
    );
    
    wire [N-1:0] Y;
    genvar i;
    generate
        for (i=0; i<N; i =i+1) begin
            DFlipFlop flip(clk,rst,Y[i],Q[i]);
            mux M(Q[i], D[i], load, Y[i]);
        end
    endgenerate
    
endmodule
