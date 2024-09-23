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
    2'b00:
        begin
            out = {{16{1'b0}},in[15:0]};
        end
    2'b01:
        begin
            out = {in[15:0],{16{1'b0}}};
        end
    2'b10:
        begin
            out = {{16{in[15]}},in[15:0]};
        end
    endcase
end
endmodule

