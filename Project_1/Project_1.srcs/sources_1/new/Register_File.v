`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:38:31 PM
// Design Name: 
// Module Name: Register_File
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

    always @(posedge clk or posedge reset) begin
        if (reset==1'b1) begin
            for(i=0;i<32;i=i+1)
                regfile[i]=0;
   end         
        else if (regwrite==1'b1 && writereg!=4'b0000)         
      regfile[writereg] = writedata ;
       
  
    
    end
    
endmodule



