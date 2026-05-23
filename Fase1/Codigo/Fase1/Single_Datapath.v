//1.-Definir modulo
module Single_Datapath(
    input clk,
    input reset
);
//2.- definir wires o registros

// para pc
wire [31:0] pc_act;
wire [31:0] pc_next;
 
//para separar bits de las instrucciones
wire [31:0] instruction;
wire [5:0] opcode  = instruction[31:26];
wire [4:0] rs      = instruction[25:21];
wire [4:0] rt      = instruction[20:16];
wire [4:0] rd      = instruction[15:11];
wire [4:0] shamt   = instruction[10:6];
wire [5:0] funct   = instruction[5:0];
 
//desde unidad de control
wire RegDst;
wire ALUSrc;
wire RegWrite;
wire [2:0] ALUOp;
 
//para banco de registros
wire [4:0]  write_reg;
wire [31:0] read_data1;
wire [31:0] read_data2;   
wire [31:0] write_data;   
 
// ALU
wire [31:0] alu_input_b;
wire [3:0]  alu_ctrl;
wire [31:0] alu_result;
wire alu_zero;

assign write_data = alu_result;

//3.-Cuerpo del modulo
 
pc u_pc (
	.clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc_out  (pc_act)
    );
 
  
pc_add u_pc_adder (
        .pc_in    (pc_act),
        .pc4 (pc_next)
    );
 
instruction_memory u_inst_mem (
        .address     (pc_act),
        .instruction (instruction)
    );
 
control_unit u_ctrl (
        .opcode   (opcode),
        .RegDst   (RegDst),
        .ALUSrc   (ALUSrc),
        .RegWrite (RegWrite),
        .ALUOp    (ALUOp)
    );

mux2a1 #(.WIDTH(5)) u_mux_regdst (
        .in0 (rt),
        .in1 (rd),
        .sel (RegDst),
        .out (write_reg)
    );
 
b_registros u_bregistros (
        .clk        (clk),
        .RegWrite   (RegWrite),
        .read_reg1  (rs),
        .read_reg2  (rt),
        .write_reg  (write_reg),
        .write_data (write_data),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );
 
 mux2a1 #(.WIDTH(32)) u_mux_alusrc (
        .in0 (read_data2),
        .in1 (32'b0),
        .sel (ALUSrc),
        .out (alu_input_b)
    );
 
alu_control u_alu_ctrl (
        .ALUOp    (ALUOp),
        .funct    (funct),
        .alu_ctrl (alu_ctrl)
    );
 
alu u_alu (
        .a        (read_data1),
        .b        (alu_input_b),
        .shamt    (shamt),
        .alu_ctrl (alu_ctrl),
        .alu_result   (alu_result),
        .zero     (alu_zero)
    );

endmodule