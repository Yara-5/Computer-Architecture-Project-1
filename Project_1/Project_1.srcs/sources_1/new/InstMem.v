`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 11:08:06 AM
// Design Name: 
// Module Name: InstMem
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


module InstMem (input [5:0] addr, output [31:0] data_out);
    reg [31:0] mem [0:63];
    assign data_out = mem[addr];
    
    initial begin
        $readmemh("C:/Users/Yara2005/Computer-Architecture-Project-1/Test Cases/Testcase6.hex", mem);
    end

endmodule