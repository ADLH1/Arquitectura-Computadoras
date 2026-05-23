`timescale 1ns/1ps

module TB_DPTR;

    reg clk;
    reg reset;

    DPTR dut (
        .clk  (clk),
        .reset(reset)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    integer k;
    initial begin
        reset = 1'b1;
        @(posedge clk); #1;
        reset = 1'b0;

        repeat (10) @(posedge clk);
        #1;

        $display("");
        $display("============================================");
        $display("  RESULTADOS DPTR - Formato Decimal");
        $display("============================================");
        $display("  Reg |  Valor  |  Esperado  | OK?");
        $display("--------------------------------------------");
        $display("  $5  | %6d  |     30     | %s", dut.BR.registers[5],  (dut.BR.registers[5]  ==  30) ? "OK" : "FAIL");
        $display("  $6  | %6d  |     20     | %s", dut.BR.registers[6],  (dut.BR.registers[6]  ==  20) ? "OK" : "FAIL");
        $display("  $7  | %6d  |     10     | %s", dut.BR.registers[7],  (dut.BR.registers[7]  ==  10) ? "OK" : "FAIL");
        $display("  $8  | %6d  |     10     | %s", dut.BR.registers[8],  (dut.BR.registers[8]  ==  10) ? "OK" : "FAIL");
        $display("  $9  | %6d  |      0     | %s", dut.BR.registers[9],  (dut.BR.registers[9]  ==   0) ? "OK" : "FAIL");
        $display("  $10 | %6d  |      4     | %s", dut.BR.registers[10], (dut.BR.registers[10] ==   4) ? "OK" : "FAIL");
        $display("  $11 | %6d  |     15     | %s", dut.BR.registers[11], (dut.BR.registers[11] ==  15) ? "OK" : "FAIL");
        $display("  $12 | %6d  |     31     | %s", dut.BR.registers[12], (dut.BR.registers[12] ==  31) ? "OK" : "FAIL");
        $display("  $13 | %6d  |      1     | %s", dut.BR.registers[13], (dut.BR.registers[13] ==   1) ? "OK" : "FAIL");
        $display("  $14 | %6d  |      0     | %s", dut.BR.registers[14], (dut.BR.registers[14] ==   0) ? "OK" : "FAIL");
        $display("============================================");
        $display("");

        $stop;
    end

    initial begin
        $display("");
        $display("Tiempo(ns) | PC | Instruccion  | ALU_Result (dec)");
        $display("--------------------------------------------------");
    end

    always @(posedge clk) begin
        if (!reset)
            $display("%6d ns  | %2d | 0x%08h  | %0d",
                $time,
                dut.PC,
                dut.instruction,
                dut.alu_result);
    end

endmodule
