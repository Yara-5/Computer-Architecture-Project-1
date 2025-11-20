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
                    11/9/25     - Adding all instructions
                    11/16/25    - fixing addi
*
**********************************************************************/


module ALU_Control(
input [1:0] ALUOp,
input [14:12] Inst,
input Inst30, Inst5,
output reg[3:0] ALUSel
    );
    
    always @* begin
    case(ALUOp)
    2'b00: ALUSel=4'b00_00; 
    2'b01: ALUSel=4'b00_01;
    2'b10: begin
    case(Inst)
    3'b000: begin
        if(Inst30 & Inst5)
            ALUSel=4'b00_01; // sub
        else ALUSel=4'b0000; // add
        end
    3'b001: ALUSel = 4'b1000;  // SLL
    3'b101: ALUSel = (Inst30 ? 4'b1010 : 4'b1001); 
    3'b111: ALUSel=4'b0101;     // and 
    3'b110: ALUSel=4'b0100;  // OR
    3'b100: ALUSel = 4'b0111;       // XOR
    3'b010: ALUSel = 4'b1101;       // SLT
    3'b011: ALUSel = 4'b1111;       // SLTU
    default: ALUSel=4'b0000;
    endcase
    end 
    default: ALUSel=4'b0000;  // add
    endcase 
    
    
    end
    
endmodule