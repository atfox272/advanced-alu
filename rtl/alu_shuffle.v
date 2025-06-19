module alu_shuffle (
    input  wire [31:0] din,
    input  wire [2:0]  funct,     
    input  wire mode,      
    output reg [31:0] res
);
    integer i;

    always @(*) begin
        res = 0;
        case (funct)
            3'b000: begin 
                for (i = 0; i < 8; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[2*i]     = din[i];
                        res[2*i + 1] = din[16 + i];
                    end else begin
                        res[i]       = din[2*i];
                        res[16 + i]  = din[2*i + 1];
                    end
                end
            end
            3'b001: begin 
                for (i = 0; i < 8; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[4*i +: 2]     = din[2*i +: 2];
                        res[4*i + 2 +: 2] = din[16 + 2*i +: 2];
                    end else begin
                        res[2*i +: 2]       = din[4*i +: 2];
                        res[16 + 2*i +: 2]  = din[4*i + 2 +: 2];
                    end
                end
            end
            3'b010: begin 
                for (i = 0; i < 4; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[8*i +: 4]     = din[4*i +: 4];
                        res[8*i + 4 +: 4] = din[16 + 4*i +: 4];
                    end else begin
                        res[4*i +: 4]       = din[8*i +: 4];
                        res[16 + 4*i +: 4]  = din[8*i + 4 +: 4];
                    end
                end
            end
            3'b011: begin 
                for (i = 0; i < 2; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[16*i +: 8]     = din[8*i +: 8];
                        res[16*i + 8 +: 8] = din[16 + 8*i +: 8];
                    end else begin
                        res[8*i +: 8]       = din[16*i +: 8];
                        res[16 + 8*i +: 8]  = din[16*i + 8 +: 8];
                    end
                end
            end
            3'b100: begin 
                res=din;
            end
            default: begin 
                for (i = 0; i < 8; i = i + 1) begin
                    if (mode == 1'b0) begin
                        res[2*i]     = din[i];
                        res[2*i + 1] = din[16 + i];
                    end else begin
                        res[i]       = din[2*i];
                        res[16 + i]  = din[2*i + 1];
                    end
                end
            end
        endcase
    end 
endmodule
