`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:19 10/30/2022 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A1,
    input [31:0] A2,
    output reg [31:0] ans,
    input [2:0] ALU_op
    );
integer i;
initial begin
ans <= 32'h0000_0000;
end
always @(*) begin
    case(ALU_op)
    3'b000:
    begin
        ans = A1 + A2;
    end
    3'b001:
    begin
        ans = A1 - A2;
    end
    3'b010:
    begin
        ans = A1 | A2;
    end
    3'b011:
    begin
        if(A1 == A2)
        begin
            ans = 32'h0000_0001;
        end
        else
        begin
            ans = 32'h0000_0000;
        end
    end
    3'b100:
    begin
        if(A2 == 32'h0000_0000)
        begin
            ans = A1;
        end
        else
        begin
            for(i = 0 ;i <32 ;i = i + 1)
                begin
                    if(i < A2)
                    begin
                        ans[i] = ~A1[i];
                    end
                    else
                    begin
                        ans[i] = A1[i];
                    end
                end
        end

    end
    endcase
end
endmodule

