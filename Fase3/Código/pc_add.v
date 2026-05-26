//1.- definicion del modulo 
module pc_add(
	input [31:0] pc_in,
	output [31:0] pc4
);
//2.-definir wires o registros 
//3.-Cuerpo del modulo
assign pc4 = pc_in + 32'd4;

endmodule
