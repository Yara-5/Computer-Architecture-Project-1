`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:39:14 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
input [6:2] Inst,
output reg Branch,MemRead, MemToReg,
output reg [1:0] ALUOp,
output reg MemWrite, ALUSrc, RegWrite
    );
    
    always@* begin
    case(Inst)
    5'b01100: {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite}=8'b00010001 ;
    5'b00000: {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite}=8'b01100011 ;
    5'b01000: {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite}=8'b00x00110 ;
    5'b11000: {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite}=8'b10x01000 ;
    default: {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite}=8'b00000000 ;
    endcase
    
    
    end
    
endmodule
