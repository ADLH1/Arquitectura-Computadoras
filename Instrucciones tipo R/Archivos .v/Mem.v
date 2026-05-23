module Mem (
    input             clk,
    input             MemWrite,
    input      [31:0] address,
    input      [31:0] write_data,
    output     [31:0] read_data
);

    reg [31:0] memory [0:63];

    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 32'd0;
    end

    always @(posedge clk) begin
        if (MemWrite)
            memory[address[7:2]] <= write_data;
    end

    assign read_data = memory[address[7:2]];

endmodule
