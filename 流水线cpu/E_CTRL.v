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
    output [1:0] E_Tnew
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
    assign addei = (E_op == 6'b110011);
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
    assign E_ALU_MUX_A2[0] = ori | lw | sw | lui | addei;
    assign E_ALU_op[0] = sub;
    assign E_ALU_op[1] = ori;
    assign E_ALU_op[2] = addei;
	 assign E_ALU_op[3] = 1'b0;
    assign E_ALU_MUX_A1 =3'b000;
    assign E_ALU_MUX_S = 3'b000;
    assign E_ALU_MUX_A2[2:1] = 2'b00;
    assign E_Tnew = (lw) ? 2'b10 :
                    ((fuc_op &(E_fuc != 6'b000000)) | ori | lui | addei) ? 2'b01 :2'b00;
endmodule
