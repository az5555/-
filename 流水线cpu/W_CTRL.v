`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:49:23 11/20/2022 
// Design Name: 
// Module Name:    W_CTRL 
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
module W_CTRL(
    input [5:0] W_op,
    input [5:0] W_fuc,
    output W_WE_op,
    output [1:0] W_grf_WE_mux_op,
    output [2:0] W_for_mux_op,
    output [1:0] W_Tnew
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
    assign addei = (W_op == 6'b110011);
    assign fuc_op = (W_op == 6'b000000);
    assign add = fuc_op & (W_fuc == 6'b100000);
    assign sub = fuc_op & (W_fuc == 6'b100010);
    assign ori = (W_op == 6'b001101);
    assign lw = (W_op == 6'b100011);
    assign sw = (W_op == 6'b101011);
    assign beq = (W_op == 6'b000100);
    assign lui = (W_op == 6'b001111);
    assign jal = (W_op == 6'b000011);
    assign jr = fuc_op & (W_fuc == 6'b001000);
    assign W_WE_op = add | sub | lw | lui | jal | ori | addei;
    assign W_grf_WE_mux_op[0] = lw;
    assign W_grf_WE_mux_op[1] = jal;
    assign W_Tnew = 3'b000;
    assign W_for_mux_op[0] = lw;
    assign W_for_mux_op[1] = jal;
    assign W_for_mux_op[2] = 1'b0;
endmodule
