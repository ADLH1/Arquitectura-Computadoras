// 1.- Definir modulo
module control_unit(
    input [5:0] opcode,
    output RegDst,
    output [3:0] ALUOp,
    output RegWrite,
    output ALUSrc,
    output MemRead,
    output MemWrite,
    output memtoReg,
    output Branch,
    output BranchNE,
    output Jump,
    output JumpLink
);

// 2.- Definir Cables o registros
wire r_type = (opcode == 6'b000000); // add
//tipo i 
wire addi   = (opcode == 6'b001000); // addi
wire lw     = (opcode == 6'b100011); // lw
wire sw     = (opcode == 6'b101011); // sw
wire beq    = (opcode == 6'b000100); // beq
wire bne    = (opcode == 6'b000101); // Branch if Not Equal
wire bgtz   = (opcode == 6'b000111); // Branch if Greater Than Zero
wire slti = (opcode == 6'b001010); // slti
wire andi = (opcode == 6'b001100); // andi
wire ori  = (opcode == 6'b001101); // ori
wire xori  = (opcode == 6'b001110); // xori
wire lui   = (opcode == 6'b001111); // lui
wire sltiu = (opcode == 6'b001011); // sltiu

//tipo j
wire j      = (opcode == 6'b000010); // j
wire jal    = (opcode == 6'b000011); // jump and link

// 3.- Cuerpo del modulo
    assign RegDst   = r_type ? 1'b1 : 1'b0;

    assign ALUSrc   = (addi || lw || sw || slti || andi || ori|| xori || lui || sltiu) ? 1'b1 : 1'b0;

    assign RegWrite = (r_type || addi || lw || slti || andi || ori || jal|| xori || lui || sltiu) ? 1'b1 : 1'b0;

    assign MemRead  = lw ? 1'b1 : 1'b0;

    assign MemWrite = sw ? 1'b1 : 1'b0;

    assign memtoReg = lw ? 1'b1 : 1'b0;

    assign Branch   = beq ? 1'b1 : 1'b0;

    assign BranchNE = bne  ? 1'b1 : 1'b0;

    assign Jump     = (j || jal) ? 1'b1 : 1'b0;

    assign JumpLink = jal ? 1'b1 : 1'b0; 

    // 3'b010 -> depende del funct
    // 3'b000 -> Suma
    // 3'b001 -> Resta
	
assign ALUOp = r_type      ? 4'b0010 :
               (beq | bne) ? 4'b0001 :
               slti        ? 4'b0101 :
               andi        ? 4'b0011 :
               ori         ? 4'b0100 :
               bgtz        ? 4'b0001 :
               xori        ? 4'b0110 : 
               sltiu       ? 4'b0111 :
               lui         ? 4'b1000 :
                             4'b0000; 

endmodule