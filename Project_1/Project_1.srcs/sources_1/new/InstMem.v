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
    mem[0]=32'b00000000000000000000000010110011 ; //lw x1, 0(x0)
    mem[1]=32'b00000001100000000010000100000011 ; //lw x2, 4(x0)
    mem[2]=32'b00000001110000000010001010000011 ; //lw x3, 8(x0)
    mem[3]=32'b00000000000000001010000110000011 ; //or x4, x1, x2
    mem[4]=32'b00000000010100011111001000110011; //beq x4, x3, 4
    mem[5]=32'b00000000001000001000000010110011 ; //add x3, x1, x2
    mem[6]=32'b11111110000000100000101011100011 ; //add x5, x3, x2
    mem[7]=32'b01000000001000001000000010110011; //sw x5, 12(x0)
    mem[8]=32'b00000000001100000010111000100011 ; //lw x6, 12(x0)
    mem[9]=32'b00000001110000000010000010000011 ; //and x7, x6, x1
    mem[10]=32'b00000000001000001110000010110011 ; //sub x8, x1, x2
end
endmodule