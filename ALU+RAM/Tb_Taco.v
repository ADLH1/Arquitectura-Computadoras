`timescale 1ns/1ns
module tb_taco;

reg [4:0] addr;
reg [31:0] data_in;
reg EN;
reg [3:0] alu_op;
reg sel;

wire [31:0] data_out;
wire [31:0] alu_result;

// Instancia del 
Taco duv(
    .addr(addr),
    .data_in(data_in),
    .EN(EN),
    .alu_op(alu_op),
    .sel(sel),
    .data_out(data_out),
    .alu_result(alu_result)
);

initial begin
    addr = 0;
    data_in = 0;
    EN = 0;
    alu_op = 0;
    sel = 0;
    
    #10;
    
    //ESCRITURA EN RAM
    addr = 5'd10;
    data_in = 32'd42;
    EN = 1;
    #10;
    EN = 0;
    #10;

    addr = 5'd15;
    data_in = 32'd25;
    EN = 1;
    #10;
    EN = 0;
    #10;

    addr = 5'd20;
    data_in = 32'd10;
    EN = 1;
    #10;
    EN = 0;
    #10;
    
    //LECTURA DE RAM
    // Leer dirección 10
    addr = 5'd10;
    #20;
    
    addr = 5'd15;
    #20;
    
    addr = 5'd20;
    #20;
    
    //CAMBIO DE SELECCIÓN DEMUX
    sel = 0;
    #20;
    
    sel = 1;
    #20;
    
    //OPERACIONES ALU
    
    addr = 5'd10;
    sel = 0;
    alu_op = 4'b0010;   
    #20;
    
    addr = 5'd15;
    sel = 1;
    alu_op = 4'b0110;   
    #20;
    
    addr = 5'd10;
    sel = 0;
    alu_op = 4'b0000;  
    #20;
    
    addr = 5'd15;
    sel = 1;
    alu_op = 4'b0001; 
    #20;
    
    addr = 5'd20;
    sel = 0;
    alu_op = 4'b0111; 
    #20;
    
    addr = 5'd20;
    sel = 1;
    alu_op = 4'b1100;  
    #20;
    
    #50;
    $finish;
end

endmodule