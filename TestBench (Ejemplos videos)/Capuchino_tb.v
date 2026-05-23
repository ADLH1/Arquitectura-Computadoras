`timescale 1ns/1ns
module capuchino_tb  ();

wire [7:0] bebida_tb;
reg  [7:0] lala_tb;
reg  [7:0] planchuela_tb;

capuchino DUV (

    .lala (lala_tb),
    .planchuela (planchuela_tb),
    .bebida (bebida_tb)
);

initial 
begin 
    lala_tb         =8'd17;
    planchuela_tb   =8'd165;
    #100;
    lala_tb         =8'd17;
    planchuela_tb   =8'd99;
    #100;
    $stop;
end
endmodule
