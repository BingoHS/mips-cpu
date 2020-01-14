`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:55:00 04/22/2019 
// Design Name: 
// Module Name:    Foward1 
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
module Foward1(FowardA1,FowardB1,rs,rt,ex_back,ex_RegWrite,ex_MemRead,mem_back,mem_RegWrite,mem_MemRead
    );
	 output reg[2:0]FowardA1;
	 output reg[1:0]FowardB1;
	 input [4:0]rs;
	 input[4:0]rt;
	 input[4:0]ex_back;
	 input [4:0]mem_back;
	 input mem_RegWrite,ex_RegWrite,ex_MemRead,mem_MemRead;
	 //0 ?? 1 ex_aluout 2mem_aluout 3Data_in
	 always@(*)
	 begin
		if(rs==ex_back && ex_RegWrite && !ex_MemRead) //(id,ex,ex_aluout)
			FowardA1=1;
		else if(rs==mem_back &&mem_MemRead)// (id,mem,Data_in)
			FowardA1=3;
		else if(rs==mem_back && rs==5'd31 && mem_RegWrite)
			FowardA1=4;
		else if(rs==mem_back &&mem_RegWrite)//(ex,mem,mem_aluout)
			FowardA1=2;
		else
			FowardA1=0;
			
		if(rt==ex_back && ex_RegWrite && !ex_MemRead) //(id,ex,ex_aluout)
			FowardB1=1;
		else if(rt==mem_back &&mem_MemRead)// (id,mem,Data_in)
			FowardB1=3;
		else if(rt==mem_back &&mem_RegWrite)//(ex,mem,mem_aluout)
			FowardB1=2;
		else
			FowardB1=0;
  end

endmodule
