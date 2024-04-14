`timescale 1ns / 1ps
/*******************************************************************
*
* Module: four_by_two_mux.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: Four-by-two multiplexer with parameterized bit-width.
*
**********************************************************************/


module four_by_two_mux #(parameter N= 32)(input [N-1:0] A, B, C, D, input [1:0] sel, output [N-1:0] Y);
    wire [N-1:0] out_AB, out_CD;
    mux #(N) mx1(A, B, sel[0], out_AB);
    mux #(N) mx2(C, D, sel[0], out_CD);
    mux #(N) mx12(out_AB, out_CD, sel[1], Y);
endmodule