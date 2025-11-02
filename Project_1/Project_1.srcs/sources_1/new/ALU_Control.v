`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:39:43 PM
// Design Name: 
// Module Name: ALU_Control
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


module ALU_Control(
input [1:0] ALUOp,
input [14:12] Inst,
input Inst30,
output reg[3:0] ALUSel
    );
    
    always @* begin
    case(ALUOp)
    2'b00: ALUSel=4'b0010;
    2'b01: ALUSel=4'b0110;
    2'b10: begin
    case(Inst)
    3'b000: begin
        if(Inst30)
        ALUSel=4'b0110;
        else
        ALUSel=4'b0010;
    end
    3'b111: ALUSel=4'b111;
    3'b110: ALUSel=4'b0001;
    endcase
    end 
    default: ALUSel=4'b0000;
    endcase 
    
    
    end
    
endmodule
