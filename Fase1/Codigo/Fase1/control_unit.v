//1.-definir modulo
module control_unit(
	input [5:0] opcode,
	output RegDst,
	output [2:0]ALUOp,
	output RegWrite,
	output ALUSrc
);
//2.-definir cables o registros
    	wire r_type = (opcode == 6'b000000);
//3.-cuerpo del modulo
	assign RegDst   = r_type ? 1'b1  : 1'b0;
    	assign ALUSrc   = 1'b0;           
    	assign RegWrite = r_type ? 1'b1  : 1'b0;
    	assign ALUOp    = r_type ? 3'b010 : 3'b000;

endmodule 