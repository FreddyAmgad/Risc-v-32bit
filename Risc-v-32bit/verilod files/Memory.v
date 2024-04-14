`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Memory.v
* Project: femtoRV32
* Authors: Fekry Mohamed & Mario Ghaly & Freddy Amgad
* Description: The Memory module handles both data and instruction memory operations for the femtoRV32 processor.
*It includes logic for storing and loading data based on various control signals, as well as the initialization 
*of memory with sample instructions and data.
*
**********************************************************************/


module Memory(
    input clk, 
    input MemRead,
    input MemWrite,
    input Byte, HalfWord, ZeroExtention,
    input [11:0] addr, // log2(4*1024) =12
    input [31:0] data_in, 
    output reg [31:0] data_out
    );

    reg [7:0] mem [0:(4*1024-1)]; //byte-addressable
    
    //store
    always@(posedge clk) begin
        if(MemWrite == 1)
            if(Byte)
                mem[addr] = data_in[7:0];
            else if(HalfWord)
                {mem[addr+1], mem[addr]} = data_in[15:0];
            else
                {mem[addr+3], mem[addr+2],mem[addr+1], mem[addr]} = data_in;
    end
    
    //load
    always @(*)begin 
	if (MemRead)begin   //read memory
		if (ZeroExtention==0)begin
            if(Byte)
                data_out ={{24{mem[addr][3]}},mem[addr]};
            else if(HalfWord)
                data_out ={{16{mem[addr+1][3]}},mem[addr+1], mem[addr]};
            else
                data_out ={mem[addr+3],mem[addr+2],mem[addr+1], mem[addr]};
		end	

		else begin 
            if(Byte)
                data_out ={24'b0,mem[addr]};
            else if(HalfWord)
                data_out ={16'b0,mem[addr+1], mem[addr]};
            else
                data_out ={mem[addr+3],mem[addr+2],mem[addr+1], mem[addr]};
		end
    end	
    else 
        data_out ={mem[addr+3],mem[addr+2],mem[addr+1], mem[addr]};
        if( (data_out[`IR_opcode] == `OPCODE_FENCE) || (data_out[`IR_opcode] == `OPCODE_SYSTEM && data_out[20] == 0) ) 
            data_out = 32'b00000000000000000000000000110011;
	
	end



    //initialization
        integer file_status;
        reg file_opened;    
       initial begin
            file_status = $fopen("D:/UNI/Fall 2023/Archture/Testing vivado/omg/omg/Final_code_sunday/verilod files/EFENCE_EBREAK_ECALL.txt", "r");
            if (file_status != -1) begin
                $display("File opened successfully");
                file_opened = 1;
    
                // Read data into memory if the file is open
                $readmemh("D:/UNI/Fall 2023/Archture/Testing vivado/omg/omg/Final_code_sunday/verilod files/EFENCE_EBREAK_ECALL.txt", mem);
    
                // Additional initialization or simulation setup code here
            end else begin
                $display("Error: Unable to open file (status %0d)", file_status);
                file_opened = 0;
            end
        {mem[1000+3],mem[1000+2],mem[1000+1],mem[1000]}=32'd17; 
        {mem[1004+3],mem[1004+2],mem[1004+1],mem[1004]}=32'd9; 
        {mem[1008+3],mem[1008+2],mem[1008+1],mem[1008]}=32'd512; 
        end 
     
     

endmodule
