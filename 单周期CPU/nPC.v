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
module nPC(
    input [31:0] pc,
    output reg [31:0] npc,
    input [1:0] npc_op,
    input [25:0] imm_j,
    input [15:0] imm_off,
    input [31:0] jr
    );
initial begin
npc <= 32'h0000_0000;
end
always @(*) begin
    case(npc_op)
    2'b00:begin
        npc = 32'h0000_0004 + pc;
    end
    2'b01:begin
        npc = pc + 32'h0000_0004 + {{14{imm_off[15]}},imm_off[15:0],2'b00};
    end
    2'b10:begin
        npc = {pc[31:28],imm_j[25:0],2'b00};
    end
    2'b11:begin
        npc = jr;
    end
    endcase
end
endmodule