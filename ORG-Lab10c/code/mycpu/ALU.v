//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:22:00 03/31/2019 
// Design Name: 
// Module Name:    ALU 
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
module alu(C,Zero,A,B,ALUOp,shamt,ov);

	input  [31:0] 		A;		//rs内容
	input  [31:0]		B;		//rt内容或扩展后的立即数
	input  [3:0]		ALUOp;
	input [4:0] shamt;
	
	output reg[31:0]		C;		//result
	output 					Zero;			
	output reg ov;
	
	initial								
	begin
		C = 0;
	end	
	assign Zero = (C==32'b0) ? 1'b1 : 1'b0;
	
	always@(A or B or ALUOp or shamt)
	begin
		case (ALUOp)
			0: C=A+B; //add
			1: C=A-B; //sub
			2: C=A|B; //or
			3: C=A&B; //and
			4: C=($signed(A)<$signed(B))?1:0;//slt
			5: C=~(A | B); //nor
			6:	C=B >>> shamt; //srl
			7: C=B; //lui
			8: C=(A==B)?1:0;//bne
		endcase
	end
	
	always@(*)
	begin
	  ov=0;
	   if(ALUOp==0)
	   begin
	     if((!A[31]&&!B[31]&&C[31]) || (A[31]&&B[31]&&!C[31]))
	       ov=1;
	   end  
	   else if(ALUOp==1)
	   begin
	     if((!A[31]&&B[31]&&C[31]) || (A[31]&&!B[31]&&!C[31]))
	       ov=1;
	   end
	end

endmodule
