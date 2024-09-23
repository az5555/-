`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:36 10/30/2022 
// Design Name: 
// Module Name:    EXT 
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
`define zero_ext 2'b00
`define lui_ext 2'b01
`define sign_ext 2'b10
module EXT(
    input [15:0] in,
    output reg [31:0] out,
    input [1:0] EXT_op
    );
initial begin
    out <= 32'h0000_0000;
end
always @(*) begin
    case(EXT_op)
    `zero_ext:
        begin
            out = {{16{1'b0}},in[15:0]};
        end
    `lui_ext:
        begin
            out = {in[15:0],{16{1'b0}}};
        end
    `sign_ext:
        begin
            out = {{16{in[15]}},in[15:0]};
        end
    endcase
end
endmodule

