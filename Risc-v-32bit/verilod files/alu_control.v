`timescale 1ns / 1ps
/*******************************************************************
*
* Module: alu_control.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: Module for controlling the ALU operations based on ALUOp and funct3 signals.
*
**********************************************************************/


module alu_control(
    input[1:0] ALUOp,
    input [2:0] funct3,
    input Inst_30,
    input Inst_25,
    output reg[4:0] ALU_sel
    );
    
    always@(*) begin
        if(ALUOp==2'b00) //load and store
            ALU_sel = 5'b000_00;

        else if(ALUOp==2'b01) //branch
            ALU_sel = 5'b000_01;

        else if(ALUOp==2'b10) begin //R-tyoe and Mult

            if( (ALUOp==2'b10 && funct3==3'b000 && Inst_30==0 &&Inst_25==0 ) ) //add
                ALU_sel = 5'b000_00;
            else if(ALUOp==2'b10 && funct3==3'b000 && Inst_30==1&&Inst_25==0) //sub
                ALU_sel = 5'b000_01;
            else if(funct3==3'b100&&Inst_25==0) //xor 
                ALU_sel = 5'b001_11;
            else if(funct3==3'b110&&Inst_25==0) //or 
                ALU_sel = 5'b001_00;
            else if(funct3==3'b111&&Inst_25==0) //and
                ALU_sel = 5'b001_01;
            else if(funct3==3'b001&&Inst_25==0) //sll
                ALU_sel = 5'b010_01;
            else if(funct3==3'b010&&Inst_25==0) //SLT
                ALU_sel = 5'b011_01;
            else if(funct3==3'b011&&Inst_25==0) //SLTU
                ALU_sel = 5'b011_11;
            else if(funct3==3'b101 && Inst_30==0&&Inst_25==0) //srl 
                ALU_sel = 5'b010_00;
            else if(funct3==3'b101 && Inst_30==1&&Inst_25==0) //sra 
                ALU_sel = 5'b010_10;    
            else if(ALUOp==2'b10&&ALUOp==2'b10&&funct3==3'b000 && Inst_30==0&&Inst_25==1) //MUL
                ALU_sel = 5'b000_10; 
            else if(ALUOp==2'b10&&funct3==3'b001 && Inst_30==0&&Inst_25==1) //MULH
                ALU_sel = 5'b001_10; 
            else if(ALUOp==2'b10&&funct3==3'b011 && Inst_30==0&&Inst_25==1) //MULHU
                ALU_sel = 5'b010_11; 
             else if(ALUOp==2'b10&&funct3==3'b010 && Inst_30==0&&Inst_25==1) //MULHSU
                ALU_sel = 5'b011_00; 
             else if(ALUOp==2'b10&&funct3==3'b100 && Inst_30==0&&Inst_25==1) //DIV
                ALU_sel = 5'b011_10;
             else if(ALUOp==2'b10&&funct3==3'b101 && Inst_30==0&&Inst_25==1) //DIVU
                ALU_sel = 5'b100_00;
             else if(ALUOp==2'b10&&funct3==3'b110 && Inst_30==0&&Inst_25==1) //REM
                ALU_sel = 5'b100_01;
             else if(ALUOp==2'b10&&funct3==3'b111 && Inst_30==0&&Inst_25==1) //REMU
                ALU_sel = 5'b100_10;  
        end

        else if( ALUOp==2'b11) begin //I-type

            if( ALUOp==2'b11 && funct3==3'b000 ) // addi
                ALU_sel = 5'b000_00;
            else if(funct3==3'b100) // xori
                ALU_sel = 5'b001_11;
            else if(funct3==3'b110) //ori
                ALU_sel = 5'b001_00;
            else if(funct3==3'b111) // andi
                ALU_sel = 5'b001_01;
            else if(funct3==3'b001) // slli
                ALU_sel = 5'b010_01;
            else if(funct3==3'b010) //SLTI
                ALU_sel = 5'b011_01;
            else if(funct3==3'b011) //SLTIU
                ALU_sel = 5'b011_11;
            else if(funct3==3'b101 ) // srli
                ALU_sel = 5'b010_00;
            else if(funct3==3'b101) // srai
                ALU_sel = 5'b010_10;      
        end
        else
            ALU_sel = 4'b00_11; //The default case -ALU_PASS *need review*
    end  
  
endmodule
