`timescale 1ns / 1ns
module HA (
    input a,
    input b,
    output s,
    output as
);

assign s = a ^ b;  
assign as = a & b;

endmodule
