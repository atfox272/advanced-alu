module alu_crc #(
    parameter DATA_W    = 32,
    parameter KEY_W     = 8
) (
    input   [DATA_W-1:0]    data,
    input   [KEY_W-1:0]     key,
    input                   funct, // 0 - CRC error detection || 1 - CRC join
    output  [DATA_W-1:0]    o
);
    genvar i;

    localparam CRC_FRM_W    = DATA_W;
    localparam XOR_LVL      = CRC_FRM_W - KEY_W + 1;
    
    wire    [CRC_FRM_W-1:0] data_proc;
    wire    [CRC_FRM_W-1:0] data_zero_ext;
    wire    [CRC_FRM_W-1:0] data_crc_frm;
    wire    [KEY_W-1:0]     data_xored  [0:XOR_LVL-1];
    wire                    crc_err_det;
    assign o                = funct ? data_crc_frm[DATA_W-1:0] : {{(DATA_W-1){1'b0}}, crc_err_det};
    assign crc_err_det      = |data_xored[XOR_LVL-1];    // Last remainder == 0 -> No error 
    assign data_crc_frm     = {data, data_xored[XOR_LVL-1][KEY_W-2:0]};
    assign data_zero_ext    = {data, {(KEY_W-1){1'b0}}};
    assign data_proc        = funct ? data_zero_ext : data;

    generate
        for(i = 0; i < XOR_LVL; i = i + 1) begin : xor_element
            if(i == 0) begin : xor_element_head
                alu_crc_xor_ele #(
                    .KEY_W      (KEY_W)
                ) xor_ele (
                    .data       (data_proc[CRC_FRM_W-1-i-:KEY_W]),
                    .key        (key),
                    .data_xored (data_xored[i])
                );
            end
            else begin : xor_element_tail
                alu_crc_xor_ele #(
                    .KEY_W      (KEY_W)
                ) xor_ele (
                    .data       ({data_xored[i-1][KEY_W-2:0], data_proc[CRC_FRM_W-KEY_W-i]}),
                    .key        (key),
                    .data_xored (data_xored[i])
                );
            end
        end
    endgenerate
endmodule

module alu_crc_xor_ele #(
    parameter KEY_W       = 8
) (
    input   [KEY_W-1:0]     data,   
    input   [KEY_W-1:0]     key,
    output  [KEY_W-1:0]     data_xored
);
    // If the MSB of data is "1" then xor, else pass through
    assign data_xored = data ^ (key & {KEY_W{data[KEY_W-1]}}); 
endmodule