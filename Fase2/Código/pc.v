//1.- definicion del modulo 
module pc (
	input clk,
	input reset,
    	input  [31:0] pc_next, //siguiente
    	output reg [31:0] pc_out //actual
);
//2.-definir wires o registros 
//3.-Cuerpo del modulo
always @(posedge clk or posedge reset) 
begin
	if (reset) pc_out <= 32'h0000_0000;
        else       pc_out <= pc_next;
end

endmodule