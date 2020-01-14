
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:03:04 03/31/2019 
// Design Name: 
// Module Name:    mips 
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
module mips(clk,reset,MIO_ready,inst_in,Data_in,DMWr,PC_out,Addr_out,Data_out,CPU_MIO,INT);
				input clk;// 			
				input reset; //
				input MIO_ready; //不用
				input [31:0]inst_in; //指令的输入
				input [31:0]Data_in; //	内存中读到的数据mem from dm				
				output DMWr; //内存写使能
				output[31:0]PC_out; //pc的输出
				output[31:0]Addr_out; //写回/读取内存的地址 ALUout
				output[31:0]Data_out; //写回内存的数据 rt_out
				output [31:0]CPU_MIO; //不用
				input INT;//不用
				
				wire[31:0]dmout; //dm输出
			   wire [5:0] OP;
			   wire [4:0] rs;
				wire [4:0] rt;
				wire [4:0] rd;
		      wire [15:0] Imm16;
				wire [31:0]Imm32;
		      wire [5:0] Funct;
				wire [25:0] addr;
				wire [4:0]shamt;
				assign dmout=Data_in;
				assign OP=inst_in[31:26]; //分线路
			   assign rs=inst_in[25:21];
			   assign rt=inst_in[20:16];
			   assign rd=inst_in[15:11];
			   assign Imm16=inst_in[15:0];
				assign shamt=inst_in[10:6];
			   assign Funct=inst_in[5:0];
			   assign addr=inst_in[25:0];
				
				wire[31:0]aluout;
				wire Zero;
				wire Branch;
            wire Jump;
				wire JumpR;
				wire[31:0]pc;
				wire[31:0]pcp4;
				wire[31:0]npc;
				wire [31:0]rs_out;
				assign PC_out=pc;
				assign pcp4=pc+4;
				pc my_pc(clk,reset,npc,pc);
				npc my_npc(pc,Imm32,addr,npc,Branch,Zero,Jump,JumpR,rs_out);
				
				wire ALUSrc; //rt/立即数
            wire [1:0]MemtoReg;//写回内容：aluout/memdata/PC+4
            wire RegWrite; 
            wire MemWrite;
            wire [1:0] EXTOp;
            wire [3:0] ALUOp;
            wire  [1:0]RegDst; //写回什么寄存器 0rd 1rt 2:31
				assign DMWr=MemWrite;
				ctrl my_ctrl(clk,reset,OP,Funct,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,EXTOp,ALUOp,RegDst,JumpR);
				

            wire [31:0]rt_out;
            wire [31:0] asd;
				wire[4:0]back;
				wire [31:0]WD;
				assign Data_out=rt_out;
				mux #(4,2,5) rfback(RegDst,back,rd,rt,{5'b11111});
				mux #(4,2,32) rfwd(MemtoReg,WD,aluout,dmout,pcp4);
				RF my_rf(rs, rt, back, WD, RegWrite, clk, rs_out,rt_out, reset, asd);
				
				
				
				EXT my_ext(Imm16, EXTOp, Imm32);
				
				
				assign Addr_out=aluout;
				wire [31:0]B;
				mux #(2,1,32) alub(ALUSrc, B,rt_out, Imm32);
				alu my_alu(aluout,Zero,rs_out,B,ALUOp,shamt);
				


endmodule
