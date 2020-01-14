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
module Foward1(FowardA1,FowardB1,rs,rt,wb_back,wb_RegWrite,wb_MemRead
    );
	 output reg[1:0]FowardA1;
	 output reg[1:0]FowardB1;
	 input[4:0]rs;
	 input [4:0]rt;
	 input [4:0]wb_back;
	 input wb_RegWrite,wb_MemRead;
	 
	 always@(*)
	 begin
		if(wb_RegWrite && rs==wb_back)
			FowardA1=1;
		else if(wb_MemRead &&rs==wb_back)
			FowardA1=2;
		else
			FowardA1=0;
			
		if(wb_RegWrite && rt==wb_back)
			FowardB1=1;
		else if(wb_MemRead &&rt==wb_back)
			FowardB1=2;
		else
			FowardB1=0;
	 end


endmodule
