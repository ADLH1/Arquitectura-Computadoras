`timescale 1ns / 1ns
module S4bits (
    input [3:0] X,
    input [3:0] Y,
    input Cin,
    output [4:0] W
);

wire c1, c2, c3;

FA F0 (
    .A(X[0]), 
    .B(Y[0]), 
    .AE(Cin), 
    .SUMA(W[0]), 
    .AS(c1)
    );
FA F1 (
    .A(X[1]), 
    .B(Y[1]), 
    .AE(c1), 
    .SUMA(W[1]), 
    .AS(c2)
    );
FA F2 (
    .A(X[2]), 
    .B(Y[2]), 
    .AE(c2), 
    .SUMA(W[2]), 
    .AS(c3)
    );
FA F3 (
    .A(X[3]), 
    .B(Y[3]), 
    .AE(c3), 
    .SUMA(W[3]), 
    .AS(W[4])
    );
endmodule
