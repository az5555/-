`timescale 1ns / 1ps
module Bridge(
    input [31:0] CPU_data_addr,
    input [31:0] CPU_data_wdata,
    input [3 :0] CPU_data_byteen,
    output [31:0] CPU_data_rdata,

    output [31:0] DM_data_addr,
    output [31:0] DM_data_wdata,
    output [3 :0] DM_data_byteen,
    input [31:0] DM_data_rdata,

    output [31:0] Timer1_data_addr,
    output [31:0] Timer1_data_wdata,
    output Timer1_WE,
    input [31:0] Timer1_data_rdata,
    
    output [31:0] Timer2_data_addr,
    output [31:0] Timer2_data_wdata,
    output Timer2_WE,
    input [31:0] Timer2_data_rdata,

    output [31:0] int_data_addr,
    output [31:0] int_data_wdata,
    output [3 :0] int_data_byteen,
    input [31:0] int_data_rdata
);
assign DM_data_addr = CPU_data_addr;
assign Timer1_data_addr = CPU_data_addr;
assign Timer2_data_addr = CPU_data_addr;
assign int_data_addr = CPU_data_addr;
assign DM_data_wdata = CPU_data_wdata;
assign Timer1_data_wdata = CPU_data_wdata;
assign Timer2_data_wdata = CPU_data_wdata;
assign int_data_wdata = CPU_data_wdata;
assign DM_data_byteen = (CPU_data_addr >= 32'h0000_0000 && CPU_data_addr <= 32'h0000_2FFF) ? CPU_data_byteen : 4'b0000;
assign int_data_byteen = (CPU_data_addr >= 32'h0000_7F20 && CPU_data_addr <= 32'h0000_7F23) ? CPU_data_byteen : 4'b0000;
assign Timer1_WE = (CPU_data_addr >= 32'h0000_7F00 && CPU_data_addr <= 32'h0000_7F0B && CPU_data_byteen == 4'b1111) ? 1'b1 : 1'b0;
assign Timer2_WE = (CPU_data_addr >= 32'h0000_7F10 && CPU_data_addr <= 32'h0000_7F1B && CPU_data_byteen == 4'b1111) ? 1'b1 : 1'b0;
assign CPU_data_rdata = (CPU_data_addr >= 32'h0000_0000 && CPU_data_addr <= 32'h0000_2FFF) ? DM_data_rdata :
                        (CPU_data_addr >= 32'h0000_7F00 && CPU_data_addr <= 32'h0000_7F0B) ? Timer1_data_rdata :
                        (CPU_data_addr >= 32'h0000_7F10 && CPU_data_addr <= 32'h0000_7F1B) ? Timer2_data_rdata :
                        (CPU_data_addr >= 32'h0000_7F20 && CPU_data_addr <= 32'h0000_7F23) ? 32'h0000_0000 : 32'h0000_0000;
endmodule