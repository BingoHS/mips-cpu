
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
module npc(pc,imme32,target,npc,Branch,equ,Jump,JumpR,rs_real,id_pc,eret,pcint,epc
    );
	 input [31:0]pc;
	 input [31:0]imme32;
	 input [25:0]target;
	 input Branch;
	 input equ;
	 input Jump;
	 input JumpR;
	 output reg[31:0]npc;
	 input [31:0]rs_real;
	 input [31:0]id_pc;
	 input eret;
	 input pcint;
	 input [31:0]epc;
	 
	 //always@(pc or imme32 or target or Branch or Zero or Jump)
	 //begin
//	assign npc=eret?(epc):(pcint ?32'd8:Jump?(JumpR ? (rs_real) : ({id_pc[31:28],target[25:0],2'b00}) ):( (Branch) ? ((equ)?(id_pc+4+(imme32<<2)):(id_pc+4)) :(pc+4)));
	// end
  always@(*)
  begin
    npc=pc+4;
    if(eret)
    begin
      npc=epc;
    end  else if(pcint)
    begin
      npc=32'h00003008;
    end else if(Jump)
    begin
      if(JumpR)
        npc=rs_real;
      else 
        npc={id_pc[31:28],target[25:0],2'b00};
    end else if(Branch)
    begin
      if(equ)
        npc=(id_pc+4+(imme32<<2));
      else
        npc=id_pc+4;
    end
  end

endmodule
