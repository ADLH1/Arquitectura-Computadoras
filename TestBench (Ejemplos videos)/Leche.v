`timescale 1ns/1ns
module leche (
    input [3:0] h,
    input [3:0] i,
    output [3:0] j
);

    assign j[0] = h[0] & i[0];
    assign j[1] = h[1] & i[1];
    assign j[2] = h[2] & i[2];
    assign j[3] = h[3] & i[3];

endmodule