//1. Definir modulo
module Single_Datapath(
    input clk,
    input reset
);

	//2. Definir cables o registros
	//Señales del PC 
	wire [31:0] pc_act;
	wire [31:0] pc_jump;
	wire [31:0] pc_final;
	wire [31:0] pc4;	
	wire [31:0] pc_branch_mux;

	//Instruccion
	wire [31:0] instruction;
	wire [5:0] opcode  = instruction[31:26];
	wire [4:0] rs      = instruction[25:21];
	wire [4:0] rt      = instruction[20:16];
	wire [4:0] rd      = instruction[15:11];
	wire [4:0] shamt   = instruction[10:6];
	wire [5:0] funct   = instruction[5:0];
	wire [15:0] inmediate = instruction[15:0];
 
    	// Señales de control
    	wire RegDst;
    	wire ALUSrc;
    	wire RegWrite;
    	wire [3:0] ALUOp;
    	wire MemRead;
    	wire MemWrite;
    	wire memtoReg;
    	wire Branch;
    	wire BranchNE;  
    	wire Jump;
    	wire JumpLink;
 
	//Banco de registros
	wire [4:0]  write_reg;
	wire [31:0] read_data1;
	wire [31:0] read_data2;   
	wire [31:0] write_data;
 
	//ALU
	wire [31:0] alu_input_b;
	wire [31:0] extended_imm;
	wire [3:0]  alu_ctrl;
	wire [31:0] alu_result;
	wire alu_zero;
	wire [31:0] alu_out_mem;
 
    	// Memoria de datos
    	wire [31:0] mem_read_data;
 
    	// Extension de signo y branch
    	wire [31:0] extended_shifted;
    	wire [31:0] branch_addr;
	wire branch_taken = (Branch & alu_zero) | (BranchNE & ~alu_zero);

	//Jal
	wire [4:0]  jal_write_reg;
   	wire [31:0] jal_write_data;
    	assign jal_write_reg  = JumpLink ? 5'd31 : write_reg;
    	assign jal_write_data = JumpLink ? pc4 : alu_out_mem;
	//Buffer ID/IF
    	reg [31:0] IFID_PC4;
    	reg [31:0] IFID_instruction;
 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IFID_PC4          <= 32'b0;
            IFID_instruction  <= 32'b0;
        end else begin
            IFID_PC4          <= pc4;
            IFID_instruction  <= instruction;
        end
    end
 
    wire [5:0] IFID_opcode  = IFID_instruction[31:26];
    wire [4:0] IFID_rs      = IFID_instruction[25:21];
    wire [4:0] IFID_rt      = IFID_instruction[20:16];
    wire [4:0] IFID_rd      = IFID_instruction[15:11];
    wire [4:0] IFID_shamt   = IFID_instruction[10:6];
    wire [5:0] IFID_funct   = IFID_instruction[5:0];
    wire [15:0] IFID_imm    = IFID_instruction[15:0];
 
    //Buffer ID/EX 

    reg [31:0] IDEX_PC4;
    reg [31:0] IDEX_ReadData1;
    reg [31:0] IDEX_ReadData2;
    reg [31:0] IDEX_SignExtend;
    reg [4:0]  IDEX_rs;
    reg [4:0]  IDEX_rt;
    reg [4:0]  IDEX_rd;
    reg [4:0]  IDEX_shamt;

    reg IDEX_RegDst;
    reg IDEX_ALUSrc;
    reg [3:0]IDEX_ALUOp;
    reg IDEX_RegWrite;
    reg IDEX_MemRead;
    reg IDEX_MemWrite;
    reg IDEX_memtoReg;
    reg IDEX_Branch;
    reg IDEX_Jump;
    reg IDEX_JumpLink;
 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IDEX_PC4        <= 32'b0;
            IDEX_ReadData1  <= 32'b0;
            IDEX_ReadData2  <= 32'b0;
            IDEX_SignExtend <= 32'b0;
            IDEX_rs         <= 5'b0;
            IDEX_rt         <= 5'b0;
            IDEX_rd         <= 5'b0;
            IDEX_shamt      <= 5'b0;
            IDEX_RegDst     <= 1'b0;
            IDEX_ALUSrc     <= 1'b0;
            IDEX_ALUOp      <= 3'b0;
            IDEX_RegWrite   <= 1'b0;
            IDEX_MemRead    <= 1'b0;
            IDEX_MemWrite   <= 1'b0;
            IDEX_memtoReg   <= 1'b0;
            IDEX_Branch     <= 1'b0;
	    IDEX_Jump       <= 1'b0;
	    IDEX_JumpLink   <= 1'b0;
        end else begin
            IDEX_PC4        <= IFID_PC4;
            IDEX_ReadData1  <= read_data1;
            IDEX_ReadData2  <= read_data2;
            IDEX_SignExtend <= extended_imm;
            IDEX_rs         <= IFID_rs;
            IDEX_rt         <= IFID_rt;
            IDEX_rd         <= IFID_rd;
            IDEX_shamt      <= IFID_shamt;
            IDEX_RegDst     <= RegDst;
            IDEX_ALUSrc     <= ALUSrc;
            IDEX_ALUOp      <= ALUOp;
            IDEX_RegWrite   <= RegWrite;
            IDEX_MemRead    <= MemRead;
            IDEX_MemWrite   <= MemWrite;
            IDEX_memtoReg   <= memtoReg;
            IDEX_Branch     <= Branch;
	    IDEX_Jump       <= Jump;
	    IDEX_JumpLink   <= JumpLink;
        end
    end

    //Buffer EX/MEM
    reg [31:0] EXMEM_BranchAddr;  
    reg        EXMEM_Zero;        
    reg [31:0] EXMEM_ALUresult; 
    reg [31:0] EXMEM_ReadData2; 
    reg [4:0]  EXMEM_WriteReg;
    
    reg        EXMEM_Branch;
    reg        EXMEM_BranchNE;
    reg        EXMEM_MemRead;
    reg        EXMEM_MemWrite;
    
    reg        EXMEM_RegWrite;
    reg        EXMEM_memtoReg;
 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EXMEM_BranchAddr <= 32'b0;
            EXMEM_Zero       <= 1'b0;
            EXMEM_ALUresult  <= 32'b0;
            EXMEM_ReadData2  <= 32'b0;
            EXMEM_WriteReg   <= 5'b0;
            EXMEM_Branch     <= 1'b0;
            EXMEM_BranchNE   <= 1'b0;
            EXMEM_MemRead    <= 1'b0;
            EXMEM_MemWrite   <= 1'b0;
            EXMEM_RegWrite   <= 1'b0;
            EXMEM_memtoReg   <= 1'b0;
        end else begin
            EXMEM_BranchAddr <= branch_addr;
            EXMEM_Zero       <= alu_zero;
            EXMEM_ALUresult  <= alu_result;
            EXMEM_ReadData2  <= read_data2;
            EXMEM_WriteReg   <= write_reg;
            EXMEM_Branch     <= Branch;
            EXMEM_BranchNE   <= BranchNE;
            EXMEM_MemRead    <= MemRead;
            EXMEM_MemWrite   <= MemWrite;
            EXMEM_RegWrite   <= RegWrite;
            EXMEM_memtoReg   <= memtoReg;
        end
    end
 
    //Buffer MEM/WB
    reg [31:0] MEMWB_MemReadData;  	
    reg [31:0] MEMWB_ALUresult;    	
    reg [4:0]  MEMWB_WriteReg;	
    
    reg        MEMWB_RegWrite;
    reg        MEMWB_memtoReg;
 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEMWB_MemReadData <= 32'b0;
            MEMWB_ALUresult   <= 32'b0;
            MEMWB_WriteReg    <= 5'b0;
            MEMWB_RegWrite    <= 1'b0;
            MEMWB_memtoReg    <= 1'b0;
        end else begin
            MEMWB_MemReadData <= mem_read_data;
            MEMWB_ALUresult   <= alu_result;
            MEMWB_WriteReg    <= write_reg;
            MEMWB_RegWrite    <= RegWrite;
            MEMWB_memtoReg    <= memtoReg;
        end
    end

	//3.Cuerpo del modulo

	pc u_pc (
		.clk     (clk),
		.reset   (reset),
		.pc_next (pc_final),
		.pc_out  (pc_act)
	);

	pc_add u_pc_adder (
		.pc_in (pc_act),
		.pc4   (pc4)
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
        	.ALUOp    (ALUOp),
        	.MemRead  (MemRead),
        	.MemWrite (MemWrite),
        	.memtoReg (memtoReg),
        	.Branch   (Branch),
        	.BranchNE (BranchNE),
        	.Jump     (Jump),
        	.JumpLink (JumpLink)
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
		.write_reg  (jal_write_reg),
    		.write_data (jal_write_data),
		.read_data1 (read_data1),
		.read_data2 (read_data2)
	);

	Sign_Extend singExtend (
		.inmediate (inmediate),
		.extend    (extended_imm)
	);

	mux2a1 #(.WIDTH(32)) u_mux_alusrc (
		.in0 (read_data2),
		.in1 (extended_imm),
		.sel (ALUSrc),
		.out (alu_input_b)
	);

	Shift_left u_shift_branch (
		.in  (extended_imm),
		.out (extended_shifted)
	);

	adder u_branch_adder ( 
		.A      (pc4),
		.B      (extended_shifted),
		.result (branch_addr)
	);

	alu_control u_alu_ctrl (
		.ALUOp    (ALUOp),
		.funct    (funct),
		.alu_ctrl (alu_ctrl)
	);

	alu u_alu (
		.a         (read_data1),
		.b         (alu_input_b),
		.shamt     (shamt),
		.alu_ctrl  (alu_ctrl),
		.alu_result(alu_result),
		.zero      (alu_zero)
	);

	DataMemory u_data_mem (
		.clk        (clk),
		.MemWrite   (MemWrite),
		.MemRead    (MemRead),
		.address    (alu_result),
		.write_data (read_data2),
		.read_data  (mem_read_data)
	);

	mux2a1 #(32) u_mux_memtoreg (
		.in0 (alu_result),
		.in1 (mem_read_data),
		.sel (memtoReg),
		.out (alu_out_mem)
	);

	mux2a1 #(32) u_mux_branch (
		.in0 (pc4),
    		.in1 (branch_addr),
    		.sel (branch_taken),
    		.out (pc_branch_mux)
	);
	 
	//Logica de salto
	assign pc_jump = {pc4[31:28], instruction[25:0], 2'b00};


	mux2a1 #(32) u_mux_jump (
		.in0 (pc_branch_mux),
		.in1 (pc_jump),
		.sel (Jump),
		.out (pc_final)
	);
endmodule