`timescale 1ns / 1ps
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
    wire [31:0] next_PC;
    wire [31:0] F_PC;
    wire stall;
    PC PC1(
    .clk(clk),
    .reset(reset),
    .in(next_PC),
    .out(F_PC),
    .en(stall)
        );
		
	wire [31:0] W_PC;
    wire [5:0] F_op;
    wire [5:0] F_fuc;
    wire [4:0] F_rs;
    wire [4:0] F_rt;
    wire [4:0] F_rd;
    wire [15:0] F_imm_16;
    wire [25:0] F_imm_26;
    wire [4:0] F_shamt;
    IM IM1(
    .address(F_PC),
    .op(F_op),
    .fuc(F_fuc),
    .rs(F_rs),
    .rt(F_rt),
    .rd(F_rd),
    .imm_16(F_imm_16),
    .imm_26(F_imm_26),
    .shamt(F_shamt)
        );
    
    wire [31:0] D_PC;
    wire [5:0] D_op;
    wire [5:0] D_fuc;
    wire [4:0] D_rs;
    wire [4:0] D_rt;
    wire [4:0] D_rd;
    wire [15:0] D_imm_16;
    wire [25:0] D_imm_26;
    wire [4:0] D_shamt;
    D_REG D_REG1(
        .clk(clk),
        .reset(reset),
        .F_PC(F_PC),
        .F_op(F_op),
        .F_fuc(F_fuc),
        .F_rs(F_rs),
        .F_rt(F_rt),
        .F_rd(F_rd),
        .F_imm_16(F_imm_16),
        .F_imm_26(F_imm_26),
        .F_shamt(F_shamt),
        .D_PC(D_PC),
        .D_op(D_op),
        .D_fuc(D_fuc),
        .D_rs(D_rs),
        .D_rt(D_rt),
        .D_rd(D_rd),
        .D_imm_16(D_imm_16),
        .D_imm_26(D_imm_26),
        .D_shamt(D_shamt),
        .en(stall)
    );

    wire j_op;
    wire [4:0] D_GRF_A1;
    wire [4:0] D_GRF_A2;
    wire [4:0] E_GRF_A3;
    wire [4:0] M_GRF_A3;
	wire [4:0] W_GRF_A3;
    wire [5:0] E_op;
    wire [5:0] M_op;
    wire [1:0] D_EXT_op;
    wire [1:0] D_NPC_op;
    wire [2:0] D_GRF_A1_op;
    wire [2:0] D_GRF_A2_op;
    wire [2:0] D_GRF_A3_op;
    wire [1:0] D_Tuse_GRF_A1;
    wire [1:0] D_Tuse_GRF_A2;
    wire [2:0] D_grf_address_mux_op;
    wire Nullify;
    D_CTRL D_CTRL1(
        .D_op(D_op),
        .D_fuc(D_fuc),
        .j_op(j_op),
        .D_GRF_A1(D_GRF_A1),
        .D_GRF_A2(D_GRF_A2),
        .E_op(E_op),
        .M_op(M_op),
        .D_EXT_op(D_EXT_op),
        .D_NPC_op(D_NPC_op),
        .D_GRF_A1_op(D_GRF_A1_op),
        .D_GRF_A2_op(D_GRF_A2_op),
        .D_GRF_A3_op(D_GRF_A3_op),
        .D_Tuse_GRF_A1(D_Tuse_GRF_A1),
        .D_Tuse_GRF_A2(D_Tuse_GRF_A2),
        .D_grf_address_mux_op(D_grf_address_mux_op),
        .Nullify(Nullify)
    );

    wire [4:0] A3;
    wire W_WE_op;
    wire [31:0] WE;
    wire [31:0] D_GRF_RD1;
    wire [31:0] D_GRF_RD2;
	 wire [4:0] D_GRF_A3;
    GRF GRF1(
        .A1(D_GRF_A1),
        .A2(D_GRF_A2),
        .A3(A3),
        .WE_op(W_WE_op),
        .WE(WE),
        .clk(clk),
        .RD1(D_GRF_RD1),
        .RD2(D_GRF_RD2),
        .reset(reset),
        .PC(W_PC)
    );
    assign D_GRF_A1 = (D_GRF_A1_op == 2'b00) ? D_rs :D_rs;
    assign D_GRF_A2 = (D_GRF_A2_op == 2'b00) ? D_rt :  D_rt;
    assign D_GRF_A3 = (D_grf_address_mux_op == 3'b000) ? D_rd :
                        (D_grf_address_mux_op == 3'b001) ? D_rt :
                        (D_grf_address_mux_op == 3'b010) ? 5'b11111 :
                        (D_grf_address_mux_op == 3'b100) ? 5'b00000 : 5'bzzzzz;

    wire [31:0] D_EXT_imm;
    EXT EXT1(
        .in(D_imm_16),
        .out(D_EXT_imm),
        .EXT_op(D_EXT_op)
    );

    wire [25:0] imm_j;
    wire [15:0] imm_off;
    wire [31:0] jr;
    nPC nPC(
        .pc(D_PC),
        .npc(next_PC),
        .imm_j(imm_j),
        .imm_off(imm_off),
        .npc_op(D_NPC_op),
        .jr(jr),
		  .F_PC(F_PC)
    );
    assign imm_j = D_imm_26;
    assign imm_off = D_imm_16;
    assign jr = (D_GRF_A1 == 5'b00000) ? 32'h0000_0000 :
                (D_GRF_A1 ==  M_GRF_A3 ) ? M_for : 
                (D_GRF_A1 == W_GRF_A3) ? W_for :  D_GRF_RD1;

    wire [31:0] CMP1;
    wire [31:0] CMP2;
    CMP MDCMP1(
        .CMP1(CMP1),
        .CMP2(CMP2),
        .j_op(j_op)
    );
    assign CMP1 = (D_GRF_A1 == 5'b00000) ? 32'h0000_0000 :
                (D_GRF_A1 ==  M_GRF_A3 ) ? M_for : 
                (D_GRF_A1 == W_GRF_A3) ? W_for :  D_GRF_RD1;
    assign CMP2 = (D_GRF_A2 == 5'b00000) ? 32'h0000_0000 :
                (D_GRF_A2 ==  M_GRF_A3 ) ? M_for : 
                (D_GRF_A2 == W_GRF_A3) ? W_for :  D_GRF_RD2;

    assign D_CMP_op = (D_NPC_op == 2'b01 && j_op);
    wire [31:0] E_PC;
    wire [5:0] E_fuc;
    wire [4:0] E_rs;
    wire [4:0] E_rt;
    wire [4:0] E_rd;
    wire [25:0] E_imm_26;
    wire [4:0] E_shamt;
    wire [4:0] E_GRF_A1;
    wire [4:0] E_GRF_A2;
    wire [31:0] E_EXT_imm;
    wire [31:0] E_GRF_RD1;
    wire [31:0] E_GRF_RD2;
    wire E_CMP_op;
    E_REG E_REG1(
        .clk(clk),
        .reset(reset || stall),
        .D_PC(D_PC),
        .D_op(D_op),
        .D_fuc(D_fuc),
        .D_rs(D_rs),
        .D_rt(D_rt),
        .D_rd(D_rd),
        .D_EXT_imm(D_EXT_imm),
        .D_imm_26(D_imm_26),
        .D_shamt(D_shamt),
        .D_CMP_op(D_CMP_op),
        .E_PC(E_PC),
        .E_op(E_op),
        .E_fuc(E_fuc),
        .E_rs(E_rs),
        .E_rt(E_rt),
        .E_rd(E_rd),
        .E_EXT_imm(E_EXT_imm),
        .E_imm_26(E_imm_26),
        .E_shamt(E_shamt),
        .E_CMP_op(E_CMP_op),
        .D_GRF_A1(D_GRF_A1),
        .D_GRF_A2(D_GRF_A2),
        .D_GRF_A3(D_GRF_A3),
        .D_GRF_RD1(D_GRF_RD1),
        .D_GRF_RD2(D_GRF_RD2),
        .E_GRF_A1(E_GRF_A1),
        .E_GRF_A2(E_GRF_A2),
        .E_GRF_A3(E_GRF_A3),
        .E_GRF_RD1(E_GRF_RD1),
        .E_GRF_RD2(E_GRF_RD2)
    );

    wire [5:0] W_op;
    wire [3:0] E_ALU_op;
    wire [2:0] E_ALU_MUX_A1;
    wire [2:0] E_ALU_MUX_A2;
    wire [2:0] E_ALU_MUX_S;
    wire [1:0] E_Tnew;
    E_CTRL E_CTRL1(
        .E_op(E_op),
        .E_fuc(E_fuc),
        .E_GRF_A1(E_GRF_A1),
        .E_GRF_A2(E_GRF_A2),
        .M_op(M_op),
        .W_op(W_op),
        .E_ALU_op(E_ALU_op),
        .E_ALU_MUX_A1(E_ALU_MUX_A1),
        .E_ALU_MUX_A2(E_ALU_MUX_A2),
        .E_ALU_MUX_S(E_ALU_MUX_S),
        .E_Tnew(E_Tnew)
    );

    wire [31:0] E_ALU_A1;
    wire [31:0] E_ALU_A2;
    wire [31:0] ALU_RD1;
    wire [31:0] ALU_RD2;
    wire [31:0] E_ALU_ans;
    wire un_alu_op;
    ALU ALU1(
        .A1(E_ALU_A1),
        .A2(E_ALU_A2),
        .ans(E_ALU_ans),
        .ALU_op(E_ALU_op),
        .un_alu_op(un_alu_op)
    );
    assign ALU_RD1 = (E_GRF_A1 == 5'b00000) ? 32'h0000_0000 :
                (E_GRF_A1 ==  M_GRF_A3 ) ? M_for : 
                (E_GRF_A1 == W_GRF_A3) ? W_for :  E_GRF_RD1;
    assign ALU_RD2 = (E_GRF_A2 == 5'b00000) ? 32'h0000_0000 :
                (E_GRF_A2 ==  M_GRF_A3 ) ? M_for : 
                (E_GRF_A2 == W_GRF_A3) ? W_for :  E_GRF_RD2;
    assign E_ALU_A1 = (E_ALU_MUX_A1 == 3'b000) ? ALU_RD1 : ALU_RD1;
    assign E_ALU_A2 = (E_ALU_MUX_A2 == 3'b000) ? ALU_RD2 : 
                        (E_ALU_MUX_A2 == 3'b001) ? E_EXT_imm :  ALU_RD2;
                        
    wire [31:0] M_PC;
    wire [5:0] M_fuc;
    wire [4:0] M_rs;
    wire [4:0] M_rt;
    wire [4:0] M_rd;
    wire [25:0] M_imm_26;
    wire [4:0] M_shamt;
    wire [31:0] M_GRF_RD2;
    wire M_CMP_op;
    wire [4:0] M_GRF_A2;
    wire [31:0] M_EXT_imm;
    wire [31:0] M_GRF_RD1;
    wire [31:0] M_ALU_ans;
    M_REG M_REG1(
        .clk(clk),
        .reset(reset),
        .M_PC(M_PC),
        .M_op(M_op),
        .M_fuc(M_fuc),
        .M_rs(M_rs),
        .M_rt(M_rt),
        .M_rd(M_rd),
        .M_imm_26(M_imm_26),
        .M_shamt(M_shamt),
        .M_CMP_op(M_CMP_op),
        .E_PC(E_PC),
        .E_op(E_op),
        .E_fuc(E_fuc),
        .E_rs(E_rs),
        .E_rt(E_rt),
        .E_rd(E_rd),
        .E_imm_26(E_imm_26),
        .E_shamt(E_shamt),
        .E_CMP_op(E_CMP_op),
        .M_GRF_A2(M_GRF_A2),
        .M_GRF_A3(M_GRF_A3),
        .M_GRF_RD2(M_GRF_RD2),
        .E_GRF_A2(E_GRF_A2),
        .E_GRF_A3(E_GRF_A3),
        .E_GRF_RD2(ALU_RD2),
        .E_ALU_ans(E_ALU_ans),
        .M_ALU_ans(M_ALU_ans)
    );

    wire [1:0] M_DM_op;
    wire [1:0] M_DM_address_mux_op;
    wire [1:0] M_DM_WE_max_op;
    wire [2:0] M_for_mux_op;
    wire [31:0] M_for;
    wire [1:0] M_Tnew;
    M_CTRL M_CTRL1(
        .M_op(M_op),
		  .M_DM_op(M_DM_op),
        .M_fuc(M_fuc),
        .M_GRF_A2(M_GRF_A2),
        .W_op(W_op),
        .M_DM_WE_op(M_DM_WE_op),
        .M_DM_address_mux_op(M_DM_address_mux_op),
        .M_DM_WE_max_op(M_DM_WE_max_op),
        .M_Tnew(M_Tnew),
		  .M_for_mux_op(M_for_mux_op)
    );
    assign M_for = (M_for_mux_op == 3'b010) ? M_PC +32'h0000_0008 : M_ALU_ans ;

    wire [31:0] DM_address;
    wire [31:0] M_DM_WE;
    wire [31:0] M_DM_out; 
    wire [31:0] M_DM_RD2;
    DM DM1(
        .address(DM_address),
        .in(M_DM_WE),
        .out(M_DM_out),
        .M_DM_op(M_DM_op),
        .DM_write(M_DM_WE_op),
        .clk(clk),
        .reset(reset),         
        .PC(M_PC)
    );
    assign DM_address = (M_DM_address_mux_op == 3'b000) ? M_ALU_ans : M_ALU_ans;
    assign M_DM_RD2 = (M_GRF_A2 == 5'b00000) ? 32'h0000_0000 :
                (M_GRF_A2 == W_GRF_A3) ? W_for :  M_GRF_RD2;
    assign M_DM_WE = (M_DM_WE_max_op == 3'b000) ? M_DM_RD2 : M_DM_RD2;

    wire [31:0] W_ALU_ans;
    wire [31:0] W_DM_out;
    wire W_CMP_op;
    wire [31:0] W_DM_WE;
    wire [5:0] W_fuc;
    wire [4:0] W_rs;
    wire [4:0] W_rt;
    wire [4:0] W_rd;
    wire [25:0] W_imm_26;
    wire [4:0] W_shamt;
    W_REG W_REG1(
        .clk(clk),
        .reset(reset),
        .M_PC(M_PC),
        .M_op(M_op),
        .M_fuc(M_fuc),
        .M_rs(M_rs),
        .M_rt(M_rt),
        .M_rd(M_rd),
        .M_imm_26(M_imm_26),
        .M_shamt(M_shamt),
        .M_CMP_op(M_CMP_op),
        .M_GRF_A3(M_GRF_A3),
        .M_DM_WE(M_DM_WE),
        .M_DM_out(M_DM_out),
        .W_PC(W_PC),
        .W_op(W_op),
        .W_fuc(W_fuc),
        .W_rs(W_rs),
        .W_rt(W_rt),
        .W_rd(W_rd),
        .W_imm_26(W_imm_26),
        .W_shamt(W_shamt),
        .W_CMP_op(W_CMP_op),
        .W_GRF_A3(W_GRF_A3),
        .W_DM_WE(W_DM_WE),
        .W_DM_out(W_DM_out),
        .W_ALU_ans(W_ALU_ans),
        .M_ALU_ans(M_ALU_ans)
    );

    wire [1:0] W_grf_WE_mux_op;
    wire [31:0] W_for;
    wire [1:0] W_Tnew;
	 wire [2:0] W_for_mux_op;
    W_CTRL W_CTRL1(
        .W_op(W_op),
        .W_fuc(W_fuc),
        .W_WE_op(W_WE_op),
        .W_grf_WE_mux_op(W_grf_WE_mux_op),
        .W_for_mux_op(W_for_mux_op),
        .W_Tnew(W_Tnew)
    );
    assign WE = (W_grf_WE_mux_op == 2'b00) ? W_ALU_ans :
            (W_grf_WE_mux_op == 2'b01) ? W_DM_out :
            (W_grf_WE_mux_op == 2'b10) ? W_PC +32'h0000_0008 : W_ALU_ans;
    assign A3 = W_GRF_A3;
    assign W_for = (W_for_mux_op == 3'b010) ? W_PC + 32'h0000_0008 :
                    (W_for_mux_op == 3'b001) ? W_DM_out : W_ALU_ans ;

    STALL STALL1(
        .stall(stall),
        .D_Tuse_GRF_A1(D_Tuse_GRF_A1),
        .D_Tuse_GRF_A2(D_Tuse_GRF_A2),
        .E_Tnew(E_Tnew),
        .M_Tnew(M_Tnew),
        .W_Tnew(W_Tnew),
        .D_GRF_A1(D_GRF_A1),
        .D_GRF_A2(D_GRF_A2),
        .E_GRF_A3(E_GRF_A3),
        .M_GRF_A3(M_GRF_A3),
        .W_GRF_A3(W_GRF_A3)
    );
endmodule
