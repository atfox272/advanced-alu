module alu_shuffle (
    input  wire [31:0] din,
    input  wire [2:0]  funct,     
    input  wire mode,      
    output reg [31:0] res
);
    integer i;
    integer block;

    always @(*) begin
        res = 0;

        case (funct)
            3'b000: block = 1;
            3'b001: block = 2;
            3'b010: block = 4;
            3'b011: block = 8;
            3'b100: block = 16;
            default: block = 1;
        endcase

        if (mode == 1'b0) begin 
            for (i = 0; i < (32 / (block * 2)); i = i + 1) 
            begin
                res[i*2*block +: block]       = din[i*block +: block];
                res[i*2*block + block +: block] = din[(32/2) + i*block +: block];
            end
        end else 
            begin  
            for (i = 0; i < (32 / (block * 2)); i = i + 1) begin
                res[i*block +: block]         = din[i*2*block +: block];
                res[(32/2) + i*block +: block] = din[i*2*block + block +: block];
            end
        end
    end
endmodule
