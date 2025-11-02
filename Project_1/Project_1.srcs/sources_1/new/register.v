`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 05:28:26 PM
// Design Name: 
// Module Name: register
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


module register #(parameter n=32)(
    input [n-1:0]D,
input load,
input clk,
input reset,
output [n-1:0]Q
);
wire [n-1:0] in;


genvar i;
for (i=0; i<n; i=i+1) begin
assign in[i]=load? D[i] : Q[i] ;
    DFlipFlop ff(clk, reset, in[i], Q[i]);
end
endmodule
