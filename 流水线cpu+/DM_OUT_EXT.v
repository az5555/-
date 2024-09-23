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
module DM_OUT_EXT(
    input [31:0] in,
    output reg [31:0] out,
    input [2:0] EXT_op,
    input [1:0] addr
    );
initial begin
    out <= 32'h0000_0000;
end
always @(*) begin
    case(EXT_op)
    3'b000:
        begin
            out = in;
        end
    3'b001:
        begin
            if(addr[1:0] == 2'b00)
                begin
                    out = {{24{1'b0}},in[7:0]};
                end
            else if(addr[1:0] == 2'b01)
                begin
                    out = {{24{1'b0}},in[15:8]};
                end
            else if(addr[1:0] == 2'b10)
                begin
                    out = {{24{1'b0}},in[23:16]};
                end
            if(addr[1:0] == 2'b11)
                begin
                    out = {{24{1'b0}},in[31:24]};
                end
        end
    3'b010:
        begin
            if(addr[1:0] == 2'b00)
                begin
                    out = {{24{in[7]}},in[7:0]};
                end
            else if(addr[1:0] == 2'b01)
                begin
                    out = {{24{in[15]}},in[15:8]};
                end
            else if(addr[1:0] == 2'b10)
                begin
                    out = {{24{in[23]}},in[23:16]};
                end
            if(addr[1:0] == 2'b11)
                begin
                    out = {{24{in[31]}},in[31:24]};
                end
        end
    3'b011:
        begin
            if(addr[1] == 1'b0)
                begin
                    out = {{16{1'b0}},in[15:0]};
                end
            else if(addr[1] == 1'b1)
                begin
                    out = {{16{1'b0}},in[31:16]};
                end
        end
    3'b100:
        begin
            if(addr[1] == 1'b0)
                begin
                    out = {{16{in[15]}},in[15:0]};
                end
            else if(addr[1] == 1'b1)
                begin
                    out = {{16{in[31]}},in[31:16]};
                end
        end
    endcase
end
endmodule

