`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:08:14 11/20/2022 
// Design Name: 
// Module Name:    M_REG 
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
module M_REG(
    input clk,
    input reset,
    input [4:0] E_GRF_A2,
    input [31:0] E_GRF_RD2,
    input [4:0] E_GRF_A3,
    input [31:0] E_ALU_ans,
    input E_CMP_op,
    output reg [4:0] M_GRF_A2,
    output reg [31:0] M_GRF_RD2,
    output reg [4:0] M_GRF_A3,
    output reg [31:0] M_ALU_ans,
    output reg M_CMP_op,
    input [31:0] E_PC,
    input [5:0] E_op,
    input [5:0] E_fuc,
    input [4:0] E_rs,
    input [4:0] E_rt,
    input [4:0] E_rd,
    input [25:0] E_imm_26,
    input [4:0] E_shamt,
    output reg [31:0] M_PC,
    output reg [5:0] M_op,
    output reg [5:0] M_fuc,
    output reg [4:0] M_rs,
    output reg [4:0] M_rt,
    output reg [4:0] M_rd,
    output reg [25:0] M_imm_26,
    output reg [4:0] M_shamt
    );
initial begin
    M_op <= 0;
    M_fuc <= 0;
    M_imm_26 <= 0;
    M_PC <= 0;
    M_rs <= 0;
    M_rt <= 0;
    M_shamt <= 0;
    M_rd <= 0;
    M_GRF_A2 <= 0;
    M_GRF_A3 <= 0;
    M_ALU_ans <= 0;
    M_GRF_RD2 <= 0;
    M_CMP_op <= 0;
end
always @(posedge clk) begin
    if(reset == 1'b1) begin
        M_op <= 0;
        M_fuc <= 0;
        M_imm_26 <= 0;
        M_PC <= 0;
        M_rs <= 0;
        M_rt <= 0;
        M_shamt <= 0;
        M_rd <= 0;
        M_GRF_A2 <= 0;
        M_GRF_A3 <= 0;
        M_ALU_ans <= 0;
        M_GRF_RD2 <= 0;
        M_CMP_op <= 0;
    end
    else begin
        M_op <= E_op;
        M_fuc <= E_fuc;
        M_imm_26 <= E_imm_26;
        M_PC <= E_PC;
        M_rs <= E_rs;
        M_rt <= E_rt;
        M_shamt <= E_shamt;
        M_rd <= E_rd;
        M_GRF_A2 <= E_GRF_A2;
        M_GRF_A3 <= E_GRF_A3;
        M_ALU_ans <= E_ALU_ans;
        M_GRF_RD2 <= E_GRF_RD2;
        M_CMP_op <= E_CMP_op;
    end
end
endmodule
