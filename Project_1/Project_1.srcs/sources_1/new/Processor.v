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
                    11/16/25    - adjusting ALU_Control inputs
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
    wire Branch, MemToReg, ALUSrc, selMux2, selMux6, selMux8, selMux9, syst;
    wire [1:0] ALUOp, whb;
    wire [31:0] addOut4, addOutB;
    wire auipc, lui, jalr, writePC;
    wire [31:0]wm2, wm3, wm4, wm5, wm6, wm8;
    
    
    
    assign selMux10 = syst | jalr;
   
    RCA #(32) add4(currentAdrs, 32'd4, 1'b0, addOut4);
    multiplexer #(32) m2(addOut4, addOutB, selMux2, wm2);       // choosing future address
    multiplexer #(32) m4(currentAdrs, ALUResult, jalr, wm4);    // choosing future address
    multiplexer #(32) m10(wm2, wm4, selMux10, futAdrs);         // choosing future address 
    register #(32) PC( .D(futAdrs), .load(1'b1) , .clk(clk), .reset(reset), .Q(currentAdrs) );
    InstMem im(currentAdrs[7:2], inst);
   
    wire [31:0] IF_ID_PC, IF_ID_Inst;
    register #(64) IF_ID (.clk(clk),.reset(reset),.load(1'b1),.D({currentAdrs, inst}),
    .Q({IF_ID_PC,IF_ID_Inst}) );
    
    
    rv32_ImmGen ig(IF_ID_Inst,Immead);
    Register_File rf(writedata, inst[11:7], IF_ID_Inst[19:15], IF_ID_Inst[24:20],regwrite, clk, reset, readdata1, readdata2);
    Control_Unit cu(IF_ID_Inst[6:2], Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC, syst);
    
    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire [12:0] ID_EX_Ctrl;
    wire [4:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    register #(155) ID_EX (.clk(clk),.reset(reset),.load(1'b1),.D({Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC, syst, IF_ID_PC, readdata1, readdata2,
    Immead, IF_ID_Inst[14:12], IF_ID_Inst[30], IF_ID_Inst[5], IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7] }),
    .Q( {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd}) );
    
    
    multiplexer #(32) m1(readdata2, Immead, ALUSrc, ALUIn2);
    prv32_ALU a(.a(ID_EX_RegR1), .b(ALUIn2), .shamt(ALUIn2[4:0]), .r(ALUResult), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUSel));
    ALU_Control AC(ALUOp, ID_EX_Func[4:2] , ID_EX_Func[1], ID_EX_Func[0], ALUSel);
    StoreLoadControl slc(.fun3(ID_EX_Func[4:2]), .whb(whb), .bsigned(bsigned), .hsigned(hsigned));
    RCA #(32) addBranch(ID_EX_PC, ID_EX_Imm, 1'b0, addOutB);

    
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [4:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire EX_MEM_Zero;
    register #(107) EX_MEM (.clk(clk),.reset(reset),.load(1'b1),.D({ID_EX_Ctrl[7:5], ID_EX_Ctrl[2], ID_EX_Ctrl[0], addOutB, zerof, ALUResult,ID_EX_RegR2, ID_EX_Rd }),
    .Q({EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd}) );
    
    
    assign selMux8 = bsigned & MemDataOut[7];
    assign selMux9 = hsigned & MemDataOut[15];
    
    DataMem dm(clk,  MemRead,  MemWrite, whb, ALUResult[7:0] , readdata2, MemDataOut);
    multiplexer #(32) m8(MemDataOut, {24'hFFFFFF,MemDataOut[7:0]}, selMux8, wm8);                       // choosing dataFromMem           
    multiplexer #(32) m9(wm8, {16'hFFFF,MemDataOut[15:0]}, selMux9, dataFromMem);                       // choosing dataFromMem               
    BranchUnit bu(.funct3(inst[`IR_funct3]), .Z(zf),.C(cf),.V(vf),.S(sf),.branch_taken(branch_taken) );
    assign selMux2 = (branch_taken & Branch) | writePC;

    
    
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [1:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;
    register #(71) MEM_WB (.clk(clk),.reset(reset),.load(1'b1),.D({EX_MEM_Ctrl[2], EX_MEM_Ctrl[0], MemDataOut, EX_MEM_ALU_out, EX_MEM_Rd }),
    .Q({MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd}) );

    
    assign selMux6 = writePC | auipc;

    multiplexer #(32) m3(addOut4, addOutB, auipc, wm3);             // choosing write data
    multiplexer #(32) m5(ALUResult, Immead, lui, wm5);              // choosing write data
    multiplexer #(32) m6(wm5, wm3, selMux6, wm6);                   // choosing write data
    multiplexer #(32) m7(wm6, dataFromMem, MemToReg, writedata);    // choosing write data    

    
endmodule
