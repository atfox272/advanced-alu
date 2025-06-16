module alu_or_comb_dynamic (
    input  wire [31:0] din,
    input  wire [2:0]  funct,     
    output reg  [31:0] res
);
    integer i;

    always @(*) begin
        res = 32'b0;

        case (funct)
        
            3'b000: begin 
                res = din;
                    end
                    
            3'b001: begin 
                for (i = 0; i < 16; i = i + 1)
                    res[i*2 +: 2] = {1'b0, |din[i*2 +: 2]};
                    end
                    
            3'b010: begin 
                for (i = 0; i < 8; i = i + 1)
                    res[i*4 +: 4] = {3'b000, |din[i*4 +: 4]};
                    end
                    
            3'b011: begin 
                for (i = 0; i < 4; i = i + 1)
                    res[i*8 +: 8] = {7'b0000000, |din[i*8 +: 8]};
                    end
                    
            3'b100: begin 
                for (i = 0; i < 2; i = i + 1)
                    res[i*16 +: 16] = {15'b0, |din[i*16 +: 16]};
                    end
                    
            default: res = 32'hDEAD_BEEF;
        endcase
    end
endmodule
