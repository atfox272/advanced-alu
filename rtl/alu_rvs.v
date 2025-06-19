module alu_rvs (
    input  wire [31:0] din,
    input  wire [2:0]  funct,     
    output reg  [31:0] res
);
    integer i, j;
    reg [31:0] temp;
    function [15:0] rvs;
        input [15:0] x;
        input integer block;
        begin
            for (j = 0; j < block; j = j + 1)
                rvs[j] = x[block - 1 - j];
        end
    endfunction

    always @(*) begin
        res = 0;
        case (funct)
            3'b000: begin
                res = din; 
                end

          3'b001: begin 
                for (i = 0; i < 16; i = i + 1)
                    res[i*2 +: 2] = rvs(din[i*2 +: 2], 2);
                    end
          
            3'b010: begin 
                for (i = 0; i < 8; i = i + 1)
                    res[i*4 +: 4] = rvs(din[i*4 +: 4], 4);
                    end
          
            3'b011: begin 
                for (i = 0; i < 4; i = i + 1)
                    res[i*8 +: 8] = rvs(din[i*8 +: 8], 8);
                    end
          
            3'b100: begin 
                for (i = 0; i < 2; i = i + 1)
                    res[i*16 +: 16] = rvs(din[i*16 +: 16], 16);
                    end

             default: res = 32'hDEAD_BEEF; 
        endcase
    end
endmodule