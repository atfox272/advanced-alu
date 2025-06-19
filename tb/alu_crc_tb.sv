`timescale 1ns/1ps

module alu_crc_tb;

    // Parameters
    localparam DATA_W = 32;
    localparam KEY_W  = 4;

    // DUT signals
    reg  [DATA_W-1:0] data;
    reg  [KEY_W-1:0]  key;
    reg               funct;
    wire [DATA_W-1:0] o;

    // Instantiate DUT
    alu_crc #(
        .DATA_W (DATA_W),
        .KEY_W  (KEY_W)
    ) dut (
        .data   (data),
        .key    (key),
        .funct  (funct),
        .o      (o)
    );

    // Test procedure
    initial begin
        // Test 1: CRC error detection
        data  = 32'b100100001;
        key   = 8'b1101;
        funct = 1'b0;
        #10;
        $display("Test 1 - CRC error detection: funct=0x%1b data=0x%h, key=0x%h, o=0x%h", funct, data, key, o);

        // Test 2: CRC join
        data  = 32'b100100;
        key   = 8'b1101;
        funct = 1'b1;
        #10;
        $display("Test 2 - CRC join: funct=0x%1b data=0x%h, key=0x%h, o=0x%h", funct, data, key, o);

        // // Test 3: All zeros
        // data  = 32'h00000000;
        // key   = 8'h00;
        // funct = 1'b0;
        // #10;
        // $display("Test 3 - All zeros: funct=0x%1b data=0x%h, key=0x%h, o=0x%h", funct, data, key, o);

        // // Test 4: All ones
        // data  = 32'hFFFFFFFF;
        // key   = 8'hFF;
        // funct = 1'b1;
        // #10;
        // $display("Test 4 - All ones: funct=0x%1b data=0x%h, key=0x%h, o=0x%h", funct, data, key, o);

        // // Test 5: Random values
        // data  = 32'hA5A5A5A5;
        // key   = 8'h5A;
        // funct = 1'b0;
        // #10;
        // $display("Test 5 - Random: funct=0x%1b data=0x%h, key=0x%h, o=0x%h", funct, data, key, o);

        $finish;
    end

endmodule