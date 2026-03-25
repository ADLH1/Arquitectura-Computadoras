`timescale 1ns / 1ns
module CompuertasLogicas(
    input a,
    input b,
    output c,
    output d,
    output e,
    output f,
    output g,
    output h,
    output i,
    output j
);

    assign c=a&b;
    assign d=~(a&b);
    assign e=a|b;
    assign f=~(a|b);
    assign g=a^b;
    assign h=a~^b;
    assign i=~a;
    assign j=~b;
    
endmodule
