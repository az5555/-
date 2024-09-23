`timescale 1ns / 1ps
`include "ALU.v"
`include "Controller.v"
`include "DM.v"
`include "EXT.v"
`include "GRF.v"
`include "IM.v"
`include "nPC.v"
`include "pc.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:48:06 10/29/2022 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
wire [31:0] next_pc;
wire [31:0] pc_address;
PC pc1(.in(next_pc),.out(pc_address),.reset(reset),.clk(clk));

wire [5:0] op;
wire [5:0] fuc;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [15:0] imm_16;
wire [25:0] imm_26;
wire [4:0] shamt;
IM im1(
.address(pc_address),
.op(op),
.fuc(fuc),
.rs(rs),
.rt(rt),
 .rd(rd),
 .imm_16(imm_16),
 .imm_26(imm_26),
 .shamt(shamt)
 );

wire [2:0] ALU_op;
wire DM_write;
wire DM_read;
wire j_op1;
wire [1:0] EXT_op;
wire [1:0] max_grf_address_op;
wire [1:0] max_grf_op;
wire max_alu_op;
wire [1:0] PC_op;
wire WE_op;
Controller Controller1(
.op(op),
.fuc(fuc),
.j_op1(j_op1),
.ALU_op(ALU_op),
.DM_read(DM_read),
.DM_write(DM_write),
.EXT_op(EXT_op),
.max_grf_address_op(max_grf_address_op),
.max_grf_op(max_grf_op),
.max_alu_op(max_alu_op),
.PC_op(PC_op),
.WE_op(WE_op)
);
assign j_op1 = ans[0];

wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] GRF_WE;
wire [4:0] A3;
wire [4:0] A2;
wire [4:0] A1;
GRF GRF1(
.clk(clk),
.reset(reset),
.WE_op(WE_op),
.A1(A1),
.A2(A2),
.A3(A3),
.WE(GRF_WE),
.RD1(RD1),
.RD2(RD2),
.PC(pc_address)
);
assign A1 = rs;
assign A2 = rt;
assign A3 = (max_grf_address_op == 2'b00) ? rd :
            (max_grf_address_op == 2'b01) ? rt :
            (max_grf_address_op == 2'b10) ? 5'b11111 : 5'b00000;
assign  GRF_WE = (max_grf_op == 2'b00) ? ans : 
                (max_grf_op == 2'b01) ? DM_out:
                (max_grf_op == 2'b10) ? pc_address+32'h0000_0004 : 32'h0000_0000;

nPC nPC1(
.pc(pc_address),
.npc(next_pc),
.imm_off(imm_16),
.imm_j(imm_26),
.jr(RD1),
.npc_op(PC_op)
);

wire [31:0] DM_address;
wire [31:0] DM_in;
wire [31:0] DM_out;
DM DM1(
.clk(clk),
.reset(reset),
.DM_read(DM_read),
.DM_write(DM_write),
.in(DM_in),
.out(DM_out),
.address(DM_address),
.PC(pc_address)
);
assign DM_address = ans;
assign DM_in = RD2;

wire [31:0] alu_A1;
wire [31:0] alu_A2;
wire [31:0] ans;

ALU ALU1(
.ALU_op(ALU_op),
.A1(alu_A1),
.A2(alu_A2),
.ans(ans)
);
assign alu_A1 = RD1;
assign alu_A2 = (max_alu_op == 1'b0) ? RD2 : EXT_out;

wire [15:0] EXT_in;
wire [31:0] EXT_out;
EXT EXT(
.in(EXT_in),
.out(EXT_out),
.EXT_op(EXT_op)
);
assign EXT_in = imm_16;

endmodule
