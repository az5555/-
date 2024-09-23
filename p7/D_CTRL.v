`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:44 11/20/2022 
// Design Name: 
// Module Name:    D_CTRL 
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
module D_CTRL(
    input [5:0] D_op,
    input [5:0] D_fuc,
    input j_op,
    input [4:0] D_GRF_A1,
    input [4:0] D_GRF_A2,
    input [5:0] E_op,
    input [5:0] M_op,
    output [1:0] D_EXT_op,
    output [2:0] D_NPC_op,
    output [2:0] D_GRF_A1_op,
    output [2:0] D_GRF_A2_op,
    output [2:0] D_GRF_A3_op,
    output [1:0] D_Tuse_GRF_A1,
    output [1:0] D_Tuse_GRF_A2,
    output [2:0] D_grf_address_mux_op,
    output start,
    output F_delay_op,
    output D_error_RI,
    input [4:0] D_rs,
    output D_error_syscall,
    output F_PC_op
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
    assign eret = (D_op == 6'b010000) & (D_fuc == 6'b011000);
    assign mfc0 = (D_op == 6'b010000) & (D_rs == 5'b00000);
    assign mtc0 = (D_op == 6'b010000) & (D_rs == 5'b00100);
    assign syscall = (D_op == 6'b000000) & (D_fuc == 6'b001100);
    assign fuc_op = (D_op == 6'b000000);
    assign add = fuc_op & (D_fuc == 6'b100000);
    assign sub = fuc_op & (D_fuc == 6'b100010);
    assign ori = (D_op == 6'b001101);
    assign lw = (D_op == 6'b100011);
    assign sw = (D_op == 6'b101011);
    assign beq = (D_op == 6'b000100);
    assign lui = (D_op == 6'b001111);
    assign jal = (D_op == 6'b000011);
    assign jr = fuc_op & (D_fuc == 6'b001000);
    assign bne = (D_op == 6'b000101);
    assign or_op = fuc_op & (D_fuc == 6'b100101);
    assign and_op = fuc_op & (D_fuc == 6'b100100);
    assign slt = fuc_op & (D_fuc == 6'b101010);
    assign sltu = fuc_op & (D_fuc == 6'b101011);
    assign addi = (D_op == 6'b001000);
    assign andi = (D_op == 6'b001100);
    assign mult = fuc_op & (D_fuc == 6'b011000);
    assign multu = fuc_op & (D_fuc == 6'b011001);
    assign div = fuc_op & (D_fuc == 6'b011010);
    assign divu = fuc_op & (D_fuc == 6'b011011);
    assign mfhi = fuc_op & (D_fuc == 6'b010000);
    assign mflo = fuc_op & (D_fuc == 6'b010010);
    assign mthi = fuc_op & (D_fuc == 6'b010001);
    assign mtlo = fuc_op & (D_fuc == 6'b010011);
    assign lb = (D_op == 6'b100000);
    assign lh = (D_op == 6'b100001);
    assign sb = (D_op == 6'b101000);
    assign sh = (D_op == 6'b101001);
    assign D_NPC_op[0] = jr | (beq & j_op) | (bne & !j_op);
    assign D_NPC_op[1] = jal | jr;
    assign D_NPC_op[2] = eret;
    assign D_EXT_op[1] = beq | lw | sw | bne | addi | lb | sb | lh | sh;
    assign D_EXT_op[0] = lui;
    assign D_GRF_A1_op = 2'b00;
    assign D_GRF_A2_op =2'b00;
    assign D_GRF_A3_op = 2'b00;
    assign D_Tuse_GRF_A1 =  (mfhi | mflo) ? 2'b11 :
                            (beq | jr | bne) ? 2'b00 :
                            (fuc_op | ori | sw | lui | lw | andi | addi | lb | sb | lh | sh) ? 2'b01 : 2'b11;
    assign D_Tuse_GRF_A2 =  (mfhi | mflo | mthi | mtlo) ? 2'b11 :
                            (beq | bne) ? 2'b00 :
                            (fuc_op) ? 2'b01 :
                            (sw | sb | sh | mtc0) ? 2'b10 : 2'b11;
    assign D_grf_address_mux_op[0] = ori  | lw | lui | andi | addi | lb | lh | mfc0;
    assign D_grf_address_mux_op[1] = jal;
	assign D_grf_address_mux_op[2] = sw | beq | bne | sb | sh | mtc0;
    assign start = mflo | mfhi | divu | div | mult | multu | mthi | mtlo | syscall;
    assign F_delay_op = jal | beq | jr | bne;
    assign D_error_RI = !(((D_op == 6'b000000)&(D_fuc == 6'b000000)) | add | sub | and_op | or_op | slt | sltu | lui | addi | andi | ori | lb | lh | lw | sb | sh | sw | mult | multu | div | divu | mfhi | mflo | mthi | mtlo | beq | bne | jal | jr | mfc0 | mtc0 | eret | syscall);
    assign D_error_syscall = syscall;
    assign F_PC_op = eret;
endmodule