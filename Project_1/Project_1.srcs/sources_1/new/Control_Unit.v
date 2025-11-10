`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: Processor.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Top module that implements all the processor's functionalities
*
* Change history:   10/21/25    - Initial Implementation
                    11/9/25     - Adding new formats and signals
*
**********************************************************************/


module Control_Unit(
input [6:2] IR,
output reg Branch,MemRead, MemToReg,
output reg [1:0] ALUOp,
output reg MemWrite, ALUSrc, RegWrite,
output reg  auipc, lui, jalr, writePC
    );
    
    always@* begin
    case(IR)
    `OPCODE_Arith_R:    {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000100010000 ;
    `OPCODE_Arith_I:    {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000100110000 ;
    `OPCODE_Load:       {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b011000110000 ;
    `OPCODE_Store:      {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b00x00110xx00 ;
    `OPCODE_Branch:     {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b10x01000xx00 ;
    `OPCODE_JALR:       {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000000110011 ;
    `OPCODE_JAL:        {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000xx0x10001 ;
    `OPCODE_AUIPC:      {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000xx0x11000 ;
    `OPCODE_LUI:        {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000xx0x10100 ;
    default:            {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC}=12'b000000000000 ;
    endcase
    end
    
endmodule
