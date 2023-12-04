`timescale 1ns / 1ps
/*******************************************************************
*
* Module: control_unit.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: module that generate the control signals for each instruction during the decoding phase
*
* Change History:
* 11/12/2023 – Module that needs modifications to support jal/jalr/lui/auipc/ecall/ebreak.
* 11/15/2023 – JAL, JALR, LUI, AUIPC, EBREAK supported
* 11/16/2023 – Removed support for ECALL and FENCE, as they are handled in INSMEM by changing the instruction into add x0, x0, x9
* 11/16/2023 – support multiplication and division

*
**********************************************************************/


`include "defines.v"

module control_unit(
    input[6:0] IR,
    input[2:0] funct3, // for load and store instructions
    output reg [1:0] ALUOp,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Byte, HalfWord, ZeroExtention,
    output reg [1:0]PC_mux_sel, 
    output reg [1:0]Wb_Mux_sel
    );
    
    always@(*) begin
        Byte=0; HalfWord=0; ZeroExtention=0; //default values
        case(`OPCODE)
            `OPCODE_Arith_R: begin //R-type
                Branch=0; MemRead=0; MemtoReg=0; ALUOp= 2'b10; MemWrite=0; ALUSrc=0; RegWrite=1;PC_mux_sel=2'b00;Wb_Mux_sel=2'b00;
            end 

            `OPCODE_Arith_I: begin //I-type -- same opcode like the R-type. The only diiference is ALUSrc and ALUOP =11
                Branch=0; MemRead=0; MemtoReg=0; ALUOp= 2'b11; MemWrite=0; ALUSrc=1; RegWrite=1;PC_mux_sel=2'b00;Wb_Mux_sel=2'b00;
            end

            `OPCODE_Load: begin // Load instutiins -- I-type.  *modificatied to diffrentiate load word/half/byte*
                Branch=0; MemRead=1; MemtoReg=1; ALUOp= 2'b00; MemWrite=0; ALUSrc=1; RegWrite=1;PC_mux_sel=2'b00;Wb_Mux_sel=2'b00;

                case(funct3)
                    3'b000: begin Byte=1; HalfWord=0; ZeroExtention=0; end //lb
                    3'b001: begin Byte=0; HalfWord=1; ZeroExtention=0; end //lh
                    3'b100: begin Byte=1; HalfWord=0; ZeroExtention=1; end //lbu
                    3'b101: begin Byte=0; HalfWord=1; ZeroExtention=1; end //lhu
                    default: begin Byte=0; HalfWord=0; ZeroExtention=0; end
                endcase

            end 
            
            `OPCODE_Store: begin //S-type *modificatied to diffrentiate load word/half/byte*
                Branch=0; MemRead=0; MemtoReg=0; ALUOp= 2'b00; MemWrite=1; ALUSrc=1; RegWrite=0;PC_mux_sel=2'b00;Wb_Mux_sel=2'b00;

                case(funct3)
                    3'b000: begin Byte=1; HalfWord=0; ZeroExtention=0; end //sb
                    3'b001: begin Byte=0; HalfWord=1; ZeroExtention=0; end//sh
                    default: begin Byte=0; HalfWord=0; ZeroExtention=0; end
                endcase
            end 
            
            `OPCODE_Branch: begin //Branch -- B-type
                Branch=1; MemRead=0; MemtoReg=0; ALUOp= 2'b01; MemWrite=0; ALUSrc=0; RegWrite=0;PC_mux_sel=2'b00;Wb_Mux_sel=2'b00;
            end
            
            `OPCODE_JAL: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 1;PC_mux_sel=2'b01;Wb_Mux_sel=2'b01;
            end
            
            `OPCODE_JALR: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 1;PC_mux_sel=2'b10;Wb_Mux_sel=2'b01;
            end
            
            `OPCODE_LUI: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 1;PC_mux_sel=2'b00;Wb_Mux_sel=2'b10;
            end 
            
            `OPCODE_AUIPC: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 1;PC_mux_sel=2'b00;Wb_Mux_sel=2'b11;
            end
            
            `OPCODE_SYSTEM: begin //EBREAK
                Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 0;PC_mux_sel=2'b11;Wb_Mux_sel=2'b00;
            end
            
            `OPCODE_FENCE: begin
                Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 0;PC_mux_sel=2'b00;Wb_Mux_sel=2'b00;
            end
            
            default: begin
                Branch=0; MemRead=0; MemtoReg=0; ALUOp= 2'b00; MemWrite=0; ALUSrc=0; RegWrite=0; Byte=0; HalfWord=0; ZeroExtention=0;Wb_Mux_sel=2'b00;
            end 
            
        endcase
    end
    
endmodule
