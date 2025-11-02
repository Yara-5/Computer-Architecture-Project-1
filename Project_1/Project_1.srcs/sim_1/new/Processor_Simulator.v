`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 06:35:02 PM
// Design Name: 
// Module Name: Ex1_tb
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


module Processor_Simulator();

Processor scp(clk, reset);

reg clk;
reg reset;

localparam clk_per=20;
initial begin
clk=1'b0;
forever #(clk_per/2) clk=~clk;
end

initial begin 
reset =1'b1;
#(clk_per)
reset = 1'b0;
end

endmodule
