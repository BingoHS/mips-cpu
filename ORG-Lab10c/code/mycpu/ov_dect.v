module ov_dect(cause2,inta2,pcint2,ex_cause,ex_inta,ex_pcint,ov,sta,inta3);
  output reg[3:0]cause2;
  output reg inta2;
  output reg pcint2;
  input [3:0]ex_cause;
  input ex_inta;
  input ex_pcint;  
  input ov;
  input [31:0]sta;
  input inta3;
  
  always@(*)
  begin
    cause2=ex_cause;
    inta2=ex_inta;
    pcint2=ex_pcint;
    if(ov && sta[3])
    begin
      cause2=4'b1100;
      inta2=1;
      pcint2=1;
    end
    if(inta3)
    begin
      cause2=4'b0000;
      inta2=0;
      pcint2=0;
    end
  end
endmodule