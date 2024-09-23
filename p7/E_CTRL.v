`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:40:09 11/20/2022 
// Design Name:
// Module Name:    E_CTRL 
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
module E_CTRL(
    input [5:0] E_op,
    input [5:0] E_fuc,
    input [4:0] E_GRF_A1,
    input [4:0] E_GRF_A2,
    input [5:0] M_op,
    input [5:0] W_op,
    output [3:0] E_ALU_op,
    output [2:0] E_ALU_MUX_A1,
    output [2:0] E_ALU_MUX_A2,
    output [2:0] E_ALU_MUX_S,
    output [1:0] E_Tnew,
    output [3:0] HILO_op,
    output E_ALU_MUX_ans,
    output start,
    input ALU_Ov_op,
    output E_error_AdEL,
    output E_error_AdES,
    input [4:0] E_rs,
    output E_error_Ov
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
    assign eret = (E_op == 6'b010000) & (E_fuc == 6'b011000);
    assign mfc0 = (E_op == 6'b010000) & (E_rs == 5'b00000);
    assign mtc0 = (E_op == 6'b010000) & (E_rs == 5'b00100);
    assign syscall = (E_op == 6'b000000) & (E_fuc == 6'b001100);
    assign fuc_op = (E_op == 6'b000000);
    assign add = fuc_op & (E_fuc == 6'b100000);
    assign sub = fuc_op & (E_fuc == 6'b100010);
    assign ori = (E_op == 6'b001101);
    assign lw = (E_op == 6'b100011);
    assign sw = (E_op == 6'b101011);
    assign beq = (E_op == 6'b000100);
    assign lui = (E_op == 6'b001111);
    assign jal = (E_op == 6'b000011);
    assign jr = fuc_op & (E_fuc == 6'b001000);
    assign bne = (E_op == 6'b000101);
    assign or_op = fuc_op & (E_fuc == 6'b100101);
    assign and_op = fuc_op & (E_fuc == 6'b100100);
    assign slt = fuc_op & (E_fuc == 6'b101010);
    assign sltu = fuc_op & (E_fuc == 6'b101011);
    assign addi = (E_op == 6'b001000);
    assign andi = (E_op == 6'b001100);
    assign mult = fuc_op & (E_fuc == 6'b011000);
    assign multu = fuc_op & (E_fuc == 6'b011001);
    assign div = fuc_op & (E_fuc == 6'b011010);
    assign divu = fuc_op & (E_fuc == 6'b011011);
    assign mfhi = fuc_op & (E_fuc == 6'b010000);
    assign mflo = fuc_op & (E_fuc == 6'b010010);
    assign mthi = fuc_op & (E_fuc == 6'b010001);
    assign mtlo = fuc_op & (E_fuc == 6'b010011);
    assign lb = (E_op == 6'b100000);
    assign lh = (E_op == 6'b100001);
    assign sb = (E_op == 6'b101000);
    assign sh = (E_op == 6'b101001);
    assign E_ALU_MUX_A2[0] = ori | lw | sw | lui | sb | lb | sh | lh | addi | andi;
    assign E_ALU_op[0] = sub | and_op | andi | slt;
    assign E_ALU_op[1] = ori | and_op | or_op | andi;
    assign E_ALU_op[2] = sltu | slt;
	assign E_ALU_op[3] = 1'b0;
    assign E_ALU_MUX_A1 =3'b000;
    assign E_ALU_MUX_S = 3'b000;
    assign E_ALU_MUX_A2[2:1] = 2'b00;
    assign E_Tnew = (mult | multu | div | divu | mthi | mtlo) ? 2'b00 :
                    (lw | lb | lh | mfc0) ? 2'b10 :
                    ((fuc_op &(E_fuc != 6'b000000)) | ori | lui | addi | andi) ? 2'b01 :2'b00;
    assign E_ALU_MUX_ans = mfhi | mflo;
	assign HILO_op[0] = mflo | mtlo | divu | div;
    assign HILO_op[1] = mthi | mtlo | mult | div;
    assign HILO_op[2] = mult | multu | div | divu;
    assign HILO_op[3] = 1'b0;
	assign start =  divu | div | mult | multu ;
    assign E_error_AdEL = (ALU_Ov_op && (lb || lw || lh)) ? 1'b1 : 1'b0;
    assign E_error_AdES = (ALU_Ov_op && (sb || sw || sh)) ? 1'b1 : 1'b0;
    assign E_error_Ov = (ALU_Ov_op && (add || addi || sub)) ? 1'b1 : 1'b0;
endmodule

