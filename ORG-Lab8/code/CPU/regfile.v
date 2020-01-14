 module regfile(ra0_i,ra1_i,wa_i,wd_i,we,rd0_o,rd1_o,clk);
	input clk;
	input we;
	input [4:0] ra0_i,ra1_i,wa_i;
	input [31:0] wd_i;
	
	output [31:0] rd0_o,rd1_o;
	
	
	reg [31:0] regs[31:0];
/*	integer x;
	
	initial
	begin
	  for(x=0;x<32;x=x+1)
	    regs[x]<=0;
	end */
	
	  
	
	always@(posedge clk)
	begin
		if(we == 1)
			regs[wa_i] <= wd_i;
	end
	assign rd0_o = regs[ra0_i];
	assign rd1_o = regs[ra1_i];
	
endmodule  
