`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:37 11/06/2022 
// Design Name: 
// Module Name:    pc 
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
module PC(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out,
    input en,
    input req
    );
initial
	begin
	out <= 32'h0000_3000;
	end
always@(posedge clk)
    begin
    if(reset == 1'b1)
        begin
        out <= 32'h0000_3000;
        end
    else if(req == 1'b1)
        begin
        out <= 32'h0000_4180;
        end
    else
        begin
        if(en == 1'b0)  begin
            out <= in;
        end
        end
    end
endmodule