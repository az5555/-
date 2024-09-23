`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:19 10/30/2022 
// Design Name: 
// Module Name:    ALU 
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
`define add 4'b0000
`define sub 4'b0001
`define ori 4'b0010
module ALU(
    input [31:0] A1,
    input [31:0] A2,
    output reg [31:0] ans,
    input [3:0] ALU_op
    );
initial begin
ans <= 32'h0000_0000;
end
always @(*) begin
    case(ALU_op)
    `add:
    begin
        ans = A1 + A2;
    end
    `sub:
    begin
        ans = A1 - A2;
    end
    `ori:
    begin
        ans = A1 | A2;
    end
    4'b0011:
    begin
        ans = A1 & A2;
    end
    4'b0100:
    begin
        ans = (A1 < A2) ? 32'h0000_0001 : 32'h0000_0000;
    end
    4'b0101:
    begin
        ans = ($signed(A1) < $signed(A2)) ? 32'h0000_0001 : 32'h0000_0000;
    end
    endcase
end
endmodule

