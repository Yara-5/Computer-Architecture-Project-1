`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 04:56:19 PM
// Design Name: 
// Module Name: Single_Cycle_P
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


module Processor(
input clk, reset
    );
    
    wire [31:0] currentAdrs, futAdrs;
    wire [31:0] inst, readdata1, readdata2;
    wire [31:0] writedata, dataMemAdrs, memDataIn, MemDataOut, Immead, BImm;
    wire regwrite, MemRead, MemWrite, zerof;
    wire [31:0]ALUIn2, ALUResult;
    wire [3:0]ALUSel;
    wire Branch, MemToReg, ALUSrc, selMux2;
    wire [1:0] ALUOp;
    wire [31:0] addOut4, addOutB;
    
    register #(32) PC( .D(futAdrs), .load(1) , .clk(clk), .reset(reset), .Q(currentAdrs) );
    InstMem im(currentAdrs[7:2], inst);
    Register_File rf(writedata, inst[11:7], inst[19:15], inst[24:20],regwrite, clk, reset, readdata1, readdata2);
    DataMem dm(clk,  MemRead,  MemWrite, ALUResult[7:2] , readdata2, MemDataOut);
    ALU a(readdata1,ALUIn2,ALUSel,ALUResult, zerof);
    ALU_Control AC(ALUOp, inst[14:12] , inst[30], ALUSel);
    shift_left sl(Immead, BImm);
    Control_Unit cu(inst[6:2], Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite);
    ImmGen ig(inst,Immead);
    multiplexer #(32) m1(readdata2, Immead, ALUSrc, ALUIn2);
    assign selMux2 = zerof & Branch;
    multiplexer #(32) m2(addOut4, addOutB, selMux2, futAdrs);
    multiplexer #(32) m3(ALUResult, MemDataOut, MemToReg, writedata);
    RCA #(32) add4(currentAdrs, 32'd4, 1'b0, addOut4);
    RCA #(32) addBranch(currentAdrs, BImm, 1'b0, addOutB);
   
    
endmodule
