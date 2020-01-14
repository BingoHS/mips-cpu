module pc(clk,rst_n,pc_in,pc_o,PCWrite); 

	input   clk;
	input   rst_n;
	input   [31:0] pc_in;
	output reg[31:0] pc_o;
	input PCWrite;
	
	
	/*always@(posedge clk)
	begin
		if(PCWrite)
		  pc_o <=pc_in;		  
	end
	
	always@(negedge rst_n)
	begin
	  if(!rst_n)
	    pc_o<=32'h0000_3000;
	end*/
	always@(posedge clk or posedge rst_n)
	begin
		if(rst_n)
			pc_o<=32'h0000_3000;
		else if(PCWrite)
			pc_o<=pc_in;
	end
endmodule
	
    