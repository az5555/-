`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:03 11/20/2022 
// Design Name: 
// Module Name:    E_REG 
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
module E_REG(
    input clk,
    input reset,
    input [4:0] D_GRF_A1,
    input [4:0] D_GRF_A2,
    input [4:0] D_GRF_A3,
    input [31:0] D_GRF_RD1,
    input [31:0] D_GRF_RD2,
    input [31:0] D_EXT_imm,
    input D_CMP_op,
    output reg [4:0] E_GRF_A1,
    output reg [4:0] E_GRF_A2,
    output reg [4:0] E_GRF_A3,
    output reg [31:0] E_EXT_imm,
    output reg [31:0] E_GRF_RD1,
    output reg [31:0] E_GRF_RD2,
    output reg E_CMP_op,
    input [31:0] D_PC,
    input [5:0] D_op,
    input [5:0] D_fuc,
    input [4:0] D_rs,
    input [4:0] D_rt,
    input [4:0] D_rd,
    input [25:0] D_imm_26,
    input [4:0] D_shamt,
    output reg [31:0] E_PC,
    output reg [5:0] E_op,
    output reg [5:0] E_fuc,
    output reg [4:0] E_rs,
    output reg [4:0] E_rt,
    output reg [4:0] E_rd,
    output reg [25:0] E_imm_26,
    output reg [4:0] E_shamt,
    input [4:0] D_EXEcode,
    output reg [4:0] E_EXEcode,
    input D_delay_op,
    output reg E_delay_op,
    input req,
    input stall
    );
initial begin
    E_op <= 0;
    E_fuc <= 0;
    E_imm_26 <= 0;
    E_PC <= 0;
    E_rs <= 0;
    E_rt <= 0;
    E_shamt <= 0;
    E_rd <= 0;
    E_GRF_A1 <= 0;
    E_GRF_A2 <= 0;
    E_GRF_A3 <= 0;
    E_EXT_imm <= 0;
    E_GRF_RD1 <= 0;
    E_GRF_RD2 <= 0;
    E_CMP_op <= 0;
    E_EXEcode <= 0;
    E_delay_op <= 0;
end
always @(posedge clk) begin
    if(reset == 1'b1 || req == 1'b1 || stall == 1'b1) begin
        E_op <= 0;
        E_fuc <= 0;
        E_imm_26 <= 0;
        E_PC <= (req) ? 32'h0000_4180 : ((stall) ? D_PC : 32'h0000_0000);
        E_rs <= 0;
        E_rt <= 0;
        E_shamt <= 0;
        E_rd <= 0;
        E_GRF_A1 <= 0;
        E_GRF_A2 <= 0;
        E_GRF_A3 <= 0;
        E_EXT_imm <= 0;
        E_GRF_RD1 <= 0;
        E_GRF_RD2 <= 0;
        E_CMP_op <= 0;
        E_EXEcode <= 0;
        E_delay_op <= (stall) ? D_delay_op : 0;
    end
    else begin
        E_op <= D_op;
        E_fuc <= D_fuc;
        E_imm_26 <= D_imm_26;
        E_PC <= D_PC;
        E_rs <= D_rs;
        E_rt <= D_rt;
        E_shamt <= D_shamt;
        E_rd <= D_rd;
        E_GRF_A1 <= D_GRF_A1;
        E_GRF_A2 <= D_GRF_A2;
        E_GRF_A3 <= D_GRF_A3;
        E_EXT_imm <= D_EXT_imm;
        E_GRF_RD1 <= D_GRF_RD1;
        E_GRF_RD2 <= D_GRF_RD2;
        E_CMP_op <= D_CMP_op;
        E_EXEcode <= D_EXEcode;
        E_delay_op <= D_delay_op;
    end
end
endmodule