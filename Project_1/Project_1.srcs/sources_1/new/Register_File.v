`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Processor.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Has the 32 registers the processor uses
*
* Change history:   10/7/25    - Initial Implementation
                    11/20/25    - writing at clock negative edge
                    11/20/25    - writing at clock negative edge
*
**********************************************************************///////////////////////////////////////////////////////////////////////////////////


module Register_File(
input [31:0] writedata,
input[4:0] writereg, readreg1, readreg2,
input regwrite,
input clk,
input reset,
output [31:0] readData1, readData2 
    );
    
    reg [31:0] regfile [31:0];
    integer i;

    assign readData1=regfile[readreg1];
    assign readData2=regfile[readreg2];

    always @(negedge clk or posedge reset) begin
        if (reset==1'b1) begin
            for(i=0;i<32;i=i+1)
                regfile[i]=0;
        end         
        else if (regwrite==1'b1 && writereg!=4'b0000)         
            regfile[writereg] = writedata ;
    
    end
    
endmodule



