module Taco(
    input [4:0] addr,
    input [31:0] data_in,
    input EN,
    input [3:0] alu_op,
    input sel,
    output [31:0] data_out,
    output [31:0] alu_result
);

wire [31:0] ram_out;
wire [31:0] demux_out1;
wire [31:0] demux_out2;
wire zero;

// Instancia de la RAM
RAM ram_instanciada(
    .dir(addr),
    .Dentrada(data_in),
    .EN(EN),
    .Dsalida(ram_out)
);

// Instancia del demultiplexor
DeMux demux_instanciado(
    .entrada(ram_out),   
    .sel(sel),
    .salida1(demux_out1),
    .salida2(demux_out2)
);

// Instancia de la ALU - CORREGIDO
ALU alu_instanciada(
    .ALUctl(alu_op),
    .A(demux_out1),     
    .B(demux_out2),     
    .ALUout(alu_result),
    .Zero(zero)
);

// Salidas
assign data_out = ram_out;

endmodule