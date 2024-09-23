`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:44 11/06/2022 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] address,
    output [5:0] op,
    output [5:0] fuc,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm_16,
    output [25:0] imm_26,
    output [4:0] shamt
    );
    reg [31:0] data [4095:0];
    reg [31:0] instr;
    initial begin
        $readmemh("code.txt",data);
    end
  always @(*) begin
   instr[31:0] <= data[(address-32'h0000_3000)/4];
  end
    assign op[5:0] = instr[31:26];
    assign fuc[5:0] = instr[5:0];
    assign rs[4:0] = instr[25:21];
    assign rt[4:0] = instr[20:16];
    assign rd[4:0] = instr[15:11];
    assign shamt[4:0] = instr[10:6];
    assign imm_16[15:0] = instr[15:0];
    assign imm_26[25:0] = instr[25:0];
endmodule