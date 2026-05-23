module ALUControl (
    input      [5:0] funct,
    input      [2:0] ALUOp,
    output reg [3:0] alu_ctrl
);

    always @(*) begin
        case (ALUOp)
            3'b010: begin
                case (funct)
                    6'b100000: alu_ctrl = 4'b0010;
                    6'b100010: alu_ctrl = 4'b0110;
                    6'b100100: alu_ctrl = 4'b0000;
                    6'b100101: alu_ctrl = 4'b0001;
                    6'b101010: alu_ctrl = 4'b0111;
                    default:   alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end

endmodule
