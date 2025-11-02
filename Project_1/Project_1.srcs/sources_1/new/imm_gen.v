`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 06:44:15 PM
// Design Name: 
// Module Name: imm_gen
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


module ImmGen(
input [31:0] inst,
output reg [31:0] gen_out
    );
    
    wire [31:0] ext=(inst[31])? 32'hFFFFFFFF:32'b0;
    
    always@* begin
        if (inst[6]==1'b1)
            gen_out={ext[31:12],inst[31],inst[7],inst[30:25],inst[11:8]};
        else begin
        if (inst[5]==0)
            gen_out = {ext[31:12],inst[31:20]};
        else
            gen_out = {ext[31:13],inst[31:25],inst[11:7]};
        
        end 
    end
    
endmodule
