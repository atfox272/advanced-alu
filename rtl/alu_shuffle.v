module alu_shuffle (
    input  wire [31:0] din,
    input  wire [2:0]  funct,
    input  wire        mode,
    output reg  [31:0] res
);
    integer i;

    always @(*) begin
        res = 32'b0;

        case (funct)
            3'b000: begin
                for (i = 0; i < 8; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[2*i]     = din[i];
                        res[2*i+1]   = din[16 + i];
                    end else begin
                        res[i]       = din[2*i];
                        res[16 + i]  = din[2*i + 1];
                    end
                end
            end

            3'b001: begin
                for (i = 0; i < 8; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[4*i]     = din[2*i];
                        res[4*i+1]   = din[2*i+1];
                        res[4*i+2]   = din[16 + 2*i];
                        res[4*i+3]   = din[16 + 2*i+1];
                    end else begin
                        res[2*i]       = din[4*i];
                        res[2*i+1]     = din[4*i+1];
                        res[16 + 2*i]  = din[4*i+2];
                        res[16 + 2*i+1] = din[4*i+3];
                    end
                end
            end

            3'b010: begin
                for (i = 0; i < 4; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[8*i+0] = din[4*i+0];
                        res[8*i+1] = din[4*i+1];
                        res[8*i+2] = din[4*i+2];
                        res[8*i+3] = din[4*i+3];
                        res[8*i+4] = din[16 + 4*i+0];
                        res[8*i+5] = din[16 + 4*i+1];
                        res[8*i+6] = din[16 + 4*i+2];
                        res[8*i+7] = din[16 + 4*i+3];
                    end else begin
                        res[4*i+0] = din[8*i+0];
                        res[4*i+1] = din[8*i+1];
                        res[4*i+2] = din[8*i+2];
                        res[4*i+3] = din[8*i+3];
                        res[16 + 4*i+0] = din[8*i+4];
                        res[16 + 4*i+1] = din[8*i+5];
                        res[16 + 4*i+2] = din[8*i+6];
                        res[16 + 4*i+3] = din[8*i+7];
                    end
                end
            end

            3'b011: begin
                if (mode == 1'b0) begin
                    for (i = 0; i < 8; i = i + 1) begin
                        res[i]     = din[i];
                        res[8 + i] = din[16 + i];
                    end
                    for (i = 0; i < 8; i = i + 1) begin
                        res[16 + i] = din[8 + i];
                        res[24 + i] = din[24 + i];
                    end
                end else begin
                    for (i = 0; i < 8; i = i + 1) begin
                        res[i]     = din[i];
                        res[16 + i] = din[8 + i];
                        res[8 + i] = din[16 + i];
res[24 + i] = din[24 + i];
                    end
                end
            end

            3'b100: begin
                res = din; 
            end

            default: begin
                res = 32'hDEAD_BEEF;
            end
        endcase
    end
endmodule