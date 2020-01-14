`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:14:09 03/31/2019 
// Design Name: 
// Module Name:    SCPU 
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
module SCPU(input clk,// 			
				input reset, //
				input MIO_ready, //不用
				input [31:0]inst_in, //指令的输入
				input [31:0]Data_in, //	内存中读到的数据mem from dm				
				output mem_w, //内存写使能
				output[31:0]PC_out, //pc的输出
				output[31:0]Addr_out, //写回/读取内存的地址 ALUout
				output[31:0]Data_out, //写回内存的数据 rt_out
				output [31:0]CPU_MIO, //不用
				input INT//不用
    );
	 
	 mips mips(clk,reset,MIO_ready,inst_in,Data_in,mem_w,PC_out,Addr_out,Data_out,CPU_MIO,INT);

endmodule
