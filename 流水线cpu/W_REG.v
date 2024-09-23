`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:33:58 11/20/2022 
// Design Name: 
// Module Name:    W_REG 
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
module W_REG(
    input clk,
    input reset,
    input [4:0] M_GRF_A3,
    input [31:0] M_ALU_ans,
    input [31:0] M_DM_out,
    input M_CMP_op,
    input [31:0] M_DM_WE,
    output reg [4:0] W_GRF_A3,
    output reg [31:0] W_ALU_ans,
    output reg [31:0] W_DM_out,
    output reg W_CMP_op,
    output reg [31:0] W_DM_WE,
    input [31:0] M_PC,
    input [5:0] M_op,
    input [5:0] M_fuc,
    input [4:0] M_rs,
    input [4:0] M_rt,
    input [4:0] M_rd,
    input [25:0] M_imm_26,
    input [4:0] M_shamt,
    output reg [31:0] W_PC,
    output reg [5:0] W_op,
    output reg [5:0] W_fuc,
    output reg [4:0] W_rs,
    output reg [4:0] W_rt,
    output reg [4:0] W_rd,
    output reg [25:0] W_imm_26,
    output reg [4:0] W_shamt
    );
initial begin
    W_GRF_A3 = 0;
    W_ALU_ans = 0;
    W_DM_out = 0;
    W_CMP_op = 0;
    W_DM_WE = 0;
    W_PC = 0;
    W_op = 0;
    W_fuc = 0;
    W_rs = 0;
    W_rd = 0;
    W_rt = 0;
    W_imm_26 = 0;
    W_shamt = 0;
end
always @(posedge clk) begin
    if(reset == 1'b1) begin
        W_GRF_A3 = 0;
        W_ALU_ans = 0;
        W_DM_out = 0;
        W_CMP_op = 0;
        W_DM_WE = 0;
        W_PC = 0;
        W_op = 0;
        W_fuc = 0;
        W_rs = 0;
        W_rd = 0;
        W_rt = 0;
        W_imm_26 = 0;
        W_shamt = 0;
    end
    else begin
        W_GRF_A3 = M_GRF_A3;
        W_ALU_ans = M_ALU_ans;
        W_DM_out = M_DM_out;
        W_CMP_op = M_CMP_op;
        W_DM_WE = M_DM_WE;
        W_PC = M_PC;
        W_op = M_op;
        W_fuc = M_fuc;
        W_rs = M_rs;
        W_rd = M_rd;
        W_rt = M_rt;
        W_imm_26 = M_imm_26;
        W_shamt = M_shamt;
    end
end
endmodule