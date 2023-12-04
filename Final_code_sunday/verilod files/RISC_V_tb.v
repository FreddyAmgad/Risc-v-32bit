`timescale 1ns / 1ps
/*******************************************************************
*
* Module: RISC_V_tb.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: Testbench for the RISC-V processor implementation.
*
**********************************************************************/

module RISC_V_tb();
    localparam clk_period = 10;
    reg clk, rst;
    RISC_V pcs(clk, rst);
    
    initial begin
        clk = 1'b0;
        forever #(clk_period/2) clk = ~clk;
    end
    
    initial begin
    rst=1;
    #clk_period;
    rst = 0;
   #(clk_period *40);
    // #(clk_period * 30);
    $stop;
    end
    
endmodule
