`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Processor_Simulator.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Simulator to run the processor with the program in InstMem
*
* Change history:   10/21/25    - Initial Implementation
*
**********************************************************************/


module Processor_Simulator();
    
    reg clk;
    reg reset;

    Processor scp(clk, reset);
    
    localparam clk_per=10;
    initial begin
        clk=1'b0;
        forever #(clk_per/2) clk=~clk;
    end
    
    initial begin 
        reset =1'b1;
        #(clk_per)
        reset = 1'b0;
    end

endmodule
