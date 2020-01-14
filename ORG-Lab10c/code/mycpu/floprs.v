`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:35:36 12/26/2016 
// Design Name: 
// Module Name:    floprs 
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
module floprs(clk,stall,d,q
    );
    parameter width=32;
	 input clk;
	 input stall;
	 input [width-1:0]d;
	 output reg[width-1:0]q;
	 
	 always@(posedge clk)
	 begin
		if(stall)
			q=0;
		else
			q=d;
	 end


endmodule
