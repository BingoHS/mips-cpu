
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
				input [31:0]inst_in; //指令的输入 done
				input [31:0]Data_in; //	内存中读到的数据mem from dm	done			
				output DMWr; //内存写使能 done 
  				output[31:0]PC_out; //pc的输出 
				output[31:0]Addr_out; //写回/读取内存的地址 ALUout  done
				output[31:0]Data_out; //写回内存的数据 rt_out done
				output [31:0]CPU_MIO; //不用
				input INT;//不用   
				
				wire[31:0]dmout; //dm输出,在这里作为wb阶段的Data_in 
			  wire [5:0] OP;
			  wire [4:0] rs;
				wire [4:0] rt;
				wire [4:0] ex_rs;
				wire [4:0] ex_rt;
				
				wire [4:0] rd;
				wire [4:0] ex_rd;
				wire [4:0] mem_rd;
				wire  [4:0]wb_rd;
				wire [15:0] Imm16;
				wire [31:0]Imm32;
				wire [31:0]ex_Imm32;
				wire [5:0] Funct;
				wire [25:0] addr;
				wire [4:0]shamt;
				wire [31:0]id_inst;
				//wire [31:0]Data_in;
				
				flopr #(5)f_ex_rs(clk,reset,rs,ex_rs);
				flopr #(5)f_ex_rt(clk,reset,rt,ex_rt);
				flopr #(5)f_ex_rd(clk,reset,rd,ex_rd);
				flopr #(5)f_mem_rd(clk,reset,ex_rd,mem_rd);
				flopr #(5)f_wb_rd(clk,reset,mem_rd,wb_rd);
				//assign dmout=Data_in;
				flopr f_dmout(clk,reset,Data_in,dmout);
				flopr f_ex_Imm32(clk,reset,Imm32,ex_Imm32);
				assign OP=id_inst[31:26]; //分线路
			   assign rs=id_inst[25:21];
			   assign rt=id_inst[20:16];
			   assign rd=id_inst[15:11];
			   assign Imm16=id_inst[15:0];
				assign shamt=id_inst[10:6];
			   assign Funct=id_inst[5:0];
			   assign addr=id_inst[25:0];
				

				
				
				wire[31:0]aluout;
				wire Zero;
				wire equ;
				wire Branch;
        wire Jump;
				wire JumpR;
				wire[31:0]pc;
				wire[31:0]id_pc;
				wire[31:0]ex_pc;
			   wire[31:0]mem_pc;
				wire[31:0]wb_pc;
				wire[31:0]npc;
				wire [31:0]rs_out;
				wire stall;
				wire sto;
				//wire [31:0]inst_in;
				
				wire mtc,mfc,eret,ex_mtc,ex_mfc,mem_mtc,mem_mfc,ex_eret,mem_eret,wb_mfc,wb_mtc;
				wire pcint3;
				stop stop(sto,inst_in,id_inst);
				
				assign stall=Branch|Jump|sto|eret|pcint3;
				assign PC_out=pc;
				
				
				floprs #(32) f_id_inst(clk,stall,inst_in,id_inst);
				
				pc my_pc(clk,reset,npc,pc,sto);
				
				
				flopr f_id_pc(clk,reset,pc,id_pc);
				flopr f_ex_pc(clk,reset,id_pc,ex_pc);
				flopr f_mem_pc(clk,reset,ex_pc,mem_pc);
				flopr f_wb_pc(clk,reset,mem_pc,wb_pc);
				
				wire [11:2]addr_i;
				assign addr_i=pc[11:2];
				
//				IM my_im(addr_i,inst_in);
				
				wire ALUSrc; //rt/立即数
            wire [1:0]MemtoReg;//写回内容：aluout/memdata/PC+4
            wire RegWrite;
				wire ex_RegWrite;
				wire mem_RegWrite;
				wire wb_RegWrite;
            wire MemWrite;
				wire ex_MemWrite;
				wire mem_MemWrite;
            wire [1:0] EXTOp;
            wire [3:0] ALUOp;
            wire  [1:0]RegDst; //写回什么寄存器 0rd 1rt 2:31
				wire  [1:0]ex_RegDst;
				wire  [1:0]mem_RegDst;
				wire  [1:0]wb_RegDst;
				
				wire MemRead;
				wire ex_MemRead;
				wire mem_MemRead;
				wire wb_MemRead;

				
				floprs #(1) f_ex_RegWrite(clk,pcint3,RegWrite,ex_RegWrite);    //RegWrite
				floprs #(1) f_mem_RegWrite(clk,reset,ex_RegWrite,mem_RegWrite);
				flopr #(1) f_wb_RegWrite(clk,reset,mem_RegWrite,wb_RegWrite);
				
				flopr #(2) f_ex_RegDst(clk,reset,RegDst,ex_RegDst);
				flopr #(2) f_mem_RegDst(clk,reset,ex_RegDst,mem_RegDst);
				flopr #(2) f_wb_RegDst(clk,reset,mem_RegDst,wb_RegDst);
				
				floprs #(1) f_ex_MemWrite(clk,pcint3,MemWrite,ex_MemWrite);    //MemWrite
				floprs #(1) f_mem_MemWrite(clk,pcint3,ex_MemWrite,mem_MemWrite);
				assign DMWr=mem_MemWrite;
				
				flopr #(1) f_ex_MemRead(clk,reset,MemRead,ex_MemRead);
				flopr #(1) f_mem_MemRead(clk,reset,ex_MemRead,mem_MemRead);
				flopr #(1) f_wb_MemRead(clk,reset,mem_MemRead,wb_MemRead);
				
				
				ctrl my_ctrl(clk,reset,OP,Funct,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,EXTOp,ALUOp,RegDst,JumpR,MemRead,mtc,mfc,eret,rs);
				flopr #(1) f_ex_mtc(clk,reset,mtc,ex_mtc);
				flopr #(1) f_ex_mfc(clk,reset,mfc,ex_mfc);
				flopr #(1) f_ex_eret(clk,reset,eret,ex_eret);
				flopr #(1) f_mem_mtc(clk,reset,ex_mtc,mem_mtc);
				flopr #(1) f_mem_mfc(clk,reset,ex_mfc,mem_mfc);
				flopr #(1) f_mem_eret(clk,reset,ex_eret,mem_eret);
				flopr #(1) f_wb_mtc(clk,reset,mem_mtc,wb_mtc);
				flopr #(1) f_wb_mfc(clk,reset,mem_mfc,wb_mfc);

        wire [31:0]rt_out;
				wire [31:0]ex_rt_out;
				wire [31:0]mem_rt_out;
				
            wire [31:0] asd;
				
				wire[4:0]back;
				wire[4:0]ex_back;
				wire[4:0]mem_back;
				wire[4:0]wb_back;
				
				wire[1:0]ex_MemtoReg;
				wire[1:0]mem_MemtoReg;
				wire[1:0]wb_MemtoReg;
				wire [31:0]WD;
				wire [4:0] num31;
				reg [4:0]reg31;
				
				always@(posedge reset)
				begin
					reg31=5'b11111;
				end
				assign num31=reg31;
				assign Data_out=mem_rt_out;
				mux #(4,2,5) rfback(RegDst,back,rd,rt,num31);
				flopr #(5) f_ex_back(clk,reset,back,ex_back);
				flopr #(5) f_mem_back(clk,reset,ex_back,mem_back);
				flopr #(5) f_wb_back(clk,reset,mem_back,wb_back);  //wb时用到写回的寄存器号
				wire [31:0]ex_rt_real;//经过旁路选择的ex_rt_out
				flopr f_mem_rt_out(clk,reset,ex_rt_real,mem_rt_out);
				
				flopr #(2) f_ex_MemtoReg(clk,reset,MemtoReg,ex_MemtoReg);
				flopr #(2) f_mem_MemtoReg(clk,reset,ex_MemtoReg,mem_MemtoReg);
				flopr #(2) f_wb_MemtoReg(clk,reset,mem_MemtoReg,wb_MemtoReg);
				wire [31:0]wb_aluout;
				wire [31:0]jalpc;
				wire [31:0]mem_jalpc;
				assign mem_jalpc=mem_pc+32'd4;
				assign jalpc=wb_pc+32'd4;
				mux #(4,2,32) rfwd(wb_MemtoReg,WD,wb_aluout,dmout,jalpc);
				RF my_rf(rs, rt, wb_back, WD,wb_RegWrite, clk, rs_out,rt_out, reset);
				
				
				
				
				EXT my_ext(Imm16, EXTOp, Imm32);
				
				
				wire [31:0]mem_aluout;
//				wire [31:0]wb_aluout; 
				assign Addr_out=mem_aluout; //aluout到mem阶段给dm当作地址
				wire [31:0]B;    //放在ex阶段

				wire [31:0]rs_real; //经过旁路选择后的rs_out值，请记得
				wire [31:0]rt_real; //经过旁路选择的rt_out值，请记得
				wire [31:0]ex_rs_out; 
//				wire [31:0]ex_rt_out; //定义了
				wire [31:0]ex_rs_real;//经过旁路选择的ex_rs_out 
				 
				
				wire [3:0]ex_ALUOp;
				wire [4:0]ex_shamt;
				
				wire [2:0]FowardA1;
				wire [1:0]FowardB1;
				wire[2:0]FowardA2;
				wire [2:0]FowardB2;
				wire ex_ALUSrc;
				
				flopr #(1)f_ex_ALUSrc(clk,reset,ALUSrc,ex_ALUSrc);
				
				wire [31:0]epc;
				npc my_npc(pc,Imm32,addr,npc,Branch,equ,Jump,JumpR,rs_real,id_pc,eret,pcint3,epc);
				
				equal equal(rs_real,rt_real,OP,equ); 
						
				Foward1 Foward1(FowardA1,FowardB1,rs,rt,ex_back,ex_RegWrite,ex_MemRead,mem_back,mem_RegWrite,mem_MemRead); //旁路的rs,rt
				Foward2 Foward2(FowardA2,FowardB2,ex_rs,ex_rt,mem_back,wb_back,mem_RegWrite,wb_RegWrite,wb_MemRead,mem_MemRead);
				mux #(8,3,32) rs_real_sel(FowardA1,rs_real,rs_out,aluout,mem_aluout,Data_in,mem_jalpc);
				mux #(4,2,32) rt_real_sel(FowardB1,rt_real,rt_out,aluout,mem_aluout,Data_in);   
				mux #(8,3,32) ex_rs_real_sel(FowardA2,ex_rs_real,ex_rs_out,mem_aluout,wb_aluout,dmout,Data_in);
				mux #(8,3,32) ex_rt_real_sel(FowardB2,ex_rt_real,ex_rt_out,mem_aluout,wb_aluout,dmout,Data_in);
				flopr f_ex_rt_out(clk,reset,rt_real,ex_rt_out); 
				flopr f_ex_rs_out(clk,reset,rs_real,ex_rs_out);//alu第一个
				
				flopr #(4)f_ex_ALUOp(clk,reset,ALUOp,ex_ALUOp);
				flopr #(5) f_ex_shamt(clk,reset,shamt,ex_shamt);
				
				flopr f_mem_aluout(clk,reset,aluout,mem_aluout);
				flopr f_wb_aluout(clk,reset,mem_aluout,wb_aluout);
				
				mux #(2,1,32) alub(ex_ALUSrc, B,ex_rt_real, ex_Imm32); //real!
				wire ov;
				wire [31:0]aluout1;
				wire [31:0]cp0_out;
				alu my_alu(aluout1,Zero,ex_rs_real,B,ex_ALUOp,ex_shamt,ov);  //real!
				mux #(2,1,32) aluout_s(ex_mfc,aluout,aluout1,cp0_out);
				
//				DM my_dm(Data_in,mem_aluout[11:2],mem_rt_out,mem_MemWrite,clk,mem_MemRead);
				
				
				wire [31:0]sta;
				wire [31:0]cau;
				
				wire [3:0]cause1;
				wire inta;
				wire pcint;
				int_dect int_dect(cause1,inta,pcint,OP,Funct,sta);
				wire [3:0]ex_cause;
				wire ex_inta;
				wire ex_pcint;
				flopr #(4) f_ex_cause(clk,reset,cause1,ex_cause);
				flopr #(1) f_ex_inta(clk,reset,inta,ex_inta);
				flopr #(1) f_ex_pcint(clk,reset,pcint,ex_pcint);
				wire [3:0]cause2;
				wire inta2;
				wire pcint2;
				wire inta3;
				ov_dect ov_dect(cause2,inta2,pcint2,ex_cause,ex_inta,ex_pcint,ov,sta,inta3);
				wire [3:0]mem_cause;
				wire mem_inta;
				wire mem_pcint;
			  flopr #(4) f_mem_cause(clk,reset,cause2,mem_cause);
				flopr #(1) f_mem_inta(clk,reset,inta2,mem_inta);
				flopr #(1) f_mem_pcint(clk,reset,pcint2,mem_pcint);
				wire [3:0]cause3;
				
				
				INT_detect INT_detect(cause3,inta3,pcint3,mem_cause,mem_inta,mem_pcint,INT,sta);
				
				

				CP0 my_cp0(clk,wb_rd,ex_rd,wb_aluout,cp0_out,wb_mtc,eret,mem_pc,inta3,cause3,sta,cau,epc);


endmodule
