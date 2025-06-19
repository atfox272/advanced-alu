module alu (
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
        .a          (a), 
        .b          (b), 
        .funct      (funct),
        .out        (out_Logic)
    );

    // Comparison Unit
    alu_comp comp (
        .a          (a),
        .b          (b),
        .funct      (funct),
        .out        (out_Comp)
    );

    // Shift Unit
    alu_shift shifter (
        .a          (a),
        .b          (b),
        .funct      (funct),
        .valid_i    (valid_i),
        .O          (out_Shift),
        .valid_o    (valid_Shift)
    );

    // Bit Count Unit
    alu_bitcnt bitcnt (
        .inA        (a),
        .count      (out_BitCnt)
    );

    // // Reverse Unit
    // Reverse reverse_inst (
    //     .a(a), .funct(funct),
    //     .O(out_Reverse)
    // );

    // // Or-combine Unit
    // OrComb orcomb_inst (
    //     .a(a), .funct(funct),
    //     .O(out_OrComb)
    // );

    // // Shuffle Unit
    // Shuffle shuffle_inst (
    //     .a(a), .funct(funct),
    //     .O(out_Shuffle)
    // );

    // // Unshuffle Unit
    // Unshuffle unshuffle_inst (
    //     .a(a), .funct(funct),
    //     .O(out_Unshuffle)
    // );

    // Multiplier Unit (possibly carry-less)
    alu_mult mult (
        .a  (a),
        .b  (b),
        .o  (out_Mult)
    );

    // CRC Unit
    alu_crc crc_inst (
        .a(a),
        .b(b),
        .funct(funct),
        .valid_i(valid_i),
        .O(out_CRC)
    );

    // Output multiplexer
    always @(*) begin
        case (opcode)
            4'b0000: o = out_Arith;
            4'b0001: o = out_Logic;
            4'b0010: o = out_Comp;
            4'b0011: o = out_Shift;
            4'b0100: o = out_BitCnt;
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
