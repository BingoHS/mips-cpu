`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:18 04/22/2019 
// Design Name: 
// Module Name:    equal 
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
module equal(rs_out,rt_out,OP,equ
    );
	 input [31:0]rs_out;
	 input [31:0]rt_out;
	 input [5:0]OP;
	 output  equ;
	 
	 assign equ=(OP==5)?((rs_out==rt_out)?(1'b0):(1'b1)):((rs_out==rt_out)?(1'b1):(1'b0)); //OP==5 means it's bne
	 
endmodule
