# Risc-v-32bit

## Simple overview 
For milestone 3 of the femtoRV32 project, we implemented the RV32I base integer instruction set for all 40 user-level instructions in the unprivileged ISA. 
The pipelined is supported in this phase by dividing each instruction into 5 cycles with hazard detection unit to eliminate the potential hazard. 
All the 40 instructions were implemented as specified in the manual except for ECALL and FENCE, which were implemented as no-op instructions, so we did this by outputting the instruction add x0, x0, x0 from the instruction memory in case any of these two instructions is the target instruction. 
Also EBREAK was interpreted as a halting instruction ending the execution of the program by preventing loading a new instruction. 

## Processor components

### Control Unit
The processor's control unit is the block responsible for generating control signals based on opcode, and function field. 
Control signals determine various operations within the processor, including ALU operations, memory access, write back operation. 
Notable control signals include ALUOp, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Byte, HalfWord, ZeroExtention, PC_mux_sel, and WB_mux_sel. 
These signals collectively orchestrate the execution of instructions within the processor. We added additional control signals, such as load byte and load half word operations, that control the load and store operations of the data memory. 
Furthermore, the control unit is modified to support the rest of instruction types like I-type and J-type.


### ALU Control Unit
The control unit for the Arithmetic Logic Unit (ALU) generates a 4-bit control signal, "ALU_Sel" based on inputs such as "ALUOp" and "funct3".  
The module employs conditional statements to determine the appropriate ALU operation for different instruction formats. 
We modified the ALU control unit to support the rest of ALU operation especially the R-type and I-type because we implemented only four operations in the lab. 

### Branch Control Unit
The Branch Control Unit uses control signals such as the "Branch" signal, "funct3," and the ALU flags like "sf," "zf," "vf," and "cf" to determine if the branch is taken or not. 
The module effectively determines whether a branch should be taken based on the specified conditions and flag statuses for all the branching instructions.


### ALU
The "ALU" is a 32-bit Arithmetic Logic Unit that performs logical and arithmetic operations on two 32-bit inputs. 
It supports logical operations such as logical AND, OR, XOR. Similarly, it supports arithmetic and shift operations, such as ADD, SLL, and SRL. 
The ALU is modified to perform the rest of logical and arithmetic operations based on the 4-bit select signal "sel.". Sign, carry, overflow, and zero flags have been added to support controlling the upcoming stages like the branching control.

### Memory
In this milestone, we used a single memory for both data and instructions. 
The memory is single ported and byte addressable. 
We modified the data memory to be byte addressable to allow loading and storing one byte or half words. 
It is also modified to allow zero extension for loading byte and half word. To handle the structural hazards, we stall the fetching of instruction during the memory stage of any load/store instructions. 
If the EX/Mem. ReadData/WriteData is asserted, the memory take the address from the ALU_output. Otherwise, it take the PC output to fetch the following instruction.

### Forwarding Unit
The Forwarding Unit resolves data hazards by forwarding data from the output of the ALU or memory stage to the input of the ALU of the following instruction. 
This ensures that data produced by previous instructions can be used immediately by subsequent instructions, mitigating the need to stall the pipeline. 
The Forwarding Unit monitors data dependencies between instructions and efficiently routes data to the appropriate stages based on the hazard detection signals. 

### Hazard Detection Unit
The Hazard Detection Unit is responsible for identifying potential hazards within the pipeline and signaling the need for corrective actions. 
It monitors load-use dependencies, and the structural hazards that requires the program to stall for one cycle. The Hazard Detection Unit works in tandem with the forwarding unit to identify situations where instruction execution might be affected due to data dependencies or control flow changes. 
When a hazard is detected, the Hazard Detection Unit generates control signals to stall the pipeline by setting the control signals of the instruction to zero and stop incrementing the PC value.

### Register File
The Register File contains 32-bit registers for reading and storing the data during the instructions execution to increase the program speed. It takes inputs such as read addresses, write address, and write data. 
Its outputs include data read from specified registers by the input addresses.

### Immediate Generator
The Immediate Generator takes a 32-bit instruction and produces a 32-bit immediate value based on the instruction opcode (OPCODE).

## Visulization of the Processor
![WhatsApp Image 2023-12-04 at 4 35 53 AM](https://github.com/FreddyAmgad/Risc-v-32bit/assets/78415690/bc1e4f26-e0b3-43b3-a53c-46230540ad1a)

## Project Video
https://youtu.be/P9e4Ulz-0Do




                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  