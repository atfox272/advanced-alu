`timescale 1ns / 1ps

module alu_tb;

    parameter DATA_W    = 32;
    parameter CRC_KEY_W = 8;

    // Inputs
    reg               clk;
    reg               rst;
    reg               valid_i;
    reg  [3:0]        opcode;
    reg  [2:0]        funct;
    reg  [DATA_W-1:0] a;
    reg  [DATA_W-1:0] b;

    // Outputs
    wire [DATA_W-1:0] o;
    wire              valid_o;
    wire              overflow;

    // Instantiate the ALU
    alu #(
        .DATA_W     (DATA_W),
        .CRC_KEY_W  (CRC_KEY_W)
    ) dut (
        .clk        (clk),
        .rst        (rst),
        .valid_i    (valid_i),
        .opcode     (opcode),
        .funct      (funct),
        .a          (a),
        .b          (b),
        .o          (o),
        .valid_o    (valid_o),
        .overflow   (overflow)
    );

    // Clock generation
    always #1 clk = ~clk;

    // Task to apply a test vector
    task apply_test(
        input [3:0] op,
        input [2:0] fn,
        input [DATA_W-1:0] val_a,
        input [DATA_W-1:0] val_b,
        input string op_name
    );
    begin
        @(negedge clk);
        opcode  <= op;
        funct   <= fn;
        a       <= val_a;
        b       <= val_b;
        valid_i <= 1;
        $display("Test: %-8s | A = 0x%08X, B = 0x%08X", op_name, val_a, val_b);
        @(negedge clk);
        valid_i <= 0;
        wait (valid_o);
        @(posedge clk);
        $display("=> O = 0x%08X, overflow = %b\n", o, overflow);
    end
    endtask

    // Test sequence
    initial begin
        // Init
        clk = 0;
        rst = 1;
        valid_i = 0;
        opcode = 0;
        funct = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        rst = 0;

        // Give a few cycles after reset
        repeat (2) @(posedge clk);

        // Run test cases
        apply_test(4'b0000, 3'b000, 32'h0000000F, 32'h00000003, "Arith");    // add/sub/etc
        apply_test(4'b0001, 3'b001, 32'hA5A5A5A5, 32'h5A5A5A5A, "Logic(OR)");    // or
        apply_test(4'b0001, 3'b000, 32'hA5A5A5A5, 32'h5A5A5A5A, "Logic(AND)");    // and
        apply_test(4'b0001, 3'b010, 32'h0F0F0F0F, 32'h00000000, "Logic(NOT)");    // not
        apply_test(4'b0001, 3'b011, 32'hA5A5A5A5, 32'hA5A5A5A5, "Logic(XOR)");    // xor
        apply_test(4'b0010, 3'b000, 32'h00000005, 32'h00000009, "Compare(EQ)");  // equal
        apply_test(4'b0010, 3'b010, 32'h0000000A, 32'h00000002, "Compare(UGT)");  // unsigned greater than
        apply_test(4'b0011, 3'b010, 32'h000000F0, 32'h00000004, "Shift(SRA)");    // sra
        apply_test(4'b1001, 3'b000, 32'h0000000F, 32'h00000007, "Mult");     // carry-less mult
        apply_test(4'b1010, 3'b000, 32'hDEADBEEF, 32'h00000000, "CRC");      // CRC

        // Finish simulation
        #20;
        $finish;
    end

endmodule
