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

initial begin
    $readmemb("TestF1_BReg.mem", registers);
end


always @(posedge clk) 
begin
	if (RegWrite && (write_reg != 5'b00000))
            registers[write_reg] <= write_data;
end
	assign read_data1 = registers[read_reg1];
    	assign read_data2 = registers[read_reg2];

endmodule
