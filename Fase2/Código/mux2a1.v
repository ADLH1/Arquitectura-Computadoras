//1.-definir modulo
module mux2a1 #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in0,
    input  [WIDTH-1:0] in1,
    input  sel,
    output [WIDTH-1:0] out
);

//2.-definir cables o registros
//3.-cuerpo del modulo
    assign out = sel ? in1 : in0;
 
endmodule
 