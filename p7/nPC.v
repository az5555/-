`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:45:55 11/06/2022 
// Design Name: 
// Module Name:    nPC 
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
`define npc4 3'b000
`define npc_off 3'b001
`define npc_j 3'b010
`define npc_jal 3'b011
module nPC(
    input [31:0] pc,
    output reg [31:0] npc,
    input [2:0] npc_op,
    input [25:0] imm_j,
    input [15:0] imm_off,
    input [31:0] jr,
	input [31:0] F_PC,
    input [31:0] EPC_out
    );
initial begin
npc <= 32'h0000_0000;
end
always @(*) begin
    case(npc_op)
    `npc4:begin
        npc = 32'h0000_0004 + F_PC;
    end
    `npc_off:begin
        npc = pc + 32'h0000_0004 + {{14{imm_off[15]}},imm_off[15:0],2'b00};
    end
    `npc_j:begin
        npc = {pc[31:28],imm_j[25:0],2'b00};
    end
    `npc_jal:begin
        npc = jr;
    end
    3'b100:begin
        npc = EPC_out;
    end
    endcase
end
endmodule