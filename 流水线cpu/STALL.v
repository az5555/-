`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:20 11/24/2022 
// Design Name: 
// Module Name:    STALL 
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
module STALL(
    output stall,
    input [1:0] D_Tuse_GRF_A1,
    input [1:0] D_Tuse_GRF_A2,
    input [1:0] E_Tnew,
    input [1:0] M_Tnew,
    input [1:0] W_Tnew,
    input [4:0] D_GRF_A1,
    input [4:0] D_GRF_A2,
    input [4:0] E_GRF_A3,
    input [4:0] M_GRF_A3,
    input [4:0] W_GRF_A3
    );
  assign stall = (D_Tuse_GRF_A1 < E_Tnew && D_GRF_A1 != 5'b00000 && D_GRF_A1 == E_GRF_A3) ? 1'b1 :
                (D_Tuse_GRF_A1 < M_Tnew && D_GRF_A1 != 5'b00000 && D_GRF_A1 == M_GRF_A3) ? 1'b1 :
                (D_Tuse_GRF_A1 < W_Tnew && D_GRF_A1 != 5'b00000 && D_GRF_A1 == W_GRF_A3) ? 1'b1 :
                 (D_Tuse_GRF_A2 < E_Tnew && D_GRF_A2 != 5'b00000 && D_GRF_A2 == E_GRF_A3) ? 1'b1 :
                (D_Tuse_GRF_A2 < M_Tnew && D_GRF_A2 != 5'b00000 && D_GRF_A2 == M_GRF_A3) ? 1'b1 :
                (D_Tuse_GRF_A2 < W_Tnew && D_GRF_A2 != 5'b00000 && D_GRF_A2 == W_GRF_A3) ? 1'b1 :1'b0;
endmodule
