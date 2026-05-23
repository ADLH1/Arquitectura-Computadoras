//1.- definicion del modulo 
module instruction_memory (
	input [31:0] address,
	output [31:0] instruction
);
//2.-definir wires o registros
reg [31:0] mem[0:31]; 
//3.-Cuerpo del modulo

initial
begin 
        mem[0]  = 32'b000000_01000_01001_01010_00000_100000; // add  $t2,$t0,$t1
        mem[1]  = 32'b000000_01000_01001_01011_00000_100010; // sub  $t3,$t0,$t1
        mem[2]  = 32'b000000_01000_01001_01100_00000_100100; // and  $t4,$t0,$t1
        mem[3]  = 32'b000000_01000_01001_01101_00000_100101; // or   $t5,$t0,$t1
        mem[4]  = 32'b000000_01000_01001_01110_00000_101010; // slt  $t6,$t0,$t1
        mem[5]  = 32'b000000_00000_00000_00000_00000_000000; // nop
	//5 intrucciones extras de la tabla
        mem[6]  = 32'b000000_01000_01001_01010_00000_100111; // nor  $t2,$t0,$t1
        mem[7]  = 32'b000000_01000_01001_01010_00000_100110; // xor  $t2,$t0,$t1
        mem[8]  = 32'b000000_00000_01001_01010_00010_000000; // sll  $t2,$t1,2
        mem[9]  = 32'b000000_00000_01001_01010_00010_000010; // srl  $t2,$t1,2
        mem[10] = 32'b000000_01000_01001_01110_00000_101011; // sltu $t6,$t0,$t1
end

assign instruction = mem[address[6:2]];
 
endmodule