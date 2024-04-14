`timescale 1ns / 1ps
/*******************************************************************
*
* Module: branch_control.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: Module to select the implemented branch operation instead of the AND gate.
* Change History:
* 11/12/2023 – Module created by Fekry Mohamed, Mario Ghaly, and Freddy Amgad
* 11/19/2023 – Fixed capitalization issue in line 8 (b in branch)
*
**********************************************************************/

module branch_control(
	input   wire branch, cf, zf, vf, sf,
    input  wire  [2:0] funct3,
	output  reg  branch_out
);

    always @ (*) begin
        if(branch)
        begin
            if( (funct3==3'b000) && zf ) // BR_BEQ
                branch_out=1;
            else if((funct3==3'b001) && ~zf) //BR_BNE
                branch_out=1;
            else if((funct3==3'b100) && (sf!=vf)) //BR_BLT
                branch_out=1;
            else if((funct3==3'b101) && (sf==vf)) //BR_BGE
                branch_out=1;
            else if((funct3==3'b110) && ~cf) //BR_BLTU
                branch_out=1;
            else if((funct3==3'b111) && cf ) //BR_BGEU *do not handle if both inputs are zeros
                branch_out=1;
            else
                branch_out=0;
         end
        else 
            branch_out=0;
    end


endmodule
