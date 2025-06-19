module alu_logic(inA, inB, funct, out);
parameter AND = 0, OR =1, NOT = 2, XOR = 3;
input [31:0]inA, inB;
input [2:0] funct;
output reg [31:0] out;
  always @(*) begin
        case (funct)
            AND: out = inA & inB;
            OR : out = inA | inB;
            NOT: out = ~inA;
            XOR: out = inA ^ inB;
            default: out = 0;
        endcase
    end
endmodule
