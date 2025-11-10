`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 01:35:08 PM
// Design Name: 
// Module Name: BranchUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BranchUnit(
input  [2:0] funct3,
input Z,C,V,S,

output reg branch_taken 

    );
     
    always @( *) begin
        case (funct3)
         3'b000: branch_taken  =  Z;          // BEQ
          3'b001: branch_taken  = ~Z;          // BNE
          3'b100: branch_taken  =  (S ^ V);    // BLT  (S != V)
          3'b101: branch_taken = ~(S ^ V);    // BGE  (S == V)
          3'b110: branch_taken = ~C;          // BLTU (borrow -> take)
          3'b111: branch_taken =  C;          // BGEU (no borrow -> take)
          default: branch_taken = 1'b0;       // not a branch funct3
        endcase
      end
    
endmodule
