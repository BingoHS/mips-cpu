`include "Define.v"

module ctrl(clk,rst,OP,Funct,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,EXTOp,ALUOp,RegDst,JumpR,MemRead);
            input clk;
            input rst;
            input [5:0] OP;
            input [5:0] Funct;    
            output reg ALUSrc; //rt/立即数
            output reg [1:0]MemtoReg;//写回内容：aluout/memdata
            output reg RegWrite; 
            output reg MemWrite;
            output reg Branch;
            output reg Jump;
            output reg [1:0] EXTOp;
            output reg [3:0] ALUOp;
            output reg [1:0]RegDst; //写回什么寄存器 0rd 1rt
				output reg JumpR;
				output reg MemRead;
          
/*            initial
            begin
            ALUSrc=0;
            RegWrite=0;
            MemtoReg=0;
            MemWrite=0;
            MemRead=0;
            Branch=0;
            RBranch=0;
            Jump=0;
            EXTOp=0;
            ALUOp=0;
            RegDst=0;
            end */
            
            always@(OP or Funct)
            begin
              ALUSrc=0;
              RegWrite=0;
              MemtoReg=0;
              MemWrite=0;
              Branch=0;
              Jump=0;
              EXTOp=0;
              ALUOp=0;
              RegDst=0;
				  JumpR=0;
				  MemRead=0;
				  
				  case(OP)
					  `OP_LW:  //lw
					  begin
						 EXTOp=1;
						 RegDst=1;
						 ALUSrc=1;
						 MemtoReg=1;
						 RegWrite=1;
						 MemRead=1;
					  end
					  `OP_SW:  //sw
					  begin
						 EXTOp=1;
						 ALUSrc=1;
						 MemWrite=1;
					  end
					  `OP_BEQ:  //beq
					  begin
						 EXTOp=1;
						 Branch=1;
						 ALUOp=1;
					  end
					  `OP_J: //j
					  begin
						Jump=1;
					  end
					  `OP_ADDI:
					  begin
						EXTOp=1;  //sign
						ALUSrc=1; //imm32
						RegWrite=1;
						RegDst=1;
					  end
					  `OP_ANDI:
					  begin    //zero extend
						ALUSrc=1;
						ALUOp=3;
						RegWrite=1;
						RegDst=1;
					  end
					  `OP_ORI:
					  begin
						ALUSrc=1;
						ALUOp=2;
						RegWrite=1;
						RegDst=1;
					  end
					  `OP_LUI:
					  begin
						ALUSrc=1;
						ALUOp=7;
						EXTOp=2;
						RegWrite=1;
						RegDst=1;
					  end
					  `OP_BNE:
					  begin
						Branch=1;
						ALUOp=8;
						EXTOp=1;
					  end
					  `OP_SLTI:
					  begin
						ALUOp=4;
						ALUSrc=1;
						EXTOp=1;
						RegWrite=1;
						RegDst=1;
					  end
					  `OP_JAL:
					  begin
						Jump=1;
						RegWrite=1;
						RegDst=2; //reg31
						MemtoReg=2; //pc+4
					  end
					  `OP_R: //r
					  begin
						 RegWrite=1;
						 case(Funct)
							`FUNC_ADD: ALUOp=0;
							`FUNC_OR:  ALUOp=2;
							`FUNC_NOR: ALUOp=5;
							`FUNC_AND: ALUOp=3;
							`FUNC_SLT: ALUOp=4;
							`FUNC_SUB: ALUOp=1;
							`FUNC_SRL: ALUOp=6;		
							`FUNC_JR:begin
										 RegWrite=0;
										 Jump=1;
										 JumpR=1;
										end
							`FUNC_JALR:begin
										    Jump=1;
											 JumpR=1;
											 MemtoReg=2;//pc+4
										  end
						 endcase	
					  end
				endcase
            end
endmodule
                    
                      
                      
                      
                      
                    
                    
                  
            
            
            
            
            
            
            
            
            
            
            
            
            
            