//1.- Declaracion de mcdulo
module Shift_left(
    input  [31:0] in,
    output [31:0] out
);
//2.- declarar wires o reg
//3.- cuerpo del modulo
    assign out = {in[29:0], 2'b00};
endmodule
