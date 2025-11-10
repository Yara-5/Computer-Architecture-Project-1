`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DataMem.v
* Project: Project_1
* Authors:  Yara Abdelkader     - yara2005@aucegypt.edu
            Ahmed Bamhdaf       - 
* Description: Memory that stores program data only (not instructions)
*
* Change history:   10/41/25    - Initial Implementation
                    11/9/25     - Memory made byte addressable and non-word aligned
*
**********************************************************************/


module DataMem
(input clk, input MemRead, input MemWrite, input [1:0]whb,
input [7:0] addr, input [31:0] data_in, output reg [31:0] data_out);
    reg [7:0] mem [0:255];
    initial begin
        {mem[3],mem[2],mem[1],mem[0]}=32'd16;
        {mem[7],mem[6],mem[5],mem[4]}=32'd4;
        {mem[11],mem[10],mem[9],mem[8]}=32'd25;
//        mem[24]=8'd4;
//        mem[28]=8'd1;
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