`timescale 1ns/1ns
module ALU (
    input [15:0] A,
    input [15:0] B,
    input [2:0] op,
    output reg [15:0] C
);
    always @(*) begin
            case(op)   
                3'b000: C= A + B;
                3'b001: C= A - B;
                3'b010: C= A * B;
                3'b011: C= A / B;
                3'b100: C= A & B;
                3'b101: C= A | B;
                3'b110: C= A << 1;
                3'b111: C= A ^ B;
        endcase
    end
endmodule