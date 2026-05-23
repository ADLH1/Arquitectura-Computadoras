module DeMux(
    input [31:0] entrada,
    input sel,
    output reg [31:0] salida1,
    output reg [31:0] salida2
);

always @(*)
    begin
        if(sel)
            begin
                salida1 = 0;
                salida2 = entrada;
            end
        else
            begin
                salida1 = entrada;
                salida2 = 0;
            end
    end
endmodule