module alu_shift (
    input clk,               
    input reset,            
    input [31:0] a,         
    input [31:0] b,        
    input [2:0] funct,    
    input valid_i,           
    output reg [31:0] result,
    output reg valid_o      
);
    localparam 
        SHL    = 3'b000,     // Logical Shift Left
        SHR    = 3'b001,     // Logical Shift Right
        ASHR   = 3'b010,     // Arithmetic Shift Right
        FSHIFT = 3'b011;     // Funnel Shift

    reg [63:0] funnel_reg;
    reg [4:0] shift_count;
    
    always @(posedge clk) begin
        if (reset) begin
            result <= 0;
            valid_o <= 0;
            funnel_reg <= 0;
        end 
        else if (valid_i) begin
            case(funct)
                SHL: begin
                    result <= a << b[4:0];
                    valid_o <= 1;
                end
                SHR: begin
                    result <= a >> b[4:0];
                    valid_o <= 1;
                end
                ASHR: begin
                    result <= $signed(a) >>> b[4:0];
                    valid_o <= 1;
                end
                FSHIFT: begin
                    funnel_reg <= {a, b};
                    shift_count <= b[4:0];
                    valid_o <= 0;
                end
                default: begin
                    result <= a;
                    valid_o <= 1;
                end
            endcase
        end
        
        // Xử lý Funnel Shift
        if (shift_count > 0) begin
            funnel_reg <= funnel_reg >> 1;
            shift_count <= shift_count - 1;
            if (shift_count == 1) begin
                result <= funnel_reg[63:32];
                valid_o <= 1;
            end
        end
    end

endmodule