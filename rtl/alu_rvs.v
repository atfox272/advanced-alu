module alu_rvs #(parameter BLOCK = 8) (
    input  wire [31:0] data_in,
    output reg  [31:0] result
);
    integer i;
    function [BLOCK-1:0] reverse_block;
        input [BLOCK-1:0] x;
        integer j;
        begin
            for (j = 0; j < BLOCK; j = j + 1)
                reverse_block[j] = x[BLOCK - 1 - j];
        end
    endfunction

    always @(*) begin
        for (i = 0; i < 32/BLOCK; i = i + 1)
            result[i*BLOCK +: BLOCK] = reverse_block(data_in[i*BLOCK +: BLOCK]);
    end
endmodule
