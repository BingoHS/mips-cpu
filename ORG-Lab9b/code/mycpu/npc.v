
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:35 03/31/2019 
// Design Name: 
// Module Name:    npc 
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
module npc(pc,imme32,target,npc,Branch,equ,Jump,JumpR,rs_real,id_pc
    );
	 input [31:0]pc;
	 input [31:0]imme32;
	 input [25:0]target;
	 input Branch;
	 input equ;
	 input Jump;
	 input JumpR;
	 output [31:0]npc;
	 input [31:0]rs_real;
	 input [31:0]id_pc;
	 
	 //always@(pc or imme32 or target or Branch or Zero or Jump)
	 //begin
	assign npc=Jump?(JumpR ? (rs_real) : ({id_pc[31:28],target[25:0],2'b00}) ):( (Branch) ? ((equ)?(id_pc+4+(imme32<<2)):(id_pc+4)) :(pc+4));
	// end


endmodule
