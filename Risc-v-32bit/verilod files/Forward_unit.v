`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Forward_unit.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: The Forward_unit module implements forwarding logic for operands A and B in a processor pipeline. 
* It checks for data hazards and determines whether to forward data from the output of the EX/MEM or MEM/WB stage
* to the current stage in the pipeline. The output signals forwardA and forwardB indicate the forwarding status for 
* operand A and operand B, respectively.
*
**********************************************************************/


module Forward_unit(
 input[4:0] ID_EX_RegisterRs1,ID_EX_RegisterRs2,EX_MEM_RegisterRd,MEM_WB_RegisterRd,
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    output reg[1:0] forwardA, forwardB
    );
    
     always@(*) begin 
        if ( (EX_MEM_RegWrite) && (EX_MEM_RegisterRd != 0)&& (EX_MEM_RegisterRd == ID_EX_RegisterRs1))
	       forwardA = 2'b10;
	    
	    else if ( (MEM_WB_RegWrite) && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs1))  // we removed the final condition because it will not reach this state unless the ablove condition is already false
     	   forwardA = 2'b01;
        else 
            forwardA = 2'b00;        
        end  
    
    always@(*) begin 
        
        if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) 
	       forwardB = 2'b10;
	    
	    else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs2))  // we removed the final condition because it will not reach this state unless the ablove condition is already false
     	   forwardB = 2'b01;
        else 
           forwardB = 2'b00;        
    end   
endmodule
