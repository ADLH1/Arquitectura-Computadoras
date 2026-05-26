//1.- Declaracion de mcdulo
module adder(
	input [31:0]A,
	input [31:0]B,
	output [31:0]result
);

//2.- declarar wires o reg
//3.- cuerpo del modulo
	assign result = A + B;
endmodule
