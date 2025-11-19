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
    wire Branch, MemToReg, ALUSrc, selMux2, selMux6, selMux8, selMux9, selMux10, syst;
    wire [1:0] ALUOp, whb;
    wire [31:0] addOut4, addOutB;
    wire auipc, lui, jalr, writePC;
    wire [31:0]wm2, wm3, wm4, wm5, wm6, wm8;
    
  
  
    
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Imm, EX_MEM_addOut4;
    wire [9:0] EX_MEM_Ctrl;
    wire [4:0] MEM_WB_Rd;
  
  
  
  
    assign selMux10 = EX_MEM_Ctrl[0] | EX_MEM_Ctrl[2];
   
    RCA #(32) add4(currentAdrs, 32'd4, 1'b0, addOut4);
    multiplexer #(32) m2(addOut4, EX_MEM_BranchAddOut, selMux2, wm2);       // choosing future address
    multiplexer #(32) m4(currentAdrs, ALUResult, EX_MEM_Ctrl[2], wm4);      // choosing future address
    multiplexer #(32) m10(wm2, wm4, selMux10, futAdrs);                     // choosing future address 
    register #(32) PC( .D(futAdrs), .load(1'b1) , .clk(clk), .reset(reset), .Q(currentAdrs) );
    InstMem im(currentAdrs[7:2], inst);
   
    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_addOut4;
    register #(96) IF_ID (.clk(clk),.reset(reset),.load(1'b1),.D({currentAdrs, inst, addOut4}),
    .Q({IF_ID_PC,IF_ID_Inst, IF_ID_addOut4}) );
    
    
    rv32_ImmGen ig(IF_ID_Inst,Immead);
    Register_File rf(writedata, MEM_WB_Rd, IF_ID_Inst[19:15], IF_ID_Inst[24:20],MEM_WB_Ctrl[3], clk, reset, readdata1, readdata2);
    Control_Unit cu(IF_ID_Inst[6:2], Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC, syst);
    
    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_addOut4;
    wire [12:0] ID_EX_Ctrl;
    wire [4:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    register #(193) ID_EX (.clk(clk),.reset(reset),.load(1'b1),
    .D({Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC, syst,
     IF_ID_PC, readdata1, readdata2,Immead, IF_ID_Inst[14:12], IF_ID_Inst[30], IF_ID_Inst[5],
      IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7], IF_ID_addOut4 }),
    .Q( {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_addOut4}) );
    
    
    multiplexer #(32) m1(ID_EX_RegR2, ID_EX_Imm, ID_EX_Ctrl[6], ALUIn2);
    prv32_ALU a(.a(ID_EX_RegR1), .b(ALUIn2), .shamt(ALUIn2[4:0]), .r(ALUResult), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUSel));
    ALU_Control AC(ID_EX_Ctrl[9:8], ID_EX_Func[4:2] , ID_EX_Func[1], ID_EX_Func[0], ALUSel);
    StoreLoadControl slc(.fun3(ID_EX_Func[4:2]), .whb(whb), .bsigned(bsigned), .hsigned(hsigned));
    RCA #(32) addBranch(ID_EX_PC, ID_EX_Imm, 1'b0, addOutB);

    
//    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Imm, EX_MEM_addOut4;
//    wire [9:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [3:0] EX_MEM_Flags, EX_MEM_StoLoaCtrl;
    wire [2:0] EX_MEM_Func3;
    register #(186) EX_MEM (.clk(clk),.reset(reset),.load(1'b1),
    .D({ID_EX_Ctrl[12:10], ID_EX_Ctrl[7], ID_EX_Ctrl[5:0],whb, bsigned, hsigned, addOutB, cf, zf, vf, sf, ALUResult,ID_EX_RegR2, ID_EX_Rd, ID_EX_Func[4:2], ID_EX_Imm, ID_EX_addOut4}),
    .Q({EX_MEM_Ctrl, EX_MEM_StoLoaCtrl, EX_MEM_BranchAddOut, EX_MEM_Flags, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_Func3, EX_MEM_Imm, EX_MEM_addOut4}) );
    
    
    assign selMux8 = EX_MEM_StoLoaCtrl[1] & MemDataOut[7];
    assign selMux9 = EX_MEM_StoLoaCtrl[0] & MemDataOut[15];
    
    DataMem dm(clk,  EX_MEM_Ctrl[8], EX_MEM_Ctrl[6], EX_MEM_StoLoaCtrl[3:2], EX_MEM_ALU_out[7:0] , EX_MEM_RegR2, MemDataOut);
    multiplexer #(32) m8(MemDataOut, {24'hFFFFFF,MemDataOut[7:0]}, selMux8, wm8);                       // choosing dataFromMem           
    multiplexer #(32) m9(wm8, {16'hFFFF,MemDataOut[15:0]}, selMux9, dataFromMem);                       // choosing dataFromMem               
    BranchUnit bu(.funct3(EX_MEM_Func3), .Z(EX_MEM_Flags[2]),.C(EX_MEM_Flags[3]),.V(EX_MEM_Flags[1]),.S(EX_MEM_Flags[0]),.branch_taken(branch_taken) );
    assign selMux2 = (branch_taken & EX_MEM_Ctrl[9]) | EX_MEM_Ctrl[1];

    
    
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Imm, MEM_WB_BranchAddOut, MEM_WB_addOut4;
    wire [6:0] MEM_WB_Ctrl;
//    wire [4:0] MEM_WB_Rd;
    register #(172) MEM_WB (.clk(clk),.reset(reset),.load(1'b1),
    .D({EX_MEM_Ctrl[7], EX_MEM_Ctrl[5:0], dataFromMem, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_Imm, EX_MEM_BranchAddOut, EX_MEM_addOut4 }),
    .Q({MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd, MEM_WB_Imm, MEM_WB_BranchAddOut, MEM_WB_addOut4}) );

    
    assign selMux6 = MEM_WB_Ctrl[0] | MEM_WB_Ctrl[2];

    multiplexer #(32) m3(MEM_WB_addOut4, MEM_WB_BranchAddOut, MEM_WB_Ctrl[2], wm3);         // choosing write data
    multiplexer #(32) m5(MEM_WB_ALU_out, MEM_WB_Imm, MEM_WB_Ctrl[1], wm5);                  // choosing write data
    multiplexer #(32) m6(wm5, wm3, selMux6, wm6);                                           // choosing write data
    multiplexer #(32) m7(wm6, MEM_WB_Mem_out, MEM_WB_Ctrl[6], writedata);                   // choosing write data    

    
endmodule
