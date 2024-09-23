`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:48:06 10/29/2022 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC
    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据
    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号
    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号
    output [31:0] m_inst_addr,    // M 级 PC
    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据
    output [31:0] w_inst_addr     // W 级 PC
);
    wire [5:0] HWint;  //输入中断信号。
    wire req;
    wire [31:0] CPU_data_addr;
    wire [31:0] CPU_data_wdata;
    wire [3 :0] CPU_data_byteen;
    wire [31:0] CPU_data_rdata;
    wire [31:0] DM_data_addr;
    wire [31:0] DM_data_wdata;
    wire [3 :0] DM_data_byteen;
    wire [31:0] DM_data_rdata;
    wire [31:0] Timer1_data_addr;
    wire [31:0] Timer1_data_wdata;
    wire Timer1_WE;
    wire [31:0] Timer1_data_rdata;
    wire [31:0] Timer2_data_addr;
    wire [31:0] Timer2_data_wdata;
    wire Timer2_WE;
    wire [31:0] Timer2_data_rdata;
    wire [31:0] int_data_addr;
    wire [31:0] int_data_wdata;
    wire [3 :0] int_data_byteen;
    wire [31:0] int_data_rdata;
    cpu cpu1(
        .clk(clk),
        .reset(reset),
        .i_inst_rdata(i_inst_rdata),
        .m_data_rdata(CPU_data_rdata),
        .i_inst_addr(i_inst_addr),
        .m_data_addr(CPU_data_addr),
        .m_data_byteen(CPU_data_byteen),
        .m_data_wdata(CPU_data_wdata),
        .m_inst_addr(m_inst_addr),
        .w_inst_addr(w_inst_addr),
        .w_grf_we(w_grf_we),
        .w_grf_wdata(w_grf_wdata),
        .w_grf_addr(w_grf_addr),
        .macroscopic_pc(macroscopic_pc),
        .HWint(HWint),
        .req(req)
    );
    Bridge Bridge1(
        .CPU_data_addr(CPU_data_addr),
        .CPU_data_wdata(CPU_data_wdata),
        .CPU_data_byteen(CPU_data_byteen),
        .CPU_data_rdata(CPU_data_rdata),
        .DM_data_addr(DM_data_addr),
        .DM_data_byteen(DM_data_byteen),
        .DM_data_rdata(DM_data_rdata),
        .DM_data_wdata(DM_data_wdata),
        .Timer1_data_addr(Timer1_data_addr),
        .Timer1_data_rdata(Timer1_data_rdata),
        .Timer1_data_wdata(Timer1_data_wdata),
        .Timer1_WE(Timer1_WE),
        .Timer2_data_addr(Timer2_data_addr),
        .Timer2_data_rdata(Timer2_data_rdata),
        .Timer2_data_wdata(Timer2_data_wdata),
        .Timer2_WE(Timer2_WE),
        .int_data_addr(int_data_addr),
        .int_data_byteen(int_data_byteen),
        .int_data_rdata(int_data_rdata),
        .int_data_wdata(int_data_wdata)
    );
    assign m_data_addr = DM_data_addr;
    assign m_data_byteen = DM_data_byteen;
    assign DM_data_rdata = m_data_rdata ;
    assign m_data_wdata = DM_data_wdata;
    assign m_int_addr = int_data_addr;
    assign m_int_byteen = int_data_byteen;
    wire IRQ1;
    wire IRQ2;
    TC timer1(
        .clk(clk),
        .reset(reset),
        .Addr(Timer1_data_addr[31:2]),
        .WE(Timer1_WE),
        .Din(Timer1_data_wdata),
        .Dout(Timer1_data_rdata),
        .IRQ(IRQ1)
    );
    TC timer2(
        .clk(clk),
        .reset(reset),
        .Addr(Timer2_data_addr[31:2]),
        .WE(Timer2_WE),
        .Din(Timer2_data_wdata),
        .Dout(Timer2_data_rdata),
        .IRQ(IRQ2)
    );
    assign HWint = {{3{1'b0}},interrupt,IRQ2,IRQ1};
    assign int_data_rdata = 32'h0000_0000;
endmodule