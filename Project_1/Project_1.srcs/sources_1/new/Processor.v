`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Processor.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Top module that implements all the processor's functionalities
*
* Change history:   10/21/25    - Initial Implementation
*                   11/5/25     - Whole ALU added
*
**********************************************************************/

module Processor(
input clk, reset
    );
    
    wire [31:0] currentAdrs, futAdrs;
    wire [31:0] inst, readdata1, readdata2;
    wire [31:0] writedata, dataMemAdrs, memDataIn, MemDataOut, Immead, BImm;
    wire regwrite, MemRead, MemWrite;
    wire cf, zf, vf, sf;
    wire [31:0]ALUIn2, ALUResult;
    wire [3:0]ALUSel;
    wire Branch, MemToReg, ALUSrc, selMux2;
    wire [1:0] ALUOp;
    wire [31:0] addOut4, addOutB;
    
    register #(32) PC( .D(futAdrs), .load(1) , .clk(clk), .reset(reset), .Q(currentAdrs) );
    InstMem im(currentAdrs[7:2], inst);
    Register_File rf(writedata, inst[11:7], inst[19:15], inst[24:20],regwrite, clk, reset, readdata1, readdata2);
    DataMem dm(clk,  MemRead,  MemWrite, ALUResult[7:2] , readdata2, MemDataOut);
    prv32_ALU a(.a(readdata1), .b(ALUIn2), .shamt(ALUIn2[4:0]), .r(ALUResult), .cf(), .zf(), .vf(), .sf(), .alufn(ALUSel));
    ALU_Control AC(ALUOp, inst[14:12] , inst[30], ALUSel);
    shift_left sl(Immead, BImm);
    Control_Unit cu(inst[6:2], Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite);
    rv32_ImmGen ig(inst,Immead);
    multiplexer #(32) m1(readdata2, Immead, ALUSrc, ALUIn2);
    assign selMux2 = zf & Branch;
    multiplexer #(32) m2(addOut4, addOutB, selMux2, futAdrs);
    multiplexer #(32) m3(ALUResult, MemDataOut, MemToReg, writedata);
    RCA #(32) add4(currentAdrs, 32'd4, 1'b0, addOut4);
    RCA #(32) addBranch(currentAdrs, BImm, 1'b0, addOutB);
   
    
endmodule
