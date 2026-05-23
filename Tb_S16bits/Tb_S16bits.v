`timescale 1ns / 1ns
module tb_S16bits();

reg [15:0] X;
reg [15:0] Y;
reg Cin;

wire [16:0] W;

S16bits uut (
    .X(X),
    .Y(Y),
    .Cin(Cin),
    .W(W)
);

initial begin
    X = 16'd100;   
    Y = 16'd50;   
    Cin = 0;

    #10 X = 16'd20;  
    Y = 16'd30; 
    Cin = 1;

    #10 X = 16'd10; 
    Y = 16'd20; 
    Cin = 0;

    #10 X = 16'd52; 
    Y = 16'd96; 
    Cin = 1;

    #10 X = 16'd65; 
    Y = 16'd14; 
    Cin = 0;

    #10 X = 16'd60; 
    Y = 16'd10; 
    Cin = 1;

    #10 X = 16'd90; 
    Y = 16'd30; 
    Cin = 0;

    #10 X = 16'd155; 
    Y = 16'd5; 
    Cin = 1;

    #10 $stop;
end

endmodule
