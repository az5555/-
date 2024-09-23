`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:16:53 11/06/2022 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
    input [5:0] op,
    input [5:0] fuc,
    output [2:0] ALU_op,
    output DM_write,
    output DM_read,
    input j_op1,
    output [1:0] EXT_op,
    output [1:0] max_grf_address_op,
    output [1:0] max_grf_op,
    output max_alu_op,
    output [1:0] PC_op,
    output WE_op
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
    wire rlb;
    assign fuc_op = (op == 6'b000000);
    assign rlb = (op == 6'b111111);
    assign add = fuc_op & (fuc == 6'b100000);
    assign sub = fuc_op & (fuc == 6'b100010);
    assign ori = (op == 6'b001101);
    assign lw = (op == 6'b100011);
    assign sw = (op == 6'b101011);
    assign beq = (op == 6'b000100);
    assign lui = (op == 6'b001111);
    assign jal = (op == 6'b000011);
    assign jr = fuc_op & (fuc == 6'b001000);
    assign DM_read = lw;
    assign DM_write = sw;
    assign ALU_op[0] = sub | beq;
    assign ALU_op[1] = ori | beq;
    assign WE_op = add | sub | lw | lui | jal | ori |rlb;
    assign PC_op[0] = jr | (beq & j_op1) ;
    assign PC_op[1] = jal | jr;
    assign EXT_op[1] = beq | lw | sw;
    assign EXT_op[0] = lui;
    assign max_alu_op = ori | lw | sw | lui | rlb;
    assign max_grf_op[0] = lw;
    assign max_grf_op[1] = jal;
    assign max_grf_address_op[0] = ori  | sw | lw | lui | rlb;
    assign max_grf_address_op[1] = jal;
	assign ALU_op[2] = rlb;
endmodule