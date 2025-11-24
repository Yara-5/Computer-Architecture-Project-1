`timescale 1ns / 1ps
`include "defines.v"
///*******************************************************************
//*
//* Module: Processor.v
//* Project: Project_1
//* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
//            Ahmed Bamhdaf       - 
//* Description: Top module that implements all the processor's functionalities
//*
//* Change history:   10/21/25    - Initial Implementation
//*                   11/5/25     - Whole ALU added
//                    11/9/25     - lui, jal, jalr, auipc, lbu, lhu instructions added
//                    11/16/25    - adjusting ALU_Control inputs
//                    11/18/25    - adding pipeline registers
//                    11/20/25    - adding forwarding and single memory implementation
//                    11/22/25    - implemented stalling for both load use and structural hazards
//                    11/23/25    - implemented flushing in case of branching and jumping
//*
//**********************************************************************/

module Processor(
input clk, reset
    );
    
    wire [31:0] currentAdrs, futAdrs, SMem_address;
    wire [31:0] inst, readdata1, readdata2;
    wire [31:0] writedata, dataMemAdrs, memDataIn, MemDataOut, Immead, dataFromMem, writeResult;
    wire regwrite, MemRead, MemWrite, bsigned, hsigned;
    wire cf, zf, vf, sf, branch_taken;
    wire [31:0] ALUIn1, ALUIn2, ALUResult, realEXReg2;
    wire [3:0]ALUSel;
    wire Branch, MemToReg, ALUSrc, selMux2, selMux6, selMux8, selMux9, selMux10, syst;
    wire [1:0] ALUOp, whb, SMem_whb, forwardA, forwardB;
    wire [31:0] addOut4, addOutB;
    wire auipc, lui, jalr, writePC, stall;
    wire [31:0] wm2, wm3, wm4, wm5, wm8, wm11, wm13, wm18, wm19;
    wire [9:0] nextMEMcontrols;
    wire [33:0] prevWritedata;
    wire [12:0] nextEXcontrols;

  
  
    
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Imm, EX_MEM_addOut4;
    wire [9:0] EX_MEM_Ctrl;
    wire [4:0] MEM_WB_Rd;
    wire [4:0] EX_MEM_Rd;
    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_addOut4;
  

  
    assign selMux10 = (syst & ~selMux2) | EX_MEM_Ctrl[2];
   
    RCA #(32) add4(currentAdrs, 32'd4, 1'b0, addOut4);
    multiplexer #(32) m2(addOut4, EX_MEM_BranchAddOut, selMux2, wm2);          // choosing future address
    multiplexer #(32) m4(IF_ID_PC, EX_MEM_ALU_out, EX_MEM_Ctrl[2], wm4);      // choosing future address
    multiplexer #(32) m10(wm2, wm4, selMux10, futAdrs);                        // choosing future address 
    register #(32) PC( .D(futAdrs), .load(~stall) , .clk(clk), .reset(reset), .Q(currentAdrs) );

    SingleMemory sm(.clk(clk), .MemRead(~EX_MEM_Ctrl[6]), .MemWrite(EX_MEM_Ctrl[6]), .whb(SMem_whb), .addr(SMem_address[7:0]), .data_in(EX_MEM_RegR2), .data_out(MemDataOut));
    multiplexer #(2) m15(2'b10, EX_MEM_StoLoaCtrl[3:2], stall, SMem_whb);
    multiplexer #(32) m16(currentAdrs, EX_MEM_ALU_out, stall, SMem_address);
    multiplexer #(32) m20(MemDataOut, 32'b00000000000000000000000000110011, stall | selMux2 | syst, inst);     // nop in case of stall or branch


    assign stall = EX_MEM_Ctrl[8] | EX_MEM_Ctrl[6];

   
//    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_addOut4;          // This line was moved up to support older models of vivado
    register #(96) IF_ID (.clk(clk),.reset(reset),.load(~stall),.D({currentAdrs, inst, addOut4}),
    .Q({IF_ID_PC,IF_ID_Inst, IF_ID_addOut4}) );
    
    
    rv32_ImmGen ig(IF_ID_Inst,Immead);
    Register_File rf(writedata, MEM_WB_Rd, IF_ID_Inst[19:15], IF_ID_Inst[24:20],MEM_WB_Ctrl[0], clk, reset, readdata1, readdata2);
    Control_Unit cu(IF_ID_Inst[6:1], Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC, syst);
    multiplexer #(13) m21 ({Branch,MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, regwrite, auipc, lui, jalr, writePC, syst}, 13'b0000000000000, selMux2, nextEXcontrols);    // flush in case of branch
    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_addOut4;
    wire [12:0] ID_EX_Ctrl;
    wire [4:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    register #(193) ID_EX (.clk(clk),.reset(reset),.load(~stall),
    .D({nextEXcontrols, IF_ID_PC, readdata1, readdata2,Immead, IF_ID_Inst[14:12], IF_ID_Inst[30],
     IF_ID_Inst[5], IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7], IF_ID_addOut4 }),
    .Q( {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_addOut4}) );
    
    
    ForwardingUnit fu(ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Ctrl[5], MEM_WB_Ctrl[0], forwardA, forwardB);
    multiplexer #(32) m18(ID_EX_RegR1, prevWritedata[31:0], prevWritedata[33], wm18);   // in case of stall
    multiplexer #(32) m11(writeResult, writedata, forwardA[0], wm11);               // choosing ALU source 1
    multiplexer #(32) m12(wm18, wm11, forwardA[1] | forwardA[0], ALUIn1);           // choosing ALU source 1
    multiplexer #(32) m19(ID_EX_RegR2, prevWritedata[31:0], prevWritedata[32], wm19);       // in case of stall
    multiplexer #(32) m13(writeResult, writedata, forwardB[0], wm13);           // choosing ALU source 2
    multiplexer #(32) m14(wm19, wm13, forwardB[1] | forwardB[0], realEXReg2);   // choosing ALU source 2
    multiplexer #(32) m1(realEXReg2, ID_EX_Imm, ID_EX_Ctrl[6], ALUIn2);         // choosing ALU source 2
    prv32_ALU a(.a(ALUIn1), .b(ALUIn2), .shamt(ALUIn2[4:0]), .r(ALUResult), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUSel));
    ALU_Control AC(ID_EX_Ctrl[9:8], ID_EX_Func[4:2] , ID_EX_Func[1], ID_EX_Func[0], ALUSel);
    StoreLoadControl slc(.fun3(ID_EX_Func[4:2]), .whb(whb), .bsigned(bsigned), .hsigned(hsigned));
    RCA #(32) addBranch(ID_EX_PC, ID_EX_Imm, 1'b0, addOutB);
    multiplexer #(10) m17 ({ID_EX_Ctrl[12:10], ID_EX_Ctrl[7], ID_EX_Ctrl[5:0]}, 10'b0000000000, stall | selMux2, nextMEMcontrols); // flush in case of stall or branch

    register #(34) stall_frwd(.clk(clk), .reset(reset), .load(1'b1), 
    .D({forwardA[0] & stall, forwardB[0] & stall, writedata}), .Q(prevWritedata));


    
//    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Imm, EX_MEM_addOut4;
//    wire [9:0] EX_MEM_Ctrl;          // These line was moved up to support older models of vivado
//    wire [4:0] EX_MEM_Rd;
    wire [3:0] EX_MEM_Flags, EX_MEM_StoLoaCtrl;
    wire [2:0] EX_MEM_Func3;
    register #(186) EX_MEM (.clk(clk),.reset(reset),.load(1'b1),
    .D({nextMEMcontrols, whb, bsigned, hsigned, addOutB, cf, zf, vf, sf, ALUResult,realEXReg2, ID_EX_Rd, ID_EX_Func[4:2], ID_EX_Imm, ID_EX_addOut4}),
    .Q({EX_MEM_Ctrl, EX_MEM_StoLoaCtrl, EX_MEM_BranchAddOut, EX_MEM_Flags, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_Func3, EX_MEM_Imm, EX_MEM_addOut4}) );
    
    
    assign selMux8 = EX_MEM_StoLoaCtrl[1] & MemDataOut[7];
    assign selMux9 = EX_MEM_StoLoaCtrl[0] & MemDataOut[15];
    
    multiplexer #(32) m8(MemDataOut, {24'hFFFFFF,MemDataOut[7:0]}, selMux8, wm8);                       // choosing dataFromMem           
    multiplexer #(32) m9(wm8, {16'hFFFF,MemDataOut[15:0]}, selMux9, dataFromMem);                       // choosing dataFromMem               
    BranchUnit bu(.funct3(EX_MEM_Func3), .Z(EX_MEM_Flags[2]),.C(EX_MEM_Flags[3]),.V(EX_MEM_Flags[1]),.S(EX_MEM_Flags[0]),.branch_taken(branch_taken) );
    assign selMux2 = (branch_taken & EX_MEM_Ctrl[9]) | EX_MEM_Ctrl[1];

    assign selMux6 = EX_MEM_Ctrl[1] | EX_MEM_Ctrl[4];

    multiplexer #(32) m3(EX_MEM_addOut4, EX_MEM_BranchAddOut, EX_MEM_Ctrl[4], wm3);         // choosing write data
    multiplexer #(32) m5(EX_MEM_ALU_out, EX_MEM_Imm, EX_MEM_Ctrl[3], wm5);                  // choosing write data
    multiplexer #(32) m6(wm5, wm3, selMux6, writeResult);                                           // choosing write data    
    
    
    wire [31:0] MEM_WB_Mem_out, MEM_WB_Result;
    wire [1:0] MEM_WB_Ctrl;
//    wire [4:0] MEM_WB_Rd;          // This line was moved up to support older models of vivado
    register #(103) MEM_WB (.clk(clk),.reset(reset),.load(1'b1),
    .D({EX_MEM_Ctrl[7], EX_MEM_Ctrl[5], dataFromMem, writeResult, EX_MEM_Rd }),
    .Q({MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_Result, MEM_WB_Rd}) );

    
    multiplexer #(32) m7(MEM_WB_Result, MEM_WB_Mem_out, MEM_WB_Ctrl[1], writedata);                   // choosing write data    

    
endmodule