`timescale 1ns / 1ps
/*******************************************************************
*
* Module: mux.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: This module implements a 4-to-1 multiplexer with configurable bit width.
*
**********************************************************************/


module mux #(parameter N=32)(
    input [N-1:0] A, B,
    input sel,
    output [N-1:0] Y
    );
    genvar i;
    generate
        for(i = 0; i<N; i=i+1) begin
            assign Y[i] = (sel==0)? A[i]:B[i];
         end
    endgenerate
    
endmodule
