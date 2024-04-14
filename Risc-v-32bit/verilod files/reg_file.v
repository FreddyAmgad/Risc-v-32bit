`timescale 1ns / 1ps
/*******************************************************************
*
* Module: reg_file.v
* Project: femtoRV32
* Authors: Fekry Mohamed, Mario Ghaly, Freddy Amgad
* Description: Register file module with read and write functionality.
*
**********************************************************************/



module reg_file#(parameter N=32)(
    input clk, rst,
    input[4:0] read_reg1, read_reg2,
    input [4:0] write_reg,
    input [31:0]write_data,
    input RegWrite,
    output [31:0] read_data1, read_data2
    );
    
    reg [N-1:0] regFile[31:0];
    integer i;
    
    always@(posedge(clk)) begin
        if(rst==1'b1)begin
            for(i=0; i<32; i=i+1)
                regFile[i] <= 0;
        end
        else if(RegWrite==1 && write_reg != 0)
            regFile[write_reg] <= write_data;
    end
    assign read_data1= regFile[read_reg1];    
    assign read_data2= regFile[read_reg2];    
    
endmodule
