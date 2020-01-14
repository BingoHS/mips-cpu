`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:12:26 04/22/2019 
// Design Name: 
// Module Name:    Foward2 
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
module Foward2(FowardA2,FowardB2,ex_rs,ex_rt,mem_back,wb_back,mem_RegWrite,wb_RegWrite,wb_MemRead,mem_MemRead
    );
	 output reg[2:0]FowardA2;
	 output reg[2:0]FowardB2;
	 input [4:0]ex_rs;
	 input[4:0]ex_rt;
	 input [4:0]mem_back;
	 input [4:0]wb_back;
	 input mem_RegWrite,wb_RegWrite,wb_MemRead,mem_MemRead;
	 
	 always@(*)
	 begin
		if(ex_rs==mem_back && mem_MemRead)
			FowardA2=4;
		else if(ex_rs==mem_back &&mem_RegWrite)// (ex,mem,mem_aluout)
			FowardA2=1;
		else if(ex_rs==wb_back &&wb_MemRead)//(ex,wb,wb_dout)
			FowardA2=3;
		else if(ex_rs==wb_back && wb_RegWrite)//(ex,wn,wb_aluout)
			FowardA2=2;
		else
			FowardA2=0;
			
		if(ex_rt==mem_back && mem_MemRead)
			FowardB2=4;
		else if(ex_rt==mem_back &&mem_RegWrite)// (ex,mem,mem_aluout)
			FowardB2=1;
		else if(ex_rt==wb_back &&wb_MemRead)//(ex,wb,wb_dout)
			FowardB2=3;
		else if(ex_rt==wb_back && wb_RegWrite)//(ex,wn,wb_aluout)
			FowardB2=2;
		else
			FowardB2=0;
	 end


endmodule
