module alu_shuffle (
    input  wire [31:0] data_in,
    input  wire        mode, 
    output reg  [31:0] result
);
    integer i;

    always @(*) begin
        if (mode == 1'b0) begin 
            for (i = 0; i < 16; i = i + 1) begin
                result[i*2]   = data_in[i];
                result[i*2+1] = data_in[i+16];
            end
        end else begin 
            for (i = 0; i < 16; i = i + 1) begin
                result[i]      = data_in[i*2];
                result[i + 16] = data_in[i*2 + 1];
            end
        end
    end
endmodule
