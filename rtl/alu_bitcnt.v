module alu_bitcnt(inA, count);
input [31:0]inA;
output [5:0]count;
wire [1:0]level0 [15:0];
wire [2:0]level1 [7:0];
wire [3:0]level2 [3:0];
wire [4:0]level3 [1:0];
wire [5:0]level4;
genvar i;
generate
for(i = 0; i < 16; i = i + 1)begin: level0_gen
assign level0[i] = inA[i*2] + inA[i*2 + 1];
end
endgenerate
generate
for(i = 0; i < 8; i = i + 1)begin: level1_gen
assign level1[i] = level0[i*2] + level0[i*2 + 1];
end
endgenerate
generate
for(i = 0; i < 4; i = i + 1)begin: level2_gen
assign level2[i] = level1[i*2] + level1[i*2 + 1];
end
endgenerate
generate
for(i = 0; i < 2; i = i + 1)begin: level3_gen
assign level3[i] = level2[i*2] + level2[i*2 + 1];
end
endgenerate
assign level4 = level3[0] + level3[1];
assign count = level4;
endmodule
