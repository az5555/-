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
module HILO(
    input [31:0] A1,
    input [31:0] A2,
    output [31:0] ans,
    input [3:0] HILO_op,
    input start,
    output reg busy,
	input clk,
	input reset,
    input req
    );
reg [31:0] HI;
reg [31:0] LO;
reg [63:0] prog;
reg [31:0] quo;
reg [31:0] rem;
reg [1:0] op;
integer i;
initial begin
HI <= 32'h0000_0000;
LO <= 32'h0000_0000;
busy <= 1'b0;
op <= 2'b00;
quo <= 32'h0000_0000;
rem <= 32'h0000_0000;
prog <= 64'h0000_0000_0000_0000;
i <= 0;
end
always @(posedge clk) begin
        if(reset == 1'b1)
            begin
                HI <= 32'h0000_0000;
                LO <= 32'h0000_0000;
                busy <= 1'b0;
                op <= 2'b00;
                quo <= 32'h0000_0000;
                rem <= 32'h0000_0000;
                prog <= 64'h0000_0000_0000_0000;
                i <= 0;
            end
			else begin
        if(busy == 1'b0 && HILO_op == 4'b0010)
            begin
                HI <= A1;
            end
        else if(busy == 1'b0 && HILO_op == 4'b0011)
            begin
                LO <= A1;
            end
        else if(busy == 1'b0 && HILO_op == 4'b0100 && !req)
            begin
                busy <= 1'b1;
                i <= 5;
                prog <= A1 * A2;
                op <= 2'b01;
            end
        else if(busy == 1'b0 && HILO_op == 4'b0101 && !req)
            begin
                busy <= 1'b1;
                i <= 10;
                quo <= A1 / A2;
                rem <= A1 % A2;
                op <= 2'b10;
            end
        else if(busy == 1'b0 && HILO_op == 4'b0110 && !req)
            begin
                busy <= 1'b1;
                i <= 5;
                prog <= $signed(A1) * $signed(A2);
                op <= 2'b01;
            end
        else if(busy == 1'b0 && HILO_op == 4'b0111 && !req)
            begin
                busy <= 1'b1;
                i <= 10;
                quo <= $signed(A1) / $signed(A2);
                rem <= $signed(A1) % $signed(A2);
                op <= 2'b10;
            end
        else if(busy == 1'b1)
            begin
                if(op == 2'b01 && i == 1)
                    begin
                        HI <= prog[63:32];
                        LO <= prog[31:0];
                        op <= 2'b00;
                        busy <= 1'b0;
                    end
                else if(op == 2'b10 && i == 1)
                    begin
                        HI <= rem;
                        LO <= quo;
                        op <= 2'b00;
                        busy <= 1'b0;
                    end
                i <= i - 1 ;
            end
		end
end
assign ans = (HILO_op == 4'b0000) ? HI :
            (HILO_op == 4'b0001) ? LO : 32'h0000_0000;
endmodule



