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
`define int 5'd0  //中断
`define AdEL 5'd4  //取数异常
`define AdES 5'd5    //存数异常
`define Syscall 5'd8    //存数异常
`define RI 5'd10    //存数异常
`define Ov 5'd12    //存数异常
module cpu(
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
    output [31:0] macroscopic_pc,
    input [5:0] HWint,  //输入中断信号。
    output req
    );
	 wire stall_eret = (D_NPC_op == 3'b100) & ((E_op == 6'b010000 & E_rs == 5'b00100 & (E_rd == 5'd14)) || (M_op == 6'b010000 & M_rs == 5'b00100 & (M_rd == 5'd14)));
    assign macroscopic_pc = M_PC;
    assign w_inst_addr = W_PC;
	  wire [4:0] D_EXEcode_mid;
	 wire [31:0] EPC_out;
    wire [31:0] next_PC;
    wire [31:0] F_PC;
    wire stall;
    wire F_error;
    wire F_delay_op;
    wire [4:0] F_EXEcode;
    wire F_PC_op;
    PC PC1(
    .clk(clk),
    .reset(reset),
    .in(next_PC),
    .out(F_PC),
    .en(stall || stall_HILO || stall_eret),
    .req(req)
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
    assign i_inst_addr = F_PC;
    assign F_op = (F_PC_op) ? 6'b000000 : i_inst_rdata[31:26];
    assign F_fuc = (F_PC_op) ? 6'b000000 : i_inst_rdata[5:0];
    assign F_rs = (F_PC_op) ? 5'b00000 : i_inst_rdata[25:21];
    assign F_rt = (F_PC_op) ? 5'b00000 : i_inst_rdata[20:16];
    assign F_rd = (F_PC_op) ? 5'b00000 : i_inst_rdata[15:11];
    assign F_shamt = (F_PC_op) ? 5'b00000 : i_inst_rdata[10:6];
    assign F_imm_16 = (F_PC_op) ? 16'h0000 : i_inst_rdata[15:0];
    assign F_imm_26 = (F_PC_op) ? 26'h0000_00 : i_inst_rdata[25:0]; 
    assign F_error = (F_PC < 32'h0000_3000 | F_PC > 32'h0000_6ffc | F_PC[1:0] != 2'b00);
    assign F_EXEcode = (F_error) ? `AdEL : 5'b00000;
    
    wire [31:0] D_PC;
    wire [5:0] D_op;
    wire [5:0] D_fuc;
    wire [4:0] D_rs;
    wire [4:0] D_rt;
    wire [4:0] D_rd;
    wire [15:0] D_imm_16;
    wire [25:0] D_imm_26;
    wire [4:0] D_shamt;
    wire D_delay_op;
    wire [4:0] D_EXEcode;
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
        .en(stall || stall_HILO || stall_eret),
        .F_delay_op(F_delay_op),
        .D_delay_op(D_delay_op),
        .F_EXEcode(F_EXEcode),
        .D_EXEcode(D_EXEcode),
        .req(req)
    );

    wire start_op;
    wire j_op;
    wire [4:0] D_GRF_A1;
    wire [4:0] D_GRF_A2;
    wire [4:0] E_GRF_A3;
    wire [4:0] M_GRF_A3;
	wire [4:0] W_GRF_A3;
    wire [5:0] E_op;
    wire [5:0] M_op;
    wire [1:0] D_EXT_op;
    wire [2:0] D_NPC_op;
    wire [2:0] D_GRF_A1_op;
    wire [2:0] D_GRF_A2_op;
    wire [2:0] D_GRF_A3_op;
	 wire [1:0] D_Tuse_GRF_A1;
    wire [1:0] D_Tuse_GRF_A2;
    wire [2:0] D_grf_address_mux_op;
    wire D_error_RI;
    wire D_error_syscall;
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
        .start(start_op),
        .F_delay_op(F_delay_op),
        .D_error_RI(D_error_RI),
        .D_rs(D_rs),
        .D_error_syscall(D_error_syscall),
        .F_PC_op(F_PC_op)
    );
    assign D_EXEcode_mid = (D_EXEcode != 5'b00000) ? D_EXEcode :
                            (D_error_syscall) ? `Syscall :
                            (D_error_RI) ? `RI : 5'b00000;

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
		  .F_PC(F_PC),
          .EPC_out(EPC_out)
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

    assign D_CMP_op = (D_NPC_op == 3'b001 && j_op);

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
    wire [3:0] HILO_op;
    wire E_ALU_MUX_ans;
    wire start;
    wire [4:0] E_EXEcode;
    wire E_delay_op;
    E_REG E_REG1(
        .clk(clk),
        .reset(reset),
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
        .E_GRF_RD2(E_GRF_RD2),
        .D_EXEcode(D_EXEcode_mid),
        .E_EXEcode(E_EXEcode),
        .E_delay_op(E_delay_op),
        .D_delay_op(D_delay_op),
        .req(req),
        .stall(stall || stall_HILO || stall_eret)
    );

    wire [5:0] W_op;
    wire [3:0] E_ALU_op;
    wire [2:0] E_ALU_MUX_A1;
    wire [2:0] E_ALU_MUX_A2;
    wire [2:0] E_ALU_MUX_S;
    wire [1:0] E_Tnew;
    wire ALU_Ov_op;
    wire [4:0] E_EXEcode_mid;
    wire E_error_AdEL;
    wire E_error_AdES;
    wire E_error_Ov;        
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
        .E_Tnew(E_Tnew),
		.HILO_op(HILO_op),
        .E_ALU_MUX_ans(E_ALU_MUX_ans),
        .start(start),
        .ALU_Ov_op(ALU_Ov_op),
        .E_error_AdEL(E_error_AdEL),
        .E_error_AdES(E_error_AdES),
        .E_error_Ov(E_error_Ov),
        .E_rs(E_rs)
    );
    
    assign E_EXEcode_mid = (E_EXEcode != 5'b00000) ? E_EXEcode :
                            (E_error_AdEL) ? `AdEL :
                            (E_error_AdES) ? `AdES :
                            (E_error_Ov) ? `Ov : 5'b00000;

    wire [31:0] E_ALU_A1;
    wire [31:0] E_ALU_A2;
    wire [31:0] ALU_RD1;
    wire [31:0] ALU_RD2;
    wire [31:0] E_ALU_ans;
    wire [31:0] E_ALU_ans_1;
    wire [31:0] E_ALU_ans_2;
    ALU ALU1(
        .A1(E_ALU_A1),
        .A2(E_ALU_A2),
        .ans(E_ALU_ans_1),
        .ALU_op(E_ALU_op),
        .ALU_Ov_op(ALU_Ov_op)
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

    wire busy;
    HILO HILO1(
        .A1(E_ALU_A1),
        .A2(E_ALU_A2),
        .ans(E_ALU_ans_2),
        .HILO_op(HILO_op),
        .start(start),
        .busy(busy),
		  .clk(clk),
        .reset(reset),
        .req(req)
    );
    assign stall_HILO = (busy || start) && start_op;
    assign E_ALU_ans = (E_ALU_MUX_ans == 1'b1) ? E_ALU_ans_2 : E_ALU_ans_1;
                        
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
    wire [2:0] M_OUT_op;
    wire [4:0] M_EXEcode;
    wire M_delay_op;
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
        .M_ALU_ans(M_ALU_ans),
        .E_EXEcode(E_EXEcode_mid),
        .M_EXEcode(M_EXEcode),
        .E_delay_op(E_delay_op),
        .M_delay_op(M_delay_op),
        .req(req)
    );

    wire [1:0] M_DM_op;
    wire [1:0] M_DM_address_mux_op;
    wire [1:0] M_DM_WE_max_op;
    wire [2:0] M_for_mux_op;
    wire [31:0] M_for;
    wire [1:0] M_Tnew;
    wire M_error_AdEL;
    wire M_error_AdES;
    wire [4:0] M_EXEcode_mid;
    wire CP0_WE_en;
    wire [31:0] DM_address;
    wire EXLclr;      //用来复位 EXL。
    M_CTRL M_CTRL1(
        .M_op(M_op),
		.M_DM_op(M_DM_op),
        .M_fuc(M_fuc),
        .M_GRF_A2(M_GRF_A2),
        .W_op(W_op),
        .M_DM_address_mux_op(M_DM_address_mux_op),
        .M_DM_WE_max_op(M_DM_WE_max_op),
        .M_Tnew(M_Tnew),
		.M_for_mux_op(M_for_mux_op),
        .M_rs(M_rs),
		.M_OUT_op(M_OUT_op),
        .CP0_WE_en(CP0_WE_en),
        .EXLclr(EXLclr),
        .DM_address(DM_address),
        .M_error_AdEL(M_error_AdEL),
        .M_error_AdES(M_error_AdES)
    );
    assign M_for = (M_for_mux_op == 3'b010) ? M_PC +32'h0000_0008 : M_ALU_ans ;
    assign M_EXEcode_mid = (M_EXEcode != 5'b00000) ? M_EXEcode :
                            (M_error_AdEL) ? `AdEL :
                            (M_error_AdES) ? `AdES : 5'b00000;

    wire [31:0] M_DM_WE;
    wire [31:0] M_DM_out; 
    wire [31:0] M_DM_RD2;
    assign DM_address = (M_DM_address_mux_op == 3'b000) ? M_ALU_ans : M_ALU_ans;
    assign M_DM_RD2 = (M_GRF_A2 == 5'b00000) ? 32'h0000_0000 :
                (M_GRF_A2 == W_GRF_A3) ? W_for :  M_GRF_RD2;
    assign M_DM_WE = (M_DM_WE_max_op == 3'b000) ? M_DM_RD2 : M_DM_RD2;
    assign m_data_addr = DM_address;
    assign m_inst_addr = M_PC;
    assign m_data_byteen =  (req == 1'b1) ? 4'b0000 :
                            (M_DM_op == 2'b11) ? 4'b1111 :
                            (M_DM_op == 2'b01 && DM_address[1] == 1'b0) ? 4'b0011 :
                            (M_DM_op == 2'b01 && DM_address[1] == 1'b1) ? 4'b1100 :
                            (M_DM_op == 2'b10 && DM_address[1:0] == 2'b00) ? 4'b0001 :
                            (M_DM_op == 2'b10 && DM_address[1:0] == 2'b01) ? 4'b0010 :
                            (M_DM_op == 2'b10 && DM_address[1:0] == 2'b10) ? 4'b0100 :
                            (M_DM_op == 2'b10 && DM_address[1:0] == 2'b11) ? 4'b1000 : 4'b0000;
    
    DM_IN_EXT DM_IN_EXT1(
        .in(M_DM_WE),
        .EXT_op(m_data_byteen),
        .out(m_data_wdata)
    );

    DM_OUT_EXT DM_OUT_EXT1(
        .in(m_data_rdata),
        .EXT_op(M_OUT_op),
        .out(M_DM_out),
        .addr(DM_address[1:0])
    );

    wire [4:0] CP0_address;
    wire [31:0] M_CP0_out_data;
    CP0 CP01(
        .CP0_address(CP0_address),
        .clk(clk),
        .reset(reset),
        .en_WE(CP0_WE_en && !req),
        .CP0_WE_data(M_DM_RD2),
        .CP0_out_data(M_CP0_out_data),
        .VPC(M_PC),
        .delay_op(M_delay_op),
        .EXEcode(M_EXEcode_mid),
        .HWint(HWint),
        .EXLclr(EXLclr),
        .EPC_out(EPC_out),
        .req(req)
    );
    assign CP0_address = M_rd;

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
    wire [4:0] W_EXEcode;
    wire [31:0] W_CP0_out_data;
    wire W_delay_op;

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
        .M_ALU_ans(M_ALU_ans),
        .M_EXEcode(M_EXEcode_mid),
        .W_EXEcode(W_EXEcode),
        .W_delay_op(W_delay_op),
        .M_delay_op(M_delay_op),
        .M_CP0_out_data(M_CP0_out_data),
        .W_CP0_out_data(W_CP0_out_data),
        .req(req)
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
        .W_rs(W_rs),
        .W_Tnew(W_Tnew)
    );
    assign WE = (W_grf_WE_mux_op == 2'b00) ? W_ALU_ans :
            (W_grf_WE_mux_op == 2'b01) ? W_DM_out :
            (W_grf_WE_mux_op == 2'b10) ? W_PC +32'h0000_0008 :
            (W_grf_WE_mux_op == 2'b11) ? W_CP0_out_data : W_ALU_ans;
    assign A3 = W_GRF_A3;
    assign W_for = (W_for_mux_op == 3'b010) ? W_PC + 32'h0000_0008 :
                    (W_for_mux_op == 3'b001) ? W_DM_out :
                    (W_for_mux_op == 3'b011) ? W_CP0_out_data : W_ALU_ans ;
	 assign w_grf_addr = A3;
    assign w_grf_wdata = WE;
    assign w_grf_we = W_WE_op;
    assign w_inst_addr = W_PC;


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