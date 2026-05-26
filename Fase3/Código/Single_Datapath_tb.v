`timescale 1ns/1ns

module Single_Datapath_tb;

    reg clk;
    reg reset;

    Single_Datapath uut (
        .clk   (clk),
        .reset (reset)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    // nombres de los registros para impresion legible
    reg [8*5:1] reg_name [0:31];
    initial begin
        reg_name[0]  = "$zero";
        reg_name[1]  = "$at";
        reg_name[2]  = "$v0";
        reg_name[3]  = "$v1";
        reg_name[4]  = "$a0";
        reg_name[5]  = "$a1";
        reg_name[6]  = "$a2";
        reg_name[7]  = "$a3";
        reg_name[8]  = "$t0";
        reg_name[9]  = "$t1";
        reg_name[10] = "$t2";
        reg_name[11] = "$t3";
        reg_name[12] = "$t4";
        reg_name[13] = "$t5";
        reg_name[14] = "$t6";
        reg_name[15] = "$t7";
        reg_name[16] = "$s0";
        reg_name[17] = "$s1";
        reg_name[18] = "$s2";
        reg_name[19] = "$s3";
        reg_name[20] = "$s4";
        reg_name[21] = "$s5";
        reg_name[22] = "$s6";
        reg_name[23] = "$s7";
        reg_name[24] = "$t8";
        reg_name[25] = "$t9";
        reg_name[28] = "$gp";
        reg_name[29] = "$sp";
        reg_name[30] = "$fp";
        reg_name[31] = "$ra";
    end

    // TAREA: mostrar ciclo actual ? PC, instruccion, señales clave, resultado
    task mostrar_ciclo;
        input [31:0] num_ciclo;
        reg [5:0] op;
        reg [4:0] r_rs, r_rt, r_rd;
        reg [15:0] imm;
        begin
            op   = uut.opcode;
            r_rs = uut.rs;
            r_rt = uut.rt;
            r_rd = uut.rd;
            imm  = uut.inmediate;

            $display("--------------------------------------------");
            $display("  Ciclo %0d  |  PC = 0x%08h", num_ciclo, uut.pc_act);
            $display("  Instruccion : 0x%08h  opcode=%06b", uut.instruction, op);

            // Mostrar la instruccion en lenguaje ensamblador segun opcode
            case (op)
                6'b000000: begin
                    case (uut.funct)
                        6'b100000: $display("  ASM : add  %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b100010: $display("  ASM : sub  %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b100100: $display("  ASM : and  %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b100101: $display("  ASM : or   %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b101010: $display("  ASM : slt  %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b100111: $display("  ASM : nor  %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b100110: $display("  ASM : xor  %0s, %0s, %0s",
                                       reg_name[r_rd], reg_name[r_rs], reg_name[r_rt]);
                        6'b000000: $display("  ASM : sll/nop");
                        6'b000010: $display("  ASM : srl  %0s, %0s, %0d",
                                       reg_name[r_rd], reg_name[r_rt], uut.shamt);
                        default:   $display("  ASM : tipo R funct=%06b", uut.funct);
                    endcase
                end
                6'b001000: $display("  ASM : addi %0s, %0s, %0d",
                               reg_name[r_rt], reg_name[r_rs], $signed(imm));
                6'b001010: $display("  ASM : slti %0s, %0s, %0d",
                               reg_name[r_rt], reg_name[r_rs], $signed(imm));
		6'b001011: $display("  ASM : sltiu %0s, %0s, %0d",
                   		reg_name[r_rt], reg_name[r_rs], imm);
                6'b001100: $display("  ASM : andi %0s, %0s, %0d",
                               reg_name[r_rt], reg_name[r_rs], imm);
                6'b001101: $display("  ASM : ori  %0s, %0s, %0d",
                               reg_name[r_rt], reg_name[r_rs], imm);
    		6'b001110: $display("  ASM : xori  %0s, %0s, %0d", 
                   		reg_name[r_rt], reg_name[r_rs], imm);
    		6'b001111: $display("  ASM : lui   %0s, %0d",       
                   		reg_name[r_rt], imm);
                6'b100011: $display("  ASM : lw   %0s, %0d(%0s)",
                               reg_name[r_rt], $signed(imm), reg_name[r_rs]);
                6'b101011: $display("  ASM : sw   %0s, %0d(%0s)",
                               reg_name[r_rt], $signed(imm), reg_name[r_rs]);
                6'b000100: $display("  ASM : beq  %0s, %0s, %0d  [Zero=%b ? %s]",
                               reg_name[r_rs], reg_name[r_rt], $signed(imm),
                               uut.alu_zero,
                               uut.alu_zero ? "SALTA" : "no salta");
                6'b000101: $display("  ASM : bne  %0s, %0s, %0d  [Zero=%b ? %s]",
                               reg_name[r_rs], reg_name[r_rt], $signed(imm),
                               uut.alu_zero,
                               ~uut.alu_zero ? "SALTA" : "no salta");
                6'b000111: $display("  ASM : bgtz %0s, %0d  [%0s=%0d ? %s]",
                               reg_name[r_rs], $signed(imm),
                               reg_name[r_rs], $signed(uut.read_data1),
                               ($signed(uut.read_data1) > 0) ? "SALTA" : "no salta");
                6'b000010: $display("  ASM : j    0x%08h  ? PC sera 0x%08h",
                               uut.instruction[25:0], uut.pc_jump);
                6'b000011: $display("  ASM : jal  0x%08h  ? $ra = 0x%08h",
                               uut.instruction[25:0], uut.pc4);
                default:   $display("  ASM : opcode desconocido %06b", op);
            endcase

            // Resultado de la ALU y registro destino
            $display("  ALU : ctrl=%04b  resultado=0x%08h (%0d)  Zero=%b",
                uut.alu_ctrl, uut.alu_result,
                $signed(uut.alu_result), uut.alu_zero);

            if (uut.RegWrite && uut.jal_write_reg != 0)
                $display("  WRITE: %0s ? 0x%08h (%0d)",
                    reg_name[uut.jal_write_reg],
                    uut.jal_write_data,
                    $signed(uut.jal_write_data));

            if (uut.MemWrite)
                $display("  MEM WRITE: mem[%0d] ? 0x%08h (%0d)",
                    uut.alu_result, uut.read_data2, $signed(uut.read_data2));

            if (uut.MemRead)
                $display("  MEM READ : mem[%0d] ? 0x%08h (%0d)",
                    uut.alu_result, uut.mem_read_data, $signed(uut.mem_read_data));
        end
    endtask

    // TAREA: mostrar estado final de registros (solo los no-cero)
    task mostrar_registros_final;
        integer k;
        begin
            $display("");
            $display("--------------------------------------------");
            $display("  ESTADO FINAL ? BANCO DE REGISTROS");
            $display("  (solo registros con valor != 0)");
            $display("--------------------------------------------");
            for (k = 1; k < 32; k = k + 1) begin
                if (uut.u_bregistros.registers[k] !== 32'd0)
                    $display("  %5s ($%0d) = %10d  (0x%08h)",
                        reg_name[k], k,
                        $signed(uut.u_bregistros.registers[k]),
                        uut.u_bregistros.registers[k]);
            end
        end
    endtask

    // TAREA: mostrar memoria de datos (solo posiciones no-cero)
    task mostrar_memoria_final;
        integer k;
        begin
            $display("");
            $display("--------------------------------------------");
            $display("  ESTADO FINAL ? MEMORIA DE DATOS");
            $display("  (solo posiciones con valor != 0)");
            $display("--------------------------------------------");
            for (k = 0; k < 32; k = k + 1) begin
                if (uut.u_data_mem.memory[k] !== 32'd0)
                    $display("  mem[%0d] = %10d  (0x%08h)",
                        k,
                        $signed(uut.u_data_mem.memory[k]),
                        uut.u_data_mem.memory[k]);
            end
        end
    endtask

    // FLUJO PRINCIPAL
    integer ciclo;

    initial begin
        $display("-------------------------------------------");
        $display("  SIMULACION Single_Datapath MIPS  Fase 3");
        $display("--------------------------------------------");

        reset = 1;
	@(posedge clk);
	#1;
	reset = 0;
	@(negedge clk);

        $display("\n> INICIO DE EJECUCION <\n");
        for (ciclo = 1; ciclo <= 30; ciclo = ciclo + 1) begin
            @(posedge clk);
            #1;
            mostrar_ciclo(ciclo);
	    if (uut.opcode == 6'b000011) begin
            $display("  [VERIFICACION JAL] $ra = 0x%08h | PC+4 esperado = 0x%08h | %s",
            uut.u_bregistros.registers[31],
            uut.pc4,
            (uut.u_bregistros.registers[31] == uut.pc4) ? "OK" : "ERROR");
	    end

	    if (uut.opcode == 6'b000010) begin
    	    $display("  [VERIFICACION J]   PC actual = 0x%08h | Destino esperado = 0x%08h",
            uut.pc_act,
            uut.pc_jump);
	  end
        end

        mostrar_registros_final;
        mostrar_memoria_final;

        $display("\n------------------------------------------\n");
        $finish;
    end

endmodule