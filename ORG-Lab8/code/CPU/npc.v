`include "define.v"
module npc(pc_i,aluout_i,alu_result_i,target_i,rs_i,PCSel,npc_o,op,Zero); 
  
  input [31:0] pc_i;
  input [31:0] aluout_i; //pc+4
  input [31:0] alu_result_i; //branch
  input [25:0] target_i; //j jal
  input [31:0] rs_i; //jr jalr
  input [1:0] PCSel;
  output reg [31:0] npc_o;
  input [5:0] op;
  input Zero;
  

  always@(pc_i or aluout_i or alu_result_i or target_i or rs_i or PCSel or op or Zero)
  begin
    case(PCSel)
      0: 
      npc_o=alu_result_i; //pc+4
      
      1:
      begin
          if(op==`BNEOP)  // branch
            npc_o=(Zero==1)? pc_i : aluout_i;
          else
            npc_o=(Zero==1)?aluout_i: pc_i;          
      end 
      
      2:
      npc_o={pc_i[31:28],target_i[25:0],2'b0};  //j jal 
      
      3:
      npc_o=rs_i;  //jr jalr
    endcase
  end
endmodule
  
  
  
  
  
  

