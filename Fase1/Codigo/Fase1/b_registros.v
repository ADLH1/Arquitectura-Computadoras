//1.-Definir modulo
module b_registros (
    input clk,
    input RegWrite,
    input  [4:0]  read_reg1,   
    input  [4:0]  read_reg2,   
    input  [4:0]  write_reg,  
    input  [31:0] write_data, 
    output [31:0] read_data1, 
    output [31:0] read_data2
);
//2.- definir wires o registros
reg [31:0] registers[0:31];

//3.-Cuerpo del modulo
integer i;
initial 
begin
	for (i = 0; i < 32; i = i + 1)
        	registers[i] = 32'd0;
// Valores de prueba para verificar resultados en simulación
        registers[8] = 32'd10;  // $t0 = 10
        registers[9] = 32'd3;   // $t1 = 3
end


always @(posedge clk) 
begin
	if (RegWrite && (write_reg != 5'b00000))
            registers[write_reg] <= write_data;
end
	assign read_data1 = registers[read_reg1];
    	assign read_data2 = registers[read_reg2];

endmodule
