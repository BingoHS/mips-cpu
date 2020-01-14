 module mips_tb();
    
   reg clk, rst_n;
    
   mips U_MIPS(
      .clk(clk), .reset(rst_n)
   );
    
   initial begin
      $readmemh( "code.txt" , U_MIPS.my_im.IMem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_MIPS.my_pc.pc, U_MIPS.inst_in ); 
      clk = 1 ;
      rst_n = 0 ;
      #5 ;
      rst_n = 1 ;
      #20 ;
      rst_n = 0 ;

   end
   
   always
	   #(50) clk = ~clk; 
   
endmodule

