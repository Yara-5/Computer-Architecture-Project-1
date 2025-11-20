`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DataMem.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Forwards values from memory and write back stages if they match the source registers in the execution stage 
*
* Change history:   11/18/25    - Initial Implementation
*
**********************************************************************/


module ForwardingUnit(
input [4:0] ID_EX_RegisterRs1, ID_EX_RegisterRs2, EX_MEM_RegisterRd, MEM_WB_RegisterRd,
input EX_MEM_RegWrite, MEM_WB_RegWrite,
output reg [1:0] forwardA, forwardB
    );
    
    always @*  begin
        forwardA = 2'b00;
        forwardB = 2'b00;
        if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd!=5'b0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs1) )
            forwardA = 2'b01;

        if (MEM_WB_RegWrite && (MEM_WB_RegisterRd!=5'b0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs2) )
            forwardB = 2'b01;
        
        if ( EX_MEM_RegWrite && (EX_MEM_RegisterRd != 5'b0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1) )
            forwardA = 2'b10;
            
        if (( EX_MEM_RegWrite && (EX_MEM_RegisterRd!= 5'b0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2) ))
            forwardB = 2'b10;
   end     
endmodule
