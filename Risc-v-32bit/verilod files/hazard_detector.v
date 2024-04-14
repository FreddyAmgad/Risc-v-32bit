`timescale 1ns / 1ps
/*******************************************************************
*
* Module: hazard_detector.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: The hazard_detector module is crucial for identifying load-use hazards in the pipeline. 
* If a hazard is detected, it signals the need to stall the pipeline, preventing the execution of subsequent instructions until 
* the hazard is resolved. This is essential for maintaining correct program execution and data integrity.
*
**********************************************************************/


module hazard_detector(
    input [4:0] IF_ID_Rs1, IF_ID_Rs2, ID_EX_Rd,
    input ID_EX_MemRead,
    output reg stall
    );
    
    always @(*) begin
        if  (((IF_ID_Rs1==ID_EX_Rd)||(IF_ID_Rs2==ID_EX_Rd)) && ID_EX_MemRead && (ID_EX_Rd != 0) )
            stall = 1;
        else 
            stall = 0;
    end
    
endmodule
