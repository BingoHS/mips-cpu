module flopr1(clk,d,q);
  parameter width=32; 
  input clk;
  input [width-1:0] d;
  output reg [width-1:0] q;
  initial
  begin
    q<=0;
  end
  
  always@(posedge clk)
  begin
      q <=d;
  end
    
  endmodule
