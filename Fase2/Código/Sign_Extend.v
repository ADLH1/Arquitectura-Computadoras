//1.- Declaracion de mcdulo
module Sign_Extend(
	input  [15:0]inmediate,
	output [31:0]extend
);
//2.- declarar wires o reg
//3.- cuerpo del modulo
	assign extend = {{16 {inmediate[15]}},inmediate[15:0]};
endmodule
