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
module DM_IN_EXT(
    input [31:0] in,
    output reg [31:0] out,
    input [3:0] EXT_op
    );
initial begin
    out <= 32'h0000_0000;
end
always @(*) begin
    case(EXT_op)
    4'b0000:
        begin
            out = in;
        end
    4'b1111:
        begin
            out = in;
        end
    4'b0011:
        begin
            out = {{16{1'b0}},in[15:0]};
        end
    4'b0001:
        begin
            out = {{24{1'b0}},in[7:0]};
        end
    4'b1100:
        begin
            out = {in[15:0],{16{1'b0}}};
        end
    4'b0010:
        begin
            out = {{16{1'b0}},in[7:0],{8{1'b0}}};
        end
    4'b0100:
        begin
            out = {{8{1'b0}},in[7:0],{16{1'b0}}};
        end
    4'b1000:
        begin
            out = {in[7:0],{24{1'b0}}};
        end
    endcase
end
endmodule

