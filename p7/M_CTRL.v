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
    output [1:0] M_DM_op,
    output [1:0] M_DM_address_mux_op,
    output [1:0] M_DM_WE_max_op,
    output [1:0] M_Tnew,
    output [2:0] M_for_mux_op,
    output [2:0] M_OUT_op,
    input [4:0] M_rs,
    input [31:0] DM_address,
    output M_error_AdEL,
    output M_error_AdES,
    output CP0_WE_en,
    output EXLclr
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
    assign eret = (M_op == 6'b010000) & (M_fuc == 6'b011000);
    assign mfc0 = (M_op == 6'b010000) & (M_rs == 5'b00000);
    assign mtc0 = (M_op == 6'b010000) & (M_rs == 5'b00100);
    assign syscall = (M_op == 6'b000000) & (M_fuc == 6'b001100);
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
    assign bne = (M_op == 6'b000101);
    assign or_op = fuc_op & (M_fuc == 6'b100101);
    assign and_op = fuc_op & (M_fuc == 6'b100100);
    assign slt = fuc_op & (M_fuc == 6'b101010);
    assign sltu = fuc_op & (M_fuc == 6'b101011);
    assign addi = (M_op == 6'b001000);
    assign andi = (M_op == 6'b001100);
    assign mult = fuc_op & (M_fuc == 6'b011000);
    assign multu = fuc_op & (M_fuc == 6'b011001);
    assign div = fuc_op & (M_fuc == 6'b011010);
    assign divu = fuc_op & (M_fuc == 6'b011011);
    assign mfhi = fuc_op & (M_fuc == 6'b010000);
    assign mflo = fuc_op & (M_fuc == 6'b010010);
    assign mthi = fuc_op & (M_fuc == 6'b010001);
    assign mtlo = fuc_op & (M_fuc == 6'b010011);
    assign lb = (M_op == 6'b100000);
    assign lh = (M_op == 6'b100001);
    assign sb = (M_op == 6'b101000);
    assign sh = (M_op == 6'b101001);
    assign M_DM_WE_max_op = 2'b00;
    assign M_DM_address_mux_op = 2'b00;
    assign M_Tnew = (lw | lh | lb | mfc0) ? 2'b01 : 2'b00;
    assign M_for_mux_op[0] = lw;
    assign M_for_mux_op[1] = jal;
    assign M_for_mux_op[2] = 1'b0;
    assign M_DM_op[0] = sh | sw;
    assign M_DM_op[1] = sb | sw;
    assign M_OUT_op[1] = lb;
    assign M_OUT_op[2] = lh;
    assign M_OUT_op[0] = 1'b0;
    wire error_Timer;
    wire error_out_address;
    wire error_counter;
    assign error_Timer =  (DM_address >= 32'h0000_7f00 && DM_address <= 32'h0000_7f0b) || (DM_address >= 32'h0000_7f10 && DM_address <= 32'h0000_7f1b);
    assign error_out_address =!( ((DM_address >= 32'h0000_0000) && (DM_address <= 32'h0000_2FFF)) ||
                        ((DM_address >= 32'h0000_7F00) && (DM_address <= 32'h0000_7F0B)) ||
                        ((DM_address >= 32'h0000_7F10) && (DM_address <= 32'h0000_7F1B)) || 
                        ((DM_address >= 32'h0000_7F20) && (DM_address <= 32'h0000_7F23)) );
    assign error_counter = (DM_address == 32'h0000_7f08 || DM_address == 32'h0000_7f18);
    assign M_error_AdEL = (lw && (DM_address[1:0] != 2'b00)) ? 1'b1 :
                        (lh && (DM_address[0] != 1'b0)) ? 1'b1 :
                        (error_out_address && (lh || lb || lw) ) ? 1'b1 :
                        (error_Timer && (lh || lb) ) ? 1'b1 :  1'b0;
    assign M_error_AdES = (sw && (DM_address[1:0] != 2'b00)) ? 1'b1 :
                        (sw && error_counter) ? 1'b1 :
                        (sh && (DM_address[0] != 1'b0)) ? 1'b1 :
                        (error_out_address && (sh || sb || sw)) ? 1'b1 :
                        (error_Timer && (sh || sb) ) ? 1'b1 :  1'b0;
    assign EXLclr =eret;
    assign CP0_WE_en = mtc0;
endmodule