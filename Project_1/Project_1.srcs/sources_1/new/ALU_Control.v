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
        ALUSel=4'b0110; // sub
        else ALUSel=4'b0010; // add
        end
    3'b001: ALUSel = 4'b1000;  // SLL
    3'b101: ALUSel = (Inst30 ? 4'b1010 : 4'b1001); 
    3'b111: ALUSel=4'b0000;     // and 
    3'b110: ALUSel=4'b0001;  // OR
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