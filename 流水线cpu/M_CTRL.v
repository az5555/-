`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:39:21 11/20/2022 
// Design Name: 
// Module Name:    M_CTRL 
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
module M_CTRL(
    input [5:0] M_op,
    input [5:0] M_fuc,
    input [4:0] M_GRF_A2,
    input [5:0] W_op,
    output  M_DM_WE_op,
    output [1:0] M_DM_op,
    output [1:0] M_DM_address_mux_op,
    output [1:0] M_DM_WE_max_op,
    output [1:0] M_Tnew,
    output [2:0] M_for_mux_op
    );
    wire add;
    wire sub;
    wire ori;
    wire lw;
    wire sw;
    wire beq;
    wire lui;
    wire jal;
    wire jr;
    wire fuc_op;
        wire addei;
    assign addei = (M_op == 6'b110011);
    assign fuc_op = (M_op == 6'b000000);
    assign add = fuc_op & (M_fuc == 6'b100000);
    assign sub = fuc_op & (M_fuc == 6'b100010);
    assign ori = (M_op == 6'b001101);
    assign lw = (M_op == 6'b100011);
    assign sw = (M_op == 6'b101011);
    assign beq = (M_op == 6'b000100);
    assign lui = (M_op == 6'b001111);
    assign jal = (M_op == 6'b000011);
    assign jr = fuc_op & (M_fuc == 6'b001000);
    assign M_DM_WE_op = sw;
    assign M_DM_WE_max_op = 2'b00;
    assign M_DM_address_mux_op = 2'b00;
	 assign M_DM_op = 2'b00;
    assign M_Tnew = (lw) ? 2'b01 : 2'b00;
    assign M_DM_op =2'b00;
    assign M_for_mux_op[0] = lw;
    assign M_for_mux_op[1] = jal;
    assign M_for_mux_op[2] = 1'b0;
endmodule