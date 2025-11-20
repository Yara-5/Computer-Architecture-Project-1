`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DataMem.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Memory that stores both program instructions and program data
*
* Change history:   11/20/25    - Initial Implementation
*
**********************************************************************/


module SingleMemory(
input clk, input MemRead, input MemWrite, input [1:0]whb,
input [7:0] addr, input [31:0] data_in, output reg [31:0] data_out);
    reg [7:0] mem [0:255];
    initial begin
        $readmemh("C:/Users/Yara2005/Computer-Architecture-Project-1/Test Cases/Testcase6.hex", mem);
    end

    always@* begin
        if (MemRead) begin
            case(whb)
                2'b00: data_out = {24'd0, mem[addr]};
                2'b01: data_out = {16'd0, mem[addr+1], mem[addr]};
                2'b10: data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
                default: data_out = 0;
            endcase
        end
        else
            data_out = 0;
    end
    
    always @(posedge clk) begin
        if(MemWrite) begin
            case(whb)
                2'b00: mem[addr] <= data_in[7:0];   // write byte
                2'b01: begin                        // write half word
                    mem[addr] <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                end
                2'b10: begin                        // write word
                    mem[addr] <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+3] <= data_in[31:24];
                end
            endcase
        end
    end
endmodule
