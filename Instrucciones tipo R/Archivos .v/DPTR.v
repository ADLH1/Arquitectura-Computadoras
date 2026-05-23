module DPTR (
    input clk,
    input reset
);

    reg [31:0] PC;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'd0;
        else
            PC <= PC + 32'd4;
    end

    reg [31:0] instr_mem [0:15];

    integer j;
    initial begin
        for (j = 0; j < 16; j = j + 1)
            instr_mem[j] = 32'd0;

        instr_mem[0]  = 32'h00222820;
        instr_mem[1]  = 32'h00643020;
        instr_mem[2]  = 32'h00413822;
        instr_mem[3]  = 32'h00834022;
        instr_mem[4]  = 32'h00234824;
        instr_mem[5]  = 32'h00445024;
        instr_mem[6]  = 32'h00235825;
        instr_mem[7]  = 32'h00446025;
        instr_mem[8]  = 32'h0022682A;
        instr_mem[9]  = 32'h0041702A;
    end

    wire [31:0] instruction;
    assign instruction = instr_mem[PC[5:2]];

    wire [5:0] op    = instruction[31:26];
    wire [4:0] rs    = instruction[25:21];
    wire [4:0] rt    = instruction[20:16];
    wire [4:0] rd    = instruction[15:11];
    wire [5:0] funct = instruction[5:0];

    wire        MemToReg, RegWrite, MemToWrite;
    wire [2:0]  ALUOp;
    wire [3:0]  alu_ctrl;
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;

    UnidadDeControl UC (
        .opcode    (op),
        .MemToReg  (MemToReg),
        .RegWrite  (RegWrite),
        .MemToWrite(MemToWrite),
        .ALUOp     (ALUOp)
    );

    ALUControl ALUCTRL (
        .funct   (funct),
        .ALUOp   (ALUOp),
        .alu_ctrl(alu_ctrl)
    );

    BancoReg BR (
        .clk        (clk),
        .RegWrite   (RegWrite),
        .read_reg1  (rs),
        .read_reg2  (rt),
        .write_reg  (rd),
        .write_data (write_back_data),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

    alu ALU (
        .A      (read_data1),
        .B      (read_data2),
        .alu_op (alu_ctrl),
        .result (alu_result)
    );

    Mem DATA_MEM (
        .clk        (clk),
        .MemWrite   (MemToWrite),
        .address    (alu_result),
        .write_data (read_data2),
        .read_data  (mem_read_data)
    );

    Mux2_1_32 MUX_MEMTOREG (
        .in0(alu_result),
        .in1(mem_read_data),
        .sel(MemToReg),
        .out(write_back_data)
    );

endmodule
