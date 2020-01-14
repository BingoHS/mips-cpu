module int_dect(cause1,inta,pcint,op,funct,sta);
  output reg[3:0]cause1;
  output reg inta;
  output reg pcint;
  input [5:0]op;
  input [5:0]funct;
  input [31:0]sta;
  
  always@(*)
  begin
    cause1=0;
    inta=0;
    pcint=0;
    if(op==0 && funct==6'b1100 && sta[1])//syscall 
    begin
      inta=1;  //only syscall and int
      cause1=4'b0100;
      pcint=1;
    end else if(op==0 && funct==13 &&sta[2]) //not a instruction
    begin
      cause1=4'b1000;  
      pcint=1;
      inta=1;  
    end
  end
  
endmodule
