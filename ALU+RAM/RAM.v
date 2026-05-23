module RAM(
//1. Declaracion de modulo RAM
//y sus I/O  
    input [4:0] dir,
    input [31:0] Dentrada,
    input EN,
    output reg [31:0] Dsalida
);

//2. Declaracion de comp. internos Wires:NA, Reg:si,
//arreglo bidimencional
reg [31:0] MEM [0:31];

always @(EN, dir, Dentrada) 
//3. Leer o escribir en memoria
    begin
        if(EN)
            begin// Escritura
                MEM[dir] = Dentrada;
                Dsalida = Dentrada;
            end
        else
            begin// Lectura
                Dsalida = MEM[dir];
            end
    end

endmodule