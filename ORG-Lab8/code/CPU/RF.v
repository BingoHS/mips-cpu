
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
module RF(rs, rt, back, WD, RFWr, clk, RD1, RD2, rst, asd);
  input [4:0]rs;
  input [4:0]rt;
  input [4:0]back;
  input [31:0]WD;
  input RFWr;
  input clk;
  input rst;
  output reg [31:0]RD1;
  output reg [31:0]RD2;
  reg[5:0] i;
  reg [31:0] regs [0:31];
  output wire [31:0] asd;
  

  always @(rs or rt or regs[rs] or regs[rt])
  begin
    RD1<=regs[rs];
    RD2<=regs[rt];
  end

  always @(posedge clk)
  begin
  if (RFWr)
    regs[back]=WD;
  end
endmodule
