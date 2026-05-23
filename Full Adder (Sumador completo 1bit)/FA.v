`timescale 1ns / 1ns
module FA (
    input A,
    input B,
    input AE,      
    output SUMA,
    output AS      
);

wire c1, c2, c3;

HA ha1 (.a(A), .b(B), .s(c1), .as(c2));
HA ha2 (.a(c1), .b(AE), .s(SUMA), .as(c3));

assign AS = c2 | c3;

endmodule

