module alu_comp (
    input [31:0] a,        
    input [31:0] b,          
    input [2:0] funct,      
    output reg out      
);

    localparam 
        EQ  = 3'b000,        // Equal
        NEQ = 3'b001,        // Not Equal
        UGT = 3'b010,        // Unsigned Greater Than
        ULT = 3'b011,        // Unsigned Less Than
        SGT = 3'b100,        // Signed Greater Than
        SLT = 3'b101;        // Signed Less Than

    always @(*) begin
        case(funct)
            EQ:  out = (a == b);
            NEQ: out = (a != b);
            UGT: out = (a > b);
            ULT: out = (a < b);
            SGT: out = ($signed(a) > $signed(b));
            SLT: out = ($signed(a) < $signed(b));
            default: out = 0;
        endcase
    end

endmodule