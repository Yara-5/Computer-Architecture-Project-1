`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Processor.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
* Description: Sets load/store related flags
*
* Change history:   11/19/25    - Initial Implementation
*
**********************************************************************/


module StoreLoadControl(
input [2:0]fun3,
output reg [1:0]whb,
output bsigned, hsigned
    );
    
    assign bsigned=(fun3==3'b000)?1:0;
    assign hsigned=(fun3==3'b001)?1:0;
    
    always @* begin
        case(fun3)
            3'b000: whb = 2'b00;
            3'b001: whb = 2'b01;
            3'b010: whb = 2'b10;
            3'b100: whb = 2'b00;
            3'b101: whb = 2'b01;
            default: whb = 2'b11;
        endcase
    end
        
endmodule
