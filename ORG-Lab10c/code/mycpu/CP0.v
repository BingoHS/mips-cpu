`include "cp0reg.v"
module CP0(clk,waddr,raddr,wdata,data_o,mtc,eret,mem_pc,inta,cause,sta,cau,epc);
  input clk;
  input [4:0]waddr; //mem_rd
  input [4:0]raddr; //ex_rd
  input [31:0]wdata; //wb_aluout
  output reg[31:0]data_o;
  input mtc;
  input eret;
  input [31:0]mem_pc;
  output[31:0]sta;
  output[31:0]cau;
  output[31:0]epc;
  input inta;
  input [3:0]cause;
  
  cp0reg cp0reg(sta,cau,epc,
inta,wdata,mem_pc,{28'b0,cause},waddr,clk,eret,mtc);
  always@(*)
  begin
    case(raddr)
      12:data_o=sta;
      13:data_o=cau;
      14:data_o=epc;
      default:data_o=0;
    endcase
  end
  
endmodule
  
  
  