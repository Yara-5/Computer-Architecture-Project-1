`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 04:37:30 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter N=32)(
input [N-1:0] A,B,
input [3:0] sel,
output reg [N-1:0] result,
output zerof
    );
     reg [N-1:0] second;
     reg c0;
    wire [N:0] addresult;
                RCA #(N) adder(A,second, c0, addresult);
assign zerof=~|result;
    always @* begin
        if (sel==4'b0000) result=A&B;
        else if (sel==4'b0001) result =A|B;
        else
            if (sel==4'b0110) begin
                second=~B;
                c0=1'b1;
                    result =addresult[N-1:0];
            end
            else if (sel==4'b0010) begin
                second= B;
                c0=1'b0;
            result =addresult[N-1:0];
            end
            else
            result = 0;
    end
    
endmodule
