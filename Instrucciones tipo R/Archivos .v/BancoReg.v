module BancoReg (
    input             clk,
    input             RegWrite,
    input      [4:0]  read_reg1,
    input      [4:0]  read_reg2,
    input      [4:0]  write_reg,
    input      [31:0] write_data,
    output     [31:0] read_data1,
    output     [31:0] read_data2
);

    reg [31:0] registers [0:31];

    integer i;
    initial begin
        registers[0] = 32'd0;
        registers[1] = 32'd10;
        registers[2] = 32'd20;
        registers[3] = 32'd5;
        registers[4] = 32'd15;
        for (i = 5; i < 32; i = i + 1)
            registers[i] = 32'd0;
    end

    always @(posedge clk) begin
        if (RegWrite && (write_reg != 5'b00000))
            registers[write_reg] <= write_data;
    end

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

endmodule
