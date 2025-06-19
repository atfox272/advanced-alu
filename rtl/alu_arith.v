module alu_arith(inA, inB, out, overflow);
input [31:0] inA, inB;
output [31:0] out;
output overflow;
wire [7:0] cout;
    wire [7:0] Gout, Pout;
    wire [7:0] C;
    assign C[0] = 0;  // carry-in ban đầu = 0
    // Tính carry-in cho từng block
genvar i;
generate 
for(i = 0; i < 7; i = i + 1)begin : carry_gen
assign C[i + 1] = Gout[i] | (Pout[i] & C[i]);
end
endgenerate
    // Ghép 8 CLA 4-bit
    cla_4bit cla0(inA[3:0],   inB[3:0],   C[0], out[3:0],   cout[0], Gout[0], Pout[0]);
    cla_4bit cla1(inA[7:4],   inB[7:4],   C[1], out[7:4],   cout[1], Gout[1], Pout[1]);
    cla_4bit cla2(inA[11:8],  inB[11:8],  C[2], out[11:8],  cout[2], Gout[2], Pout[2]);
    cla_4bit cla3(inA[15:12], inB[15:12], C[3], out[15:12], cout[3], Gout[3], Pout[3]);
    cla_4bit cla4(inA[19:16], inB[19:16], C[4], out[19:16], cout[4], Gout[4], Pout[4]);
    cla_4bit cla5(inA[23:20], inB[23:20], C[5], out[23:20], cout[5], Gout[5], Pout[5]);
    cla_4bit cla6(inA[27:24], inB[27:24], C[6], out[27:24], cout[6], Gout[6], Pout[6]);
    cla_4bit cla7(inA[31:28], inB[31:28], C[7], out[31:28], cout[7], Gout[7], Pout[7]);

    // Tính overflow: carry giữa bit 30-31 khác với carry out
    assign overflow = cout[7];
endmodule
