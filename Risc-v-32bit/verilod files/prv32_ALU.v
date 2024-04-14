/*******************************************************************
*
* Module: prv32_ALU.v
* Project: femtoRV32
* Authors: Dr. Cherif Salama & Fekry Mohamed, Mario Ghaly, Freddy Amgad
* Description: Arithmetic Logic Unit (ALU) supporting various operations such as addition, subtraction, logic operations, 
* shifting, multiplication, division, and remainder.
*
**********************************************************************/

module prv32_ALU(
	input    [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output       cf, zf, vf, sf,
	input   wire [4:0]  alufn
	);

    wire [31:0] add, sub, op_b;
    wire [63:0]signed_mult,unsigned_mult,mixed_mul;
    assign signed_mult=$signed(a)*$signed(b);
    assign unsigned_mult=$unsigned(a)*$unsigned(b);
    assign mixed_mul=$signed($signed(a)*$unsigned(b));

    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            5'b000_00 : r = add;
            5'b000_01 : r = add;
            5'b000_11 : r = b;
            // logic
            5'b001_00:  r = a | b;
            5'b001_01:  r = a & b;
            5'b001_11:  r = a ^ b;
            // shift
            5'b010_00:  r=sh;
            5'b010_01:  r=sh;
            5'b010_10:  r=sh;
            // slt & sltu
            5'b011_01:  r = {31'b0,(sf != vf)}; 
            5'b011_11:  r = {31'b0,(~cf)};      
            //MUL,MULH,MULHU,MULHSU
            5'b000_10: r= signed_mult[31:0];
            5'b001_10: r= signed_mult[63:32];
            5'b010_11: r= unsigned_mult[63:32];
            5'b011_00: r= mixed_mul[63:32];
            //DIV,DIVU
            5'b011_10: r= $signed(a)/ $signed(b);
            5'b100_00: r= $unsigned(a)/$unsigned(b);
            //REM and REMU
            5'b100_01: r= $signed(a) % $signed(b);
            5'b100_10: r=$unsigned(a)%$unsigned(b);
            
          endcase
    end
endmodule