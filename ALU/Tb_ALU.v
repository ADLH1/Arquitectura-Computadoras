`timescale 1ns/1ns
module Tb_ALU ();

reg [15:0] A_tb;
reg [15:0] B_tb;
reg [2:0] OP_tb;
wire [15:0] C_tb;

ALU DUV (
    .A(A_tb),
    .B(B_tb),
    .op(OP_tb),
    .C(C_tb)
);

initial
begin
    //SUMA
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b000;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b000;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b000;  #100;
    //RESTA
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b001;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b001;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b001;  #100;
    //MULTIPLICACION
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b010;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b010;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b010;  #100;
    //DIVISION
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b011;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b011;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b011;  #100;
    //AND
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b100;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b100;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b100;  #100;
    //OR
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b101;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b101;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b101;  #100;
    //CORRIMIENTO DE 1 BIT A LA IZQUIERDA
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b110;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b110;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b110;  #100;
    //XOR
    A_tb = 10;      B_tb = 5;       OP_tb = 3'b111;  #100;
    A_tb = 15;      B_tb = 2;       OP_tb = 3'b111;  #100;
    A_tb = 20;      B_tb = 8;       OP_tb = 3'b111;  #100;

    $stop;
end

endmodule