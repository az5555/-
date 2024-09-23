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
    output [1:0] D_NPC_op,
    output [2:0] D_GRF_A1_op,
    output [2:0] D_GRF_A2_op,
    output [2:0] D_GRF_A3_op,
    output [1:0] D_Tuse_GRF_A1,
    output [1:0] D_Tuse_GRF_A2,
    output [2:0] D_grf_address_mux_op,
    output Nullify
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
    assign addei = (D_op == 6'b110011);
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
    assign D_NPC_op[0] = jr | (beq & j_op);
    assign D_NPC_op[1] = jal | jr;
    assign D_EXT_op[1] = beq | lw | sw | addei;
    assign D_EXT_op[0] = lui | addei ;
    assign D_GRF_A1_op = 2'b00;
    assign D_GRF_A2_op =2'b00;
    assign D_GRF_A3_op = 2'b000;
    assign D_Tuse_GRF_A1 = (beq | jr) ? 2'b00 :
                        (fuc_op | ori | sw | lui | lw | addei ) ? 2'b01 : 2'b11;
    assign D_Tuse_GRF_A2 = (beq) ? 2'b00 :
                        (fuc_op) ? 2'b01 :
                        (sw) ? 2'b10 : 2'b11;
    assign D_grf_address_mux_op[0] = ori  | lw | lui | addei;
    assign D_grf_address_mux_op[1] = jal;
	 assign D_grf_address_mux_op[2] = sw | beq ;
endmodule