`timescale 1ns / 1ns
module tb_S8bits();

reg [7:0] X;
reg [7:0] Y;
reg Cin;

wire [8:0] W;

S8bits duv (
    .X(X),
    .Y(Y),
    .Cin(Cin),
    .W(W)
);

initial begin
    X = 8'd1;   
    Y = 8'd1;   
    Cin = 0;   

    #10 X = 8'd5;   
    Y = 8'd3;   
    Cin = 0;   

    #10 X = 8'd10;  
    Y = 8'd5;   
    Cin = 0;  

    #10 X = 8'd48;  
    Y = 8'd15;  
    Cin = 0;   

    #10 X = 8'd200; 
    Y = 8'd100; 
    Cin = 1;  

    #10 X = 8'd180; 
    Y = 8'd90;  
    Cin = 1;  

    #10 X = 8'd130; 
    Y = 8'd130; 
    Cin = 1;  

    #10 X = 8'd250; 
    Y = 8'd10;  
    Cin = 1;   
    
    #10 $stop;
end

endmodule
