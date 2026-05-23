`timescale 1ns/1ns
module cafe (
    input [3:0] a,
    input [3:0] b,
    output [3:0] c
);

    assign c = a + b;

endmodule