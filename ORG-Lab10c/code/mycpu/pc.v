
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:53:28 03/31/2019 
// Design Name: 
// Module Name:    pc 
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
module pc(clk,rst,npc,pc,sto);
	input clk;
	input rst;
	input [31:0]npc;
	output reg[31:0]pc;
	input sto;
	
	initial
	begin
	pc=32'h0000_3000;
	end
	
	//always@(posedge clk or posedge rst)
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			pc=32'h0000_3000;
		end
		else if(sto)
		begin 
			pc=pc;
		end
		else
		begin
		  pc=npc;
		end 
	end


endmodule
