module alu #(
    parameter DATA_W    = 32,
    parameter CRC_KEY_W = 8
) (
    input               clk,
    input               rst,
    input               valid_i,
    input       [3:0]   opcode,
    input       [2:0]   funct,
    input       [31:0]  a,
    input       [31:0]  b,
    output  reg [31:0]  o,
    output  reg         valid_o,
    output              overflow
);

    wire    [31:0] out_Arith, out_Logic, out_Comp, out_Shift;
    wire    [31:0] out_BitCnt, out_Reverse, out_Shuffle;
    wire    [31:0] out_Unshuffle, out_Mult, out_CRC;
    wire           valid_Shift, valid_Mult, valid_CRC;
    wire    [31:0] out_OrComb;

    // Arithmetic Unit
    alu_arith arith (
        .inA        (a),
        .inB        (b),
        .out        (out_Arith),
        .overflow   (overflow)
    );

    // Logic Unit
    alu_logic logic (
        .inA        (a), 
        .inB        (b), 
        .funct      (funct),
        .out        (out_Logic)
    );

    // Comparison Unit
    alu_comp comp (
        .a          (a),
        .b          (b),
        .funct      (funct),
        .out        (out_Comp[0])
    );

    // Shift Unit
    alu_shift shifter (
        .clk        (clk),
        .reset      (rst),      
        .a          (a),
        .b          (b),
        .funct      (funct),
        .valid_i    (valid_i),
        .result     (out_Shift),
        .valid_o    (valid_Shift)
    );

    // Bit Count Unit
    alu_bitcnt bitcnt (
        .inA        (a),
        .count      (out_BitCnt[5:0])
    );

    // Reverse Unit
    alu_rvs reverse (
        .din        (a),
        .funct      (funct[2:0]),
        .res        (out_Reverse)
    );

    // Or-combine Unit
    alu_or_comb orcomb (
        .din        (a),
        .funct      (funct[2:0]),
        .res        (out_OrComb)
    );

    // Shuffle Unit
    alu_shuffle shuffle (
        .din    (a),
        .funct  (funct),
        .mode   (1'b0),
        .res    (out_Shuffle)
    );

    // Unshuffle Unit
    alu_shuffle unshuffle (
        .din    (a),
        .funct  (funct),
        .mode   (1'b1),
        .res    (out_Unshuffle)
    );

    // Multiplier Unit (possibly carry-less)
    alu_mult mult (
        .a          (a),
        .b          (b),
        .o          (out_Mult)
    );

    // CRC Unit
    alu_crc #(
        .DATA_W     (DATA_W),
        .KEY_W      (CRC_KEY_W)
    ) crc (
        .data       (a),
        .key        (b[CRC_KEY_W-1:0]),
        .funct      (funct[0]),
        .o          (out_CRC)
    );

    // Output multiplexer
    always @(*) begin
        case (opcode)
            4'b0000: o = out_Arith;
            4'b0001: o = out_Logic;
            4'b0010: o = {31'b0, out_Comp[0]};
            4'b0011: o = out_Shift;
            4'b0100: o = {26'b0, out_BitCnt[5:0]};
            4'b0101: o = out_Reverse;
            4'b0110: o = out_OrComb;
            4'b0111: o = out_Shuffle;
            4'b1000: o = out_Unshuffle;
            4'b1001: o = out_Mult;
            4'b1010: o = out_CRC;
            default: o = 32'hDEADBEEF;
        endcase

        // Set valid_o based on opcode and submodule valid signals
        case (opcode)
            4'b0011: valid_o = valid_Shift; // Shift unit
            default: valid_o = valid_i;     // Others are combinational
        endcase
    end

endmodule
