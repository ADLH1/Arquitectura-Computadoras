module alu (
    input [31:0] A,
    input [31:0] B,
    input [3:0] alu_op,
    output reg [31:0] result
);

    always @(*) begin
        case (alu_op)
            4'b0000: result = A & B;
            4'b0001: result = A | B;
            4'b0010: result = A + B;
            4'b0110: result = A - B;
            4'b0111: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            4'b1100: result = ~(A | B);
            default: result = 32'b0;
        endcase
    end

endmodule
