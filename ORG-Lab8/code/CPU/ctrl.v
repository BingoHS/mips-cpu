`include "define.v"
module ctrl(clk,op,funct,Zero,
            ALUOp,ALUSrcA,ALUSrcB,EXTOp,
            RegWrite,RegDst,RegSource,
            PCWrite,PCSel,
            DMWrite,DMSource,Be_high,
            IRWrite,rst);
  
  input clk;
  reg [3:0] status;
  reg [2:0] group; // 0:R 1:memory insruction 2:branch 3:jump
  input [5:0] op;
  input [5:0] funct; 
  input Zero;
  
  output reg [4:0] ALUOp;
  output reg[1:0] ALUSrcA;
  output reg [1:0] ALUSrcB;
  output reg [1:0] EXTOp;
  
  output reg RegWrite;
  output reg [1:0] RegDst;
  output reg [1:0] RegSource;
  
  output reg PCWrite;
  output reg [1:0] PCSel;
  
  output reg DMWrite;
  output reg [1:0] DMSource;
  
  output reg [1:0] Be_high;
  output reg IRWrite;  
  input rst;
  
  /*initial
  begin
    status =9;
    RegWrite =0;
    PCWrite =0;
    DMWrite =0;
    IRWrite =0;
  end*/
  
  always@(negedge clk or posedge rst)
  begin
  if(rst)
	begin
	 status =9;
	end
	
	else 
   begin
		if(status==1)
		 begin
		  //divide into 4 group, be careful that jalr and jr's op is 0,and imme instruction's op isn't 0
		  
			if(op==`ROP)   
			begin
			  if(funct==`JALRFUNCT ||funct==`JRFUNCT)
				 group=3;
			  else
				 group=0;
			end
			else if(op==`LWOP || op==`LBOP || op==`LBUOP || op==`LHOP || op==`LHUOP || op==`SWOP || op==`SBOP || op==`SHOP)
			 group=1;
			else if(op==`BEQOP || op==`BGEZOP || op==`BGTZOP || op==`BLEZOP || op==`BLTZOP || op==`BNEOP)
			 group=2;
			else if(op==`JOP || op==`JALOP)
			 group=3;
			else
			 group=0; //addi addiu andi ori xori lui slti sltiu
		 end
			
		 if(status==9)
			status=0;
		 else if(status==0)
			status=1;
		 else if(status==1)
			begin
			  case(group)
				0:
				status=2;
				1:
				status=3;
				2:
				status=4;
				3:
				status=5;
			  endcase
			end
		 else if(status==2)
			status=6;
		 else if(status==3)
			status=7;
		 else if(status==4)
			status=0;
		 else if(status==5)
			status=0;
		 else if(status==6)
			status=0;
		 else if(status==7)
			begin
			  if(op==`SWOP||op==`SHOP||op==`SBOP)
				 status=0;
			  else
				 status=8;
			end
		 else
			status=0;
		end
	  	 
		
  end

      
  always@(posedge clk)
  begin
    RegWrite =0;
    PCWrite =0;
    DMWrite =0;
    IRWrite =0;
    
    case(status)
      0:         //Instruction Fetch  
      begin
        IRWrite=1;
        PCWrite=1;
        PCSel=0;
        ALUOp=0;
        ALUSrcA=1;
        ALUSrcB=1;
      end
      
      1:            //Instruction Decode
      begin
        ALUOp=0;
        ALUSrcA=1;
        ALUSrcB=2;
        EXTOp=1;
        
      end
      
      2:
      begin
        ALUSrcA=0;
        ALUSrcB=0;
        
        if(op==0&&(funct==`SLLFUNCT ||funct==`SRAFUNCT ||funct==`SRLFUNCT))
          ALUSrcA=2;
        if(op==`ADDIOP ||op==`ADDIUOP ||op==`ANDIOP ||op==`ORIOP ||op==`XORIOP ||op==`LUIOP ||op==`SLTIOP ||op==`SLTIUOP)
          ALUSrcB=3;
        if( op==`ANDIOP ||op==`ORIOP ||op==`XORIOP ||op==`LUIOP)
          EXTOp=0;
        else if(op==`ADDIOP ||op==`SLTIOP ||op==`ADDIUOP ||op==`SLTIUOP)
          EXTOp=1;
        else
          EXTOp=2;
        
        if(op!=`ROP)
          begin
            if(op==`ADDIOP ||op==`ADDIUOP)
              ALUOp=0;
            else if(op==`ANDIOP)
              ALUOp=2;
            else if(op==`ORIOP)
              ALUOp=3;
            else if(op==`XORIOP)
              ALUOp=4;
            else if(op==`SLTIUOP)
              ALUOp=13;
            else if(op==`SLTIOP)
              ALUOp=14;
            else
              ALUOp=12;
          end
        else
          begin
            if(funct==`ADDFUNCT ||funct==`ADDUFUNCT)
              ALUOp=0;
            else if(funct==`SUBFUNCT||funct==`SUBUFUNCT)
              ALUOp=1;
            else if(funct==`ANDFUNCT)
              ALUOp=2;
            else if(funct==`ORFUNCT)
              ALUOp=3;
            else if(funct==`XORFUNCT)
              ALUOp=4;
            else if(funct==`NORFUNCT)
              ALUOp=5;
            else if(funct==`SLLFUNCT)
              ALUOp=6;
            else if(funct==`SRLFUNCT)
              ALUOp=7;
            else if(funct==`SRAFUNCT)
              ALUOp=8;
            else if(funct==`SLTUFUNCT)
              ALUOp=13;
            else if(funct==`SLTFUNCT)
              ALUOp=14;
            else if(funct==`SLLVFUNCT)
              ALUOp=15;
            else if(funct==`SRLVFUNCT)
              ALUOp=16;
            else if(funct==`SRAVFUNCT)
              ALUOp=17;
          end 
      end
      
      3:
      begin
        ALUOp=0;
        ALUSrcB=3;
        ALUSrcA=0;
        EXTOp=1;
      end
      
      4:          //Branch Completion!!!!!
      begin
        PCWrite=1;
        PCSel=1;
        ALUSrcA=0;
        ALUSrcB=0;
        if(op==`BEQOP || op==`BNEOP)
          ALUOp=1;
        else if(op==`BGEZOP || op==`BLTZOP)
          ALUOp=9;
        else if(op==`BLEZOP)
          ALUOp=11;
      end
        
      5:     //jump completion
      begin
        PCWrite=1;
        if(op==`JOP || op==`JALOP) //jump addr
          PCSel=2;
        else  //jump reg
          PCSel=3;
        
        if(op==0)
          begin
            if(funct==`JALRFUNCT)
            begin
              RegSource=2;
              RegDst=1;
              RegWrite=1;
            end
          end
        else if(op==`JALOP)
          begin
            RegSource=2;
            RegDst=2;
            RegWrite=1;
          end      
      end
      
      6:      //R type and imme instruction completion
      begin
        RegDst=(op==0)?2'b1:2'b0;
        RegWrite=1;
        RegSource=0;
      end
      7:
      begin
        if(op==`SWOP)
          begin
            DMWrite=1;
            DMSource=0;
            Be_high=0;
          end
        else if(op==`SHOP)
          begin
            DMWrite=1;
            DMSource=1;
            Be_high=2;
          end
        else if(op==`SBOP)
          begin
            DMWrite=1;
            DMSource=2;
            Be_high=1;
          end
        else if(op==`LWOP)
          begin
            Be_high=0;
          end
          
        else if(op==`LBOP || op==`LBUOP)
          begin
            Be_high=1;
          end
        else if(op==`LHOP || op==`LHUOP)
          begin
            Be_high=2;
          end
      end
      
      8:
      begin
        RegWrite=1;
        RegSource=1;
        RegDst=0;
      end
      endcase

  end    
endmodule  
      

      
      
      
      
      
      
      
       