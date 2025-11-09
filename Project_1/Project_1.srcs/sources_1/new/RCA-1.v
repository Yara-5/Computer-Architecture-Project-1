`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 05:03:56 PM
// Design Name: 
// Module Name: RCA
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


module RCA #(parameter N = 8)(
input [N-1:0] A,
input [N-1:0] B,
input c0,
output [N-1:0] Sum
    );
    
wire [N:0]Cin;
genvar i;
assign Cin[0]=c0;
generate
for (i=0; i<N; i=i+1) begin
FullAdder FA(.A(A[i]), .B(B[i]),.C(Cin[i]), .sum(Sum[i]), .Cout (Cin[i+1]));
end
endgenerate
//assign Sum[N]=Cin[N];
    
endmodule
