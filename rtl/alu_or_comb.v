module alu_or_comb #(parameter BLOCK = 8) (
    input  wire [31:0] data_in,
    output reg  [31:0] result
);
    integer i;

    always @(*) begin
        result = 0;
        for (i = 0; i < 32/BLOCK; i = i + 1)
            result[i*BLOCK +: BLOCK] = { {(BLOCK-1){1'b0}}, |data_in[i*BLOCK +: BLOCK] };
    end
endmodule
