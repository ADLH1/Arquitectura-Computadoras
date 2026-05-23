`timescale 1ns/1ns
module capuchino (
    input [7:0] lala, //7-4,3-0
    input [7:0] planchuela,
    output [7:0] bebida
);

    wire [3:0] espumar;
    wire [3:0] extraer;

assign bebida = {espumar,extraer};

leche venti (
    .h(lala[3:0]),
    .i(lala[7:4]),
    .j(espumar)
);

cafe carga1 (
    .a(planchuela[3:0]),
    .b(planchuela[7:4]),
    .c(extraer)
);

endmodule
