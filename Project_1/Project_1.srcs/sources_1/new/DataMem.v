`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 11:21:50 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem
(input clk, input MemRead, input MemWrite,
input [5:0] addr, input [31:0] data_in, output [31:0] data_out);
    reg [31:0] mem [0:63];
    assign data_out=(MemRead)? mem[addr]:0;
    initial begin
        mem[0]=32'd16;
        mem[1]=32'd4;
        mem[2]=32'd25;
        mem[6]=4;
        mem[7]=1;
    end

    always @(posedge clk) begin
        if(MemWrite)
            mem[addr] = data_in;
    end
endmodule