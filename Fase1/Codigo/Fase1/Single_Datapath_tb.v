//1.- definir el modulo
`timescale 1ns/1ns
module Single_Datapath_tb;
//2.-defdinir wires y registros

reg clk;
reg reset;
//3.-cuerpo del modulo

Single_Datapath duv (
        .clk   (clk),
        .reset (reset)
    );
 
initial clk = 0;
always #5 clk = ~clk;
 
    	initial 
	begin
        $display("======================================================");
        $display(" PRUEBA DE Single_Datapath ? Fase 1- ProyectoFinal");
        $display(" $t0=10, $t1=3  (registros 8 y 9)");
        $display("======================================================");
        $display("Ciclo | PC   | Instruccion | ALU Result | Zero");
        $display("------|------|-------------|------------|-----");
 
        reset = 1;
	@(posedge clk);
	reset = 0;
	
 
        repeat (11) 
	begin
	     #1;
            @(posedge clk);
            $display("  %2d  | %4h | %08h  | %10d | %b",
                $time / 10,
                duv.pc_act,
                duv.instruction,
                duv.alu_result,
                duv.alu_zero);
        end
        $display("======================================================");
        $finish;
    end
endmodule