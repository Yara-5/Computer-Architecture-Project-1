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
*                   11/5/25     - Whole ALU added
                    11/9/25     - lui, jal, jalr, auipc, lbu, lhu instructions added
*
**********************************************************************/

module Processor(
input clk, reset
    );
    
    wire [31:0] currentAdrs, futAdrs;
    wire [31:0] inst, readdata1, readdata2;
    wire [31:0] writedata, dataMemAdrs, memDataIn, MemDataOut, Immead, dataFromMem;
    wire regwrite, MemRead, MemWrite, bsigned, hsigned;
    wire cf, zf, vf, sf, branch_taken;
    wire [31:0]ALUIn2, ALUResult;
    wire [3:0]ALUSel;
    wire Branch, MemToReg, ALUSrc, selMux2, selMux6, selMux8, selMux9;
    wire [1:0] ALUOp, whb;
    wire [31:0] addOut4, addOutB;
    wire auipc, lui, jalr, writePC;
    wire [31:0]wm2, wm3, wm5, wm6, wm8;
    
    register #(32) PC( .D(futAdrs), .load(1'b1) , .clk(clk), .reset(reset), .Q(currentAdrs) );
    InstMem im(currentAdrs[7:2], inst);
    Register_File rf(writedata, inst[11:7], inst[19:15], inst[24:20],regwrite, clk, reset, readdata1, readdata2);
    StoreLoadControl slc(.fun3(inst[`IR_funct3]), .whb(whb), .bsigned(bsigned), .hsigned(hsigned));
    DataMem dm(clk,  MemRead,  MemWrite, whb, ALUResult[7:0] , readdata2, MemDataOut);
    prv32_ALU a(.a(readdata1), .b(ALUIn2), .shamt(ALUIn2[4:0]), .r(ALUResult), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUSel));
    ALU_Control AC(ALUOp, inst[14:12] , inst[30], ALUSel);
    Control_Unit cu(inst[6:2], Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC);
    BranchUnit bu(.funct3(inst[`IR_funct3]), .Z(zf),.C(cf),.V(vf),.S(sf),.branch_taken(branch_taken) );
    rv32_ImmGen ig(inst,Immead);
    multiplexer #(32) m1(readdata2, Immead, ALUSrc, ALUIn2);
    assign selMux2 = (branch_taken & Branch) | writePC;
    assign selMux6 = writePC | auipc;
    assign selMux8 = bsigned & MemDataOut[7];
    assign selMux9 = hsigned & MemDataOut[15];

    multiplexer #(32) m2(addOut4, addOutB, selMux2, wm2);       // choosing future address
    multiplexer #(32) m4(wm2, ALUResult, jalr, futAdrs);        // choosing future address
    multiplexer #(32) m3(addOut4, addOutB, auipc, wm3);             // choosing write data
    multiplexer #(32) m5(ALUResult, Immead, lui, wm5);              // choosing write data
    multiplexer #(32) m6(wm5, wm3, selMux6, wm6);                   // choosing write data
    multiplexer #(32) m7(wm6, dataFromMem, MemToReg, writedata);     // choosing write data
    multiplexer #(32) m8(MemDataOut, {24'hFFFFFF,MemDataOut[7:0]}, selMux8, wm8);       // choosing dataFromMem
    multiplexer #(32) m9(wm8, {16'hFFFF,MemDataOut[15:0]}, selMux9, dataFromMem);       // choosing dataFromMem
    RCA #(32) add4(currentAdrs, 32'd4, 1'b0, addOut4);
    RCA #(32) addBranch(currentAdrs, Immead, 1'b0, addOutB);
   
    
endmodule
