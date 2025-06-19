`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 08:33:59 PM
// Design Name: 
// Module Name: cla_4bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cla_4bit(A, B, cin, sum, cout, Gout, Pout);
input  [3:0] A, B;
input cin;
output[3:0] sum;
output cout, Gout, Pout;
    wire [3:0] G, P;
    wire [4:0] C;

    assign C[0] = cin;
    // Generate và propagate 
    assign G = A & B;
    assign P = A ^ B;
    // Tính CLA
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1])
               | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    // outpuy
    assign sum = P ^ C[3:0];
    assign cout = C[4];
    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1])| (P[3] & P[2] & P[1] & G[0]);
    assign Pout = P[3] & P[2] & P[1] & P[0];
endmodule