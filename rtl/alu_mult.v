module alu_mult
#(
    parameter WIDTH = 32
) (
    input   [WIDTH-1:0] a,
    input   [WIDTH-1:0] b,
    output  [WIDTH-1:0] o
);
    wire [2*WIDTH-1:0] product;
    wire [2*WIDTH-1:0] a_sll [0:WIDTH-1];
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_sll
            assign a_sll[i] = (a << i) & {2*WIDTH{b[i]}};
        end
    endgenerate
    assign product = a_sll[0] ^ a_sll[1] ^ a_sll[2] ^ a_sll[3] ^
                     a_sll[4] ^ a_sll[5] ^ a_sll[6] ^ a_sll[7] ^
                     a_sll[8] ^ a_sll[9] ^ a_sll[10] ^ a_sll[11] ^
                     a_sll[12] ^ a_sll[13] ^ a_sll[14] ^ a_sll[15] ^
                     a_sll[16] ^ a_sll[17] ^ a_sll[18] ^ a_sll[19] ^
                     a_sll[20] ^ a_sll[21] ^ a_sll[22] ^ a_sll[23] ^
                     a_sll[24] ^ a_sll[25] ^ a_sll[26] ^ a_sll[27] ^
                     a_sll[28] ^ a_sll[29] ^ a_sll[30] ^ a_sll[31];
    assign o = product[WIDTH-1:0];
endmodule