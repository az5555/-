`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:05 11/20/2022 
// Design Name: 
// Module Name:    D_REG 
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
module D_REG(
    input [31:0] F_PC,
    output reg [31:0] D_PC,
    input clk,
    input reset,
    input [5:0] F_op,
    input [5:0] F_fuc,
    input [4:0] F_rs,
    input [4:0] F_rt,
    input [4:0] F_rd,
    input [15:0] F_imm_16,
    input [25:0] F_imm_26,
    input [4:0] F_shamt,
    output reg [5:0] D_op,
    output reg [5:0] D_fuc,
    output reg [4:0] D_rs,
    output reg [4:0] D_rt,
    output reg [4:0] D_rd,
    output reg [15:0] D_imm_16,
    output reg [25:0] D_imm_26,
    output reg [4:0] D_shamt,
    input en
    );
initial
begin
    D_op <= 0;
    D_fuc <= 0;
    D_imm_16 <= 0;
    D_imm_26 <= 0;
    D_PC <= 0;
    D_rs <= 0;
    D_rt <= 0;
    D_shamt <= 0;
    D_rd <= 0;
end
always @(posedge clk) begin
    if(reset == 1'b1) begin
        D_op <= 0;
        D_fuc <= 0;
        D_imm_16 <= 0;
        D_imm_26 <= 0;
        D_PC <= 0;
        D_rs <= 0;
        D_rt <= 0;
        D_shamt <= 0;
        D_rd <= 0;
    end
    else
    begin
        if(en == 1'b0) begin
        D_op <= F_op;
        D_fuc <= F_fuc;
        D_imm_16 <= F_imm_16;
        D_imm_26 <= F_imm_26;
        D_PC <= F_PC;
        D_rd <= F_rd;
        D_rs <= F_rs;
        D_rt <= F_rt;
        D_shamt <= F_shamt;
        end
    end
end
endmodule
