//1.-Definir modulo

module alu_control(
	input  [3:0]ALUOp,
    	input  [5:0]funct,
   	output reg [3:0] alu_ctrl
);
//2.- definir wires o registros
//3.-Cuerpo del modulo

always @(*) 
begin
	case (ALUOp)
            4'b0010: 
	    begin
        	case (funct)
            	6'b100000: alu_ctrl = 4'b0010; // add
           	6'b100010: alu_ctrl = 4'b0110; // sub
            	6'b100100: alu_ctrl = 4'b0000; // and
            	6'b100101: alu_ctrl = 4'b0001; // or
            	6'b101010: alu_ctrl = 4'b0111; // slt
            	6'b101011: alu_ctrl = 4'b1000; // sltu
            	6'b000000: alu_ctrl = 4'b0011; // sll/nop
            	6'b000010: alu_ctrl = 4'b0100; // srl
            	6'b100111: alu_ctrl = 4'b1100; // nor
            	6'b100110: alu_ctrl = 4'b1001; // xor
            	default:   alu_ctrl = 4'b1111;
        	endcase
    	    end
    	4'b0000: alu_ctrl = 4'b0010; // add - addi, lw, sw
    	4'b0001: alu_ctrl = 4'b0110; // sub - beq, bne, bgtz
    	4'b0011: alu_ctrl = 4'b0000; // and - andi
    	4'b0100: alu_ctrl = 4'b0001; // or - ori
    	4'b0101: alu_ctrl = 4'b0111; // slt - slti
    	4'b0110: alu_ctrl = 4'b1001; // xor - xori
    	4'b0111: alu_ctrl = 4'b1000; // sltu- sltiu
    	4'b1000: alu_ctrl = 4'b1011; // lui 
    	default: alu_ctrl = 4'b1111;
	endcase
end
endmodule

