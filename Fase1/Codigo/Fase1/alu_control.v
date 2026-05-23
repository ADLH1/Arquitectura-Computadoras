//1.-Definir modulo

module alu_control(
	input  [2:0]ALUOp,
    	input  [5:0]funct,
   	output reg [3:0] alu_ctrl
);
//2.- definir wires o registros
//3.-Cuerpo del modulo

always @(*) 
begin
	case (ALUOp)
            3'b010: 
		begin
               	case (funct)
                    6'b100000: alu_ctrl = 4'b0010; 
                    6'b100010: alu_ctrl = 4'b0110; 
                    6'b100100: alu_ctrl = 4'b0000; 
                    6'b100101: alu_ctrl = 4'b0001;
                    6'b101010: alu_ctrl = 4'b0111; 
                    6'b101011: alu_ctrl = 4'b1000; 
                    6'b000000: alu_ctrl = 4'b0011; 
                    6'b000010: alu_ctrl = 4'b0100; 
                    6'b100111: alu_ctrl = 4'b1100; 
                    6'b100110: alu_ctrl = 4'b1001; 
                    default:   alu_ctrl = 4'b1111;
                endcase
            	end
            default: alu_ctrl = 4'b1111;
        endcase
end
endmodule
