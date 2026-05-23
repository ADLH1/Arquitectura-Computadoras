module ALU (ALUctl, A, B, ALUout, Zero);

input [3:0] ALUctl;
input [31:0] A, B;
output reg [31:0] ALUout;
output Zero;

assign Zero = (ALUout == 0);

always @(ALUctl, A, B) begin
    case (ALUctl)
        0: ALUout = A & B;              
        1: ALUout = A | B;              
        2: ALUout = A + B;              
        6: ALUout = A - B;              
        7: ALUout = (A < B) ? 1 : 0;    
        12: ALUout = ~(A | B);          
        default: ALUout = 0;
    endcase
end

endmodule