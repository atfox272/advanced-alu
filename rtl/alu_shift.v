`timescale 1ns / 1ps

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
        SHL     = 3'b000,  // Logical Left
        SHR     = 3'b001,  // Logical Right
        ASHR    = 3'b010,  // Arithmetic Right
        FSHIFT_R = 3'b011, // Funnel Shift Right
        FSHIFT_L = 3'b100; // Funnel Shift Left

    reg [63:0] funnel_reg;
    reg [4:0] shift_count;
    reg direction; // 0: right, 1: left

    always @(posedge clk) begin
        if (reset) begin
            result <= 0;
            valid_o <= 0;
            funnel_reg <= 0;
            shift_count <= 0;
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
                FSHIFT_R: begin
                    funnel_reg <= {a, b};
                    shift_count <= b[4:0];
                    direction <= 0;
                    valid_o <= 0;
                end
                FSHIFT_L: begin
                    funnel_reg <= {b, a};
                    shift_count <= b[4:0];
                    direction <= 1;
                    valid_o <= 0;
                end
                default: begin
                    result <= a;
                    valid_o <= 1;
                end
            endcase
        end

        if (shift_count > 0) begin
            if (direction == 0) begin
                // Shift right
                funnel_reg <= funnel_reg >> 1;
            end else begin
                // Shift left
                funnel_reg <= funnel_reg << 1;
            end
            
            shift_count <= shift_count - 1;
            
            if (shift_count == 1) begin
                result <= direction ? funnel_reg[63:32] : funnel_reg[31:0];
                valid_o <= 1;
            end
        end
    end
endmodule