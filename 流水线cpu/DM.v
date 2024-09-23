`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:01 10/30/2022 
// Design Name: 
// Module Name:    DM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DM(
    input [31:0] address,
    input [31:0] in,
    output reg [31:0] out,
    input DM_write,
    input clk,
    input reset,
    input [31:0] PC,
    input [1:0] M_DM_op
    );
    reg [31:0] data [3071:0];
    integer i;
    initial begin
        for(i=0;i<3072;i = i + 1)
        begin
            data[i] <= 32'h0000_0000;
        end
        out <= 32'h0000_0000;
    end
    always@(posedge clk)
    begin
        if(reset == 1'b1)
        begin
            for(i=0;i<3072;i = i + 1)
            begin
                data[i] <= 32'h0000_0000;
            end
        end
        else
        begin
            if(DM_write == 1'b1)
            begin
                $display("%d@%h: *%h <= %h",$time, PC, address, in);
                data[address[13:2]] <= in;
            end
        end
    end
always @(*) begin
    out = data[address[13:2]];
end
endmodule




