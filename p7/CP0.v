`timescale 1ns / 1ps
`define IM SR[15:10] //分别对应六个外部中断，相应位置 1 表示允许中断，置 0 表示禁止中断。这是一个被动的功能，
                     //只能通过 mtc0 这个指令修改，通过修改这个功能域，我们可以屏蔽一些中断。
`define EXL SR[1]  //任何异常发生时置位，这会强制进入核心态（也就是进入异常处理程序）并禁止中断。
`define IE SR[0]    //全局中断使能，该位置 1 表示允许中断，置 0 表示禁止中断。
`define BD Cause[31] //当该位置 1 的时候，EPC 指向当前指令的前一条指令（一定为跳转），否则指向当前指令。
`define IP Cause[15:10] //为 6 位待决的中断位，分别对应 6 个外部中断，相应位置 1 表示有中断，
                        //置 0 表示无中断，将会每个周期被修改一次，修改的内容来自计时器和外部中断。
`define ExcCode Cause[6:2]

module CP0(
    input clk,
    input reset,
    input en_WE,
    input [4:0] CP0_address,
    input [31:0] CP0_WE_data,
    output [31:0] CP0_out_data,
    input [31:0] VPC,   //受害 PC。
    input delay_op,  
    input [4:0] EXEcode,
    input [5:0] HWint,  //输入中断信号。
    input EXLclr,      //用来复位 EXL。
    output [31:0] EPC_out,
    output req
);
reg [31:0] EPC;
reg [31:0] SR;
reg [31:0] Cause;
initial begin
    EPC <= 32'h0000_0000;
    SR <= 32'h0000_0000;
    Cause <= 32'h0000_0000;
end
assign EPC_out = EPC;
wire int;
wire error;
wire  [31:0]  EPC_mid;
assign EPC_mid = (delay_op) ? VPC - 32'h0000_0004 : VPC;
assign error = !`EXL && (EXEcode != 5'b00000);
assign int = !`EXL && `IE && ((HWint & `IM) != 5'b00000);
assign req = int | error ;
assign CP0_out_data = (CP0_address == 12) ? SR :
                    (CP0_address == 13) ? Cause :
                    (CP0_address == 14) ? EPC : 32'h0000_0000;
always @(posedge clk) begin
    if(reset) begin
        EPC <= 32'h0000_0000;
        SR <= 32'h0000_0000;
        Cause <= 32'h0000_0000;
    end
    else begin
        if(EXLclr) begin
            `EXL <= 1'b0;
        end
        if(req) begin
            `EXL <= 1'b1;
            `ExcCode <= (int) ? 5'b00000 : EXEcode;
            `BD <= delay_op;
            EPC <= EPC_mid;
        end
        if(en_WE) begin
            if(CP0_address == 12) begin
                SR <= CP0_WE_data;
            end
            else if(CP0_address == 13) begin
                Cause <= CP0_WE_data;
            end
            else if(CP0_address == 14) begin
                EPC <= CP0_WE_data;
            end
        end
        `IP <= HWint;
    end
end
endmodule