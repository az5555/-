`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:04 09/18/2022 
// Design Name: 
// Module Name:    cpu_checker 
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
`define s0 8'h00//s0=初始 s1==^ s2=十进制数time s3=@ s4=8位十六进制数pc s5=: s6=0个或若干空格 s7=$  s7*=*  s8=十进制数grf
`define s1 8'h01//s8*=8位十六进制数addr s9=0个或若干空格 s10=< s11==  s12=8位十六进制数data s13=#
`define s2 8'h02
`define s3 8'h03
`define s4 8'h04
`define s5 8'h05
`define s6 8'h06
`define s7 8'h07
`define s70 8'h08
`define s8 8'h09
`define s80 8'h0a
`define s9 8'h0b
`define s10 8'h0c
`define s11 8'h0d
`define s12 8'h0e
`define s13 8'h0f
`define s14 8'h10
module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
    output [1:0] format_type
    );
reg [7:0] status;
reg op;
reg [3:0] i;
initial begin
    status <= `s0;
    op <= 1'b0;
    i <= 4'd0;
end
assign format_type = (status == `s13 && op == 1'b1) ? 2'b10 :
                     (status == `s13 && op == 1'b0) ? 2'b01 : 2'b00;
always@(posedge clk)
begin
    if(reset == 1'b1)
    begin
    status <= `s0;
    op <= 0;
    i <= 0;
    end
    else 
    begin
        case(status)
        `s0:begin
            if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s1:begin
            if(char >= "0" && char <= "9")
                begin
                    status <= `s2;
                    i <=4'd1;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s2:begin
            if(char >= "0" && char <= "9")
                begin
                    i <= i + 3'd1;
                    if(i+ 1<=4'd4)
                    begin
                        status <= `s2;
                    end
                    else
                    begin
                        status <= `s0;
                    end
                end
            else if(char == "@")
                begin
                    status <= `s3;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s3:begin
            if(char >= "0" && char <= "9" || char >= "a" && char <= "f")
                begin
                    status <= `s4;
                    i <= 4'd1;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s4:begin
            if(char >= "0" && char <= "9" || char >= "a" && char <= "f")
                begin
                    status <= `s4;
                    i <= 4'd1 + i;
                end
            else if(i == 4'd8 && char == ":")
                begin
                    status <= `s5;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s5:begin
            if(char == " ")
                begin
                    status <= `s5;
                end
            else if(char == "$")
                begin
                    status <= `s7;
                    op <= 1'b0;
                end
            else if(char == "*")
                begin
                    status <= `s70;
                    op <= 1'b1;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s7:begin
            if(char >= "0" && char <= "9")
                begin
                    status <= `s8;
                    i <=4'd1;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s8:begin
            if(char >= "0" && char <= "9")
                begin
                    i <= i + 4'd1;
                    if(i+ 1 <= 4'd4)
                    begin
                        status <= `s8;
                    end
                    else
                    begin
                        status <= `s0;
                    end
                end
            else if(char == " ")
                begin
                    status <= `s9;
                end
            else if(char == "<")
                begin
                    status <= `s10;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s70:begin
            if(char >= "0" && char <= "9" || char >= "a" && char <= "f")
                begin
                    status <= `s80;
                    i= 4'd1;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        `s80:begin
            if(char >= "0" && char <= "9" || char >= "a" && char <= "f")
                begin
                    status <= `s80;
                    i <= 4'd1 + i;
                end
            else if(i == 4'd8 && char == " ")
                begin
                    status <= `s9;
                end
            else if(i== 4'd8 && char == "<")
                begin
                    status <= `s10;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
            `s9:begin
            if(char == "<")
                begin
                    status <= `s10;
                end
            else if(char == " ")
                begin
                    status <= `s9;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
            `s10:begin
            if(char == "=")
                begin
                    status <= `s11;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
            `s11:begin
            if(char == " ")
                begin
                    status <= `s11;
                end
            else if(char >= "0" && char <= "9" || char >= "a" && char <= "f")
                begin
                    status <= `s12;
                    i <= 4'd1;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
            `s12:begin
            if(char >= "0" && char <= "9" || char >= "a" && char <= "f")
                begin
                    status <= `s12;
                    i <= 4'd1 + i;
                end
            else if(i == 4'd8 && char == "#")
                begin
                    status <= `s13;
                end
            else if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
            `s13:begin
            if(char == "^")
                begin
                    status <= `s1;
                end
            else
                begin
                    status <= `s0;
                end
            end
        endcase
    end
end
endmodule
