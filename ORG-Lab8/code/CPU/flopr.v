module flopr(clk,d,q,signal);
  parameter sigwid=1,width=32; 
  input clk;
  input [width-1:0] d;
  output reg [width-1:0] q;
  input [sigwid-1:0]signal;
  initial
  begin
    q<=0;
  end
  
  always@(posedge clk)
  begin
      if(signal==1)
      q <=d;
  end
    
  endmodule
     