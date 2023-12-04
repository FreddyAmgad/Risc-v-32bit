`timescale 1ns / 1ps
/*******************************************************************
*
* Module: shifter.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: This module implements a shifter to support shifting in the prv32_ALU.v module.
*
**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////
// new module to support the shifting in the prv32_ALU.v module 
//////////////////////////////////////////////////////////////////////////////////

module shifter(
	input   wire [31:0] a,
	input   wire [4:0]  shamt,
	input   wire [1:0]  type,
	output  reg  [31:0] r
);
 

    always @ * begin
        case (type)
            //SRL
            2'b00:  r = a>>shamt;
            //SLL
            2'b01: 
             r = a<<shamt;
            //SRA
            2'b10:  r = $signed(a)>>>shamt;
            default: r = a>>shamt;
        endcase
    end


endmodule