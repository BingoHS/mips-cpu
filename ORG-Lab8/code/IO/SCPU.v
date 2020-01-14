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
				input MIO_ready, //����
				input [31:0]inst_in, //ָ�������
				input [31:0]Data_in, //	�ڴ��ж���������mem from dm				
				output mem_w, //�ڴ�дʹ��
				output[31:0]PC_out, //pc�����
				output[31:0]Addr_out, //д��/��ȡ�ڴ�ĵ�ַ ALUout
				output[31:0]Data_out, //д���ڴ������ rt_out
				output [31:0]CPU_MIO, //����
				input INT//����
    );
	 
	 mips mips(clk,reset,MIO_ready,inst_in,Data_in,mem_w,PC_out,Addr_out,Data_out,CPU_MIO,INT);

endmodule
