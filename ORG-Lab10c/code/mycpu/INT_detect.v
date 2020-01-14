module INT_detect(cause3,inta3,pcint3,mem_cause,mem_inta,mem_pcint,INT,sta);
  output reg[3:0]cause3;
  output reg inta3;  //?INT?syscall????????
  output reg pcint3; //?????????
  input [3:0]mem_cause;
  input mem_inta;
  input mem_pcint;  
  input INT;
  input [31:0]sta;
  
  always@(*)
  begin
    cause3=mem_cause;
    inta3=mem_inta;
    pcint3=mem_pcint;
    if(INT &&sta[0])
    begin
      cause3=4'b0;
      inta3=1;
      pcint3=1;
    end
  end
endmodule
      
    