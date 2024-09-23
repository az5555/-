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
    input [3:0] ALU_op,
    output reg ALU_Ov_op
    );
reg [32:0] temp;
initial begin
ans <= 32'h0000_0000;
end
always @(*) begin
    case(ALU_op)
    `add:
    begin
        temp = {A1[31],A1} + {A2[31],A2};
        if(temp[31] != temp[32])
        begin
            ALU_Ov_op = 1'b1;
            ans = 32'h0000_0000;
        end
        else 
        begin
            ALU_Ov_op = 1'b0;
            ans = A1 + A2;
        end
    end
    `sub:
    begin
        temp = {A1[31],A1} - {A2[31],A2};
        if(temp[31] != temp[32])
        begin
            ALU_Ov_op = 1'b1;
            ans = 32'h0000_0000;
        end
        else 
        begin
            ALU_Ov_op = 1'b0;
            ans = A1 - A2;
    end
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

