module im_4k(addr,dout);
  input [11:2] addr;
  output reg[31:0] dout;
  
 	reg [31:0]  IMem[1023:0];
	
	always@(addr)
	begin
		dout = IMem[addr];	
	end
	
endmodule
  
