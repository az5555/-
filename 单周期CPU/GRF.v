`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:25 10/30/2022 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE_op,
    input [31:0] WE,
    input clk,
    input reset,
    output reg [31:0] RD1,
    output reg [31:0] RD2,
    input [31:0] PC
    );
    reg [31:0] an [31:0];
    integer i;
    initial begin
        for(i = 0;i < 32;i = i + 1)
        begin
            an[i] <= 32'h0000_0000;
        end
        RD1 <= 32'h0000_0000;
        RD2 <= 32'h0000_0000;
    end
  always @(posedge clk) begin
    if(reset == 1'b1)
    begin
        for(i = 0;i < 32;i = i + 1)
        begin
            an[i] <= 32'h0000_0000;
        end
    end
    else
    begin
        if(A3 != 5'b00000 && WE_op == 1'b1)
        begin
            $display("@%h: $%d <= %h",PC,A3,WE);
            an[A3] <= WE;
        end
    end
  end
always @(*) begin
    RD1 <= an[A1];
    RD2 <= an[A2];
end
endmodule

