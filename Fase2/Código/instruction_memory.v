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
    /*mem[0] = 32'b000000_00010_00101_01100_00000_100000;  // add $12, $2, $5
    mem[1] = 32'b001000_00001_01101_0000000000110000;    // addi $13, $1, 48
    mem[2] = 32'b100011_00110_01001_0000000000000101;    // lw $9, 5($6)
    mem[3] = 32'b101011_00110_01100_0000000000000101;    // sw $12, 5($6)
    mem[4] = 32'b000100_01000_01001_0000000000000011;    // beq $8, $9, 3
    mem[5] = 32'b001000_01000_01000_0000000000000010;    // addi $8, $8, 2
    mem[6] = 32'b001000_01000_01000_0000000000000010;    // addi $8, $8, 2
    mem[7] = 32'b000010_00000000000000000000010000;      // j 16
    mem[8] = 32'b101011_00110_01000_0000000000001001;    // sw $8, 9($6)*/
	$readmemh("TestF2_MemInst.mem", mem);
	
end

assign instruction = mem[address[6:2]];
 
endmodule