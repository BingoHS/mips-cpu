/*`include "mux.v"
`include "flopr.v"
`include "flopr1.v"*/
`include "define.v"
/*`include "alu.v"
`include "ext.v"
`include "regfile.v"
`include "pc.v"
`include "npc.v"
`include "dm_adjust.v"
`include "ctrl.v"
`include "dm_input_sel.v"*/

module mips(clk,rst_n,MIO_ready,inst_in,Data_in,mem_w,PC_out,Addr_out,Data_out,CPU_MIO,INT);
  input clk;
  input rst_n;
  input MIO_ready; //不用
  input [31:0]inst_in; //指令的输入 done
  input [31:0]Data_in; //	内存中读到的数据mem from dm done				
  output mem_w; //内存写使能 done
  output[31:0]PC_out; //pc的输出 done
  output[31:0]Addr_out; //写回/读取内存的地址 ALUout done
  output[31:0]Data_out; //写回内存的数据 rt_out done
  output [31:0]CPU_MIO; //不用
  input INT;//不用 
  //////////////////////////here are wires////////////////////////////////////
  //ctrl
  wire [4:0] ALUOp;
  wire [1:0] ALUSrcA;
  wire [1:0] ALUSrcB;
  wire [1:0] EXTOp;
  wire RegWrite;
  wire [1:0] RegDst;
  wire [1:0] RegSource;
  wire PCWrite;
  wire [1:0] PCSel;
  wire DMWrite;
  wire [1:0] DMSource;
  wire [1:0] Be_high;
  wire IRWrite;
  
  //pc npc
  wire [31:0] npc_o;
  wire [31:0] pc_o;
  //IM and IR
  wire [31:0] im_dout;
  wire [31:0] instruction;
  wire [25:0] target;
  wire [5:0] op;
  wire [5:0] funct;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [15:0] offset;
  wire [11:2] im_addr;
  wire [4:0] shamt;
  //DM and MDR
  wire [31:0] dm_dout;
  wire [3:0] be;
  wire [31:0] dm_din;
  wire [31:0] mdr_i;
  wire [31:0] mdr_o;
  wire [11:2] dm_addr; 
  //regfile A B EXT
  wire [4:0] mux1_o;
  wire [31:0] mux2_o;
  wire [4:0] ra;
  wire [4:0] ling4;
  wire [31:0] ling32;
  wire [31:0] A_i;
  wire [31:0] A_o;
  wire [31:0] B_i;
  wire [31:0] B_o;
  wire [31:0] ext1_o;
  wire [31:0] ext2_o;
  //alu
  wire [31:0] four;
  wire [31:0] mux3_o;
  wire [31:0] mux4_o;
  wire [31:0] result_o;
  wire [31:0] aluout_o;
  wire Zero;
  
  assign im_dout=inst_in;
  assign mem_w=DMWrite;
  assign PC_out=pc_o; //PC_out
  assign Addr_out=aluout_o;
  assign Data_out=dm_din;
  assign mdr_i=Data_in;
  /////////////////////////////here are modules////////////////////////////////////////////////
  //ctrl

  ctrl my_ctrl(.clk(clk),.op(op),.funct(funct),.Zero(Zero),
            .ALUOp(ALUOp),.ALUSrcA(ALUSrcA),.ALUSrcB(ALUSrcB),.EXTOp(EXTOp),
            .RegWrite(RegWrite),.RegDst(RegDst),.RegSource(RegSource),
            .PCWrite(PCWrite),.PCSel(PCSel),
            .DMWrite(DMWrite),.DMSource(DMSource),.Be_high(Be_high),
            .IRWrite(IRWrite),.rst(rst_n));
  ////////////////////////////////////////////////////////////////////////////      
  
  //pc and npc
  
  npc my_npc(.pc_i(pc_o),.aluout_i(aluout_o),.alu_result_i(result_o),.target_i(target),.rs_i(A_o),.PCSel(PCSel),.npc_o(npc_o),.op(op),.Zero(Zero));
  pc my_pc(.clk(clk),.rst_n(rst_n),.pc_in(npc_o),.pc_o(pc_o),.PCWrite(PCWrite));
  ///////////////////////////////////////////////////////////////////////////
  
  //IM and IR

  //im_4k my_im(.addr(im_addr),.dout(im_dout));
  flopr IR(.clk(clk),.d(im_dout),.q(instruction),.signal(IRWrite));
  
  assign target=instruction[25:0];
  assign op=instruction[31:26];
  assign funct=instruction[5:0];
  assign rs=instruction[25:21];
  assign rt=instruction[20:16];
  assign rd=instruction[15:11];
  assign offset=instruction[15:0];
  assign im_addr=pc_o[11:2];
  assign shamt= instruction[10:6];
  ////////////////////////////////////////////////////////////////////////////
  
  //DM and MDR
  assign dm_addr=aluout_o[11:2];
  assign be={Be_high[1:0],aluout_o[1:0]};
  
  
  //dm_4k my_dm(.addr(dm_addr),.be(be),.din(dm_din),.DMWr(DMWrite),.clk(clk),.dout(dm_dout));
  //dm_adjust my_dm_adjust(.dout1_i(dm_dout),.dout2_o(mdr_i),.op(op));  
  flopr1 mdr(.clk(clk),.d(mdr_i),.q(mdr_o));
  dm_input_sel my_dm_input_sel(.d(B_o),.q(dm_din),.DMSource(DMSource));
  
  ////////////////////////////////////////////////////////////////////////////
  
  //regfile A B EXT

  assign ra=31;
  assign ling4=0;
  assign ling32=0;
  mux #(4,2,5) mux1(.s(RegDst),.y(mux1_o),.d0(rt),.d1(rd),.d2(ra),.d3(ling4),.d4(ling4),.d5(ling4),.d6(ling4),.d7(ling4),.d8(ling4),.d9(ling4),.d10(ling4),.d11(ling4),.d12(ling4),.d13(ling4),.d14(ling4),.d15(ling4));
  mux #(4,2,32) mux2(.s(RegSource),.y(mux2_o),.d0(aluout_o),.d1(mdr_o),.d2(pc_o),.d3(ling32),.d4(ling32),.d5(ling32),.d6(ling32),.d7(ling32),.d8(ling32),.d9(ling32),.d10(ling32),.d11(ling32),.d12(ling32),.d13(ling32),.d14(ling32),.d15(ling32));
  regfile my_regfile(.ra0_i(rs),.ra1_i(rt),.wa_i(mux1_o),.wd_i(mux2_o),.we(RegWrite),.rd0_o(A_i),.rd1_o(B_i),.clk(clk));
  flopr1 A(.clk(clk),.d(A_i),.q(A_o));
  flopr1 B(.clk(clk),.d(B_i),.q(B_o));
  ext my_ext(.shamt_i(shamt),.imme_i(offset),.EXTOp(EXTOp),.extout_o(ext1_o));
  assign ext2_o=ext1_o<<2;
  //////////////////////////////////////////////////////////////
  
  //alu


  assign four=4;
  mux #(4,2,32) mux3(.s(ALUSrcA),.y(mux3_o),.d0(A_o),.d1(pc_o),.d2(ext1_o),.d3(ling32),.d4(ling32),.d5(ling32),.d6(ling32),.d7(ling32),.d8(ling32),.d9(ling32),.d10(ling32),.d11(ling32),.d12(ling32),.d13(ling32),.d14(ling32),.d15(ling32));
  mux #(4,2,32) mux4(.s(ALUSrcB),.y(mux4_o),.d0(B_o),.d1(four),.d2(ext2_o),.d3(ext1_o),.d4(ling32),.d5(ling32),.d6(ling32),.d7(ling32),.d8(ling32),.d9(ling32),.d10(ling32),.d11(ling32),.d12(ling32),.d13(ling32),.d14(ling32),.d15(ling32));
  alu my_alu(.d0_i(mux3_o),.d1_i(mux4_o),.ALUOp(ALUOp),.result_o(result_o),.zero_o(Zero));
  flopr1 aluout(.clk(clk),.d(result_o),.q(aluout_o));
  //////////////////////////////////////////////////////////////////
  

endmodule
  
  
  
  
  
  
         