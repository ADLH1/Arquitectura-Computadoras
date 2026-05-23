
//1.-Definir modulo
module alu(
 	input signed [31:0] a,         
    	input signed [31:0] b,         
    	input [4:0] shamt,     
    	input [3:0] alu_ctrl, 
    	output reg [31:0] alu_result,
    	output zero  
);

//2.- definir wires o registros
//3.-Cuerpo del modulo
assign zero = (alu_result == 32'b0);
always @(*) 
begin
        case (alu_ctrl)
            4'b0000: alu_result = a & b;
            4'b0001: alu_result = a | b;
            4'b0010: alu_result = a + b;
            4'b0011: alu_result = b << shamt;      
            4'b0100: alu_result = $unsigned(b) >> shamt;   
            4'b0110: alu_result = a - b;
            4'b0111: alu_result = ($signed(a) < $signed(b))   ? 32'd1 : 32'd0;
            4'b1000: alu_result = ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0;
            4'b1001: alu_result = a ^ b;
            4'b1100: alu_result = ~(a | b);
	    4'b1011: alu_result = {b[15:0], 16'b0}; 
            default: alu_result = 32'b0;
        endcase
end

endmodule