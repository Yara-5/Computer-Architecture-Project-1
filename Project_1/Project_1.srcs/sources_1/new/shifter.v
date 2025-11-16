`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Processor.v
* Project: Project_1
* Author: Yara Abdelkader   - yara2005@aucegypt.edu
* Description: Shifts a value by up to 32 bits from left or roght (logically or arithmetically)
*
* Change history:   11/5/25    - Initial Implementation
                    11/16/25   - matching to ALU_Control
*
**********************************************************************/


module shifter(
input [31:0] a,
    [4:0] shamt,
    [1:0] type,
output reg [31:0] r
    );
    
    always @* begin
        case(type)
            2'b00: r = a  << shamt;              // shift left logical
            2'b01: r = a >> shamt;              // shift right logical
            2'b10: r = $signed(a) >>> shamt;    // shift right arithmetic
            default: r = a;
        endcase        
    end
    
endmodule
