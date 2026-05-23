module UnidadDeControl (
    input      [5:0] opcode,
    output reg       MemToReg,
    output reg       RegWrite,
    output reg       MemToWrite,
    output reg [2:0] ALUOp
);

    always @(*) begin
        case (opcode)
            6'b000000: begin
                RegWrite   = 1'b1;
                MemToReg   = 1'b0;
                MemToWrite = 1'b0;
                ALUOp      = 3'b010;
            end
            default: begin
                RegWrite   = 1'b0;
                MemToReg   = 1'b0;
                MemToWrite = 1'b0;
                ALUOp      = 3'b000;
            end
        endcase
    end

endmodule
