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
output reg  auipc, lui, jalr, writePC, syst
    );
    
    always@* begin
    case(IR)
    `OPCODE_Arith_R:    {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0001000100000 ;
    `OPCODE_Arith_I:    {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0001001100000 ;
    `OPCODE_Load:       {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0110001100000 ;
    `OPCODE_Store:      {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b00x00110xx000 ;
    `OPCODE_Branch:     {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b10x01000xx000 ;
    `OPCODE_JALR:       {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0000001100110 ;
    `OPCODE_JAL:        {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b000xx0x100010 ;
    `OPCODE_AUIPC:      {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b000xx0x110000 ;
    `OPCODE_LUI:        {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b000xx0x101000 ;
    `OPCODE_SYSTEM:     {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0000000000001 ;
    5'b00_111:          {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0000000000001 ;
    default:            {Branch,MemRead, MemToReg,ALUOp, MemWrite, ALUSrc, RegWrite, auipc, lui, jalr, writePC, syst}=13'b0000000000000 ;
    endcase
    end
    
endmodule
