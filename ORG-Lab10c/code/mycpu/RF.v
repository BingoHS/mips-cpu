
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:53 03/31/2019 
// Design Name: 
// Module Name:    RF 
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
module RF(rs, rt, back, WD, RFWr, clk, RD1, RD2, rst);
  input [4:0]rs;
  input [4:0]rt;
  input [4:0]back;
  input [31:0]WD;
  input RFWr;
  input clk;
  input rst;
  output  [31:0]RD1;
  output  [31:0]RD2;
  reg[5:0] i;
  reg [31:0] regs [0:31];
  
  initial
  begin
    for(i=0;i<32;i=i+1)
    begin
      regs[i]=32'b0;
    end  
  end
  /*always @(rs or rt or regs[rs] or regs[rt])
  begin
    RD1<=regs[rs];
    RD2<=regs[rt];
  end*/ 
  assign RD1=regs[rs];
  assign RD2=regs[rt];

  always @(negedge clk)
  begin
  if (RFWr)
    regs[back]=WD;
  end
endmodule
