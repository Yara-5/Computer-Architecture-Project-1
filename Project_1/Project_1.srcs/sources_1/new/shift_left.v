`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 06:29:50 PM
// Design Name: 
// Module Name: shift_left
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


module shift_left #(parameter n=32)(
input [n-1:0] in,
output [n-1:0] out
    );
    assign out={in[n-2:0],1'b0};
    
endmodule
