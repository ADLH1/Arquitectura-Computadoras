`timescale 1ns/1ns
module S32c_tb ();

reg [31:0] A_tb;
reg [31:0] B_tb;
wire [31:0] C_tb;

S32C DUV (
    .A(A_tb), 
    .B(B_tb), 
    .C(C_tb) 
);

initial
begin 
    //Sin signo
    A_tb = 32'd1;   B_tb = 32'd2;   #100;
    A_tb = 32'd3;   B_tb = 32'd4;   #100;
    A_tb = 32'd5;   B_tb = 32'd6;   #100;
    A_tb = 32'd7;   B_tb = 32'd8;   #100;
    A_tb = 32'd9;   B_tb = 32'd10;  #100;
    A_tb = 32'd11;  B_tb = 32'd12;  #100;
    A_tb = 32'd13;  B_tb = 32'd14;  #100;
    A_tb = 32'd15;  B_tb = 32'd16;  #100;
    A_tb = 32'd20;  B_tb = 32'd5;   #100;
    A_tb = 32'd25;  B_tb = 32'd30;  #100;
    //Con signo
    A_tb =  32'sd1;   B_tb = -32'sd2;   #100;
    A_tb = -32'sd3;   B_tb =  32'sd4;   #100;
    A_tb = -32'sd5;   B_tb = -32'sd6;   #100;
    A_tb =  32'sd7;   B_tb = -32'sd8;   #100;
    A_tb = -32'sd9;   B_tb =  32'sd10;  #100;
    A_tb =  32'sd11;  B_tb = -32'sd12;  #100;
    A_tb = -32'sd13;  B_tb =  32'sd14;  #100;
    A_tb =  32'sd15;  B_tb = -32'sd16;  #100;
    A_tb = -32'sd20;  B_tb =  32'sd5;   #100;
    A_tb =  32'sd25;  B_tb = -32'sd30;  #100;

    $stop;
end

endmodule