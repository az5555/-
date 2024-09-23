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
    input [4:0] W_rs,
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
    wire bne;
    wire or_op;
    wire and_op;
    wire slt;
    wire sltu;
    wire addi;
    wire andi;
    wire mult;
    wire multu;
    wire div;
    wire divu;
    wire mfhi;
    wire mflo;
    wire mthi;
    wire mtlo;
    wire lb;
    wire lh;
    wire sb;
    wire sh;
    wire fuc_op;
    wire eret;
    wire syscall;
    wire mfc0;
    wire mtc0;
    assign eret = (W_op == 6'b010000) & (W_fuc == 6'b011000);
    assign mfc0 = (W_op == 6'b010000) & (W_rs == 5'b00000);
    assign mtc0 = (W_op == 6'b010000) & (W_rs == 5'b00100);
    assign syscall = (W_op == 6'b000000) & (W_fuc == 6'b001100);
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
    assign bne = (W_op == 6'b000101);
    assign or_op = fuc_op & (W_fuc == 6'b100101);
    assign and_op = fuc_op & (W_fuc == 6'b100100);
    assign slt = fuc_op & (W_fuc == 6'b101010);
    assign sltu = fuc_op & (W_fuc == 6'b101011);
    assign addi = (W_op == 6'b001000);
    assign andi = (W_op == 6'b001100);
    assign mult = fuc_op & (W_fuc == 6'b011000);
    assign multu = fuc_op & (W_fuc == 6'b011001);
    assign div = fuc_op & (W_fuc == 6'b011010);
    assign divu = fuc_op & (W_fuc == 6'b011011);
    assign mfhi = fuc_op & (W_fuc == 6'b010000);
    assign mflo = fuc_op & (W_fuc == 6'b010010);
    assign mthi = fuc_op & (W_fuc == 6'b010001);
    assign mtlo = fuc_op & (W_fuc == 6'b010011);
    assign lb = (W_op == 6'b100000);
    assign lh = (W_op == 6'b100001);
    assign sb = (W_op == 6'b101000);
    assign sh = (W_op == 6'b101001);
    assign W_WE_op = fuc_op | lw | lui | jal | ori | andi | addi | lh | lb | mfhi | mflo | mfc0;
    assign W_grf_WE_mux_op[0] = lw | lb | lh | mfc0;
    assign W_grf_WE_mux_op[1] = jal | mfc0;
    assign W_Tnew = 3'b000;
    assign W_for_mux_op[0] = lw | lb | lh | mfc0;
    assign W_for_mux_op[1] = jal | mfc0;
    assign W_for_mux_op[2] = 1'b0;
endmodule
