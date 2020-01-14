module alu(d0_i,d1_i,ALUOp,result_o,zero_o);
  input [31:0] d0_i;
  input [31:0] d1_i;
  input [4:0] ALUOp;
  output reg[31:0] result_o;
  output reg zero_o;
  
  initial
  begin
  result_o=0;
  zero_o=0;
  end
  
  always@(d0_i or d1_i or ALUOp)
  begin
    case(ALUOp)
      0:
      result_o=d0_i+d1_i; //plus
      1:
      begin
        result_o=d0_i-d1_i;  //subtract    can be used by beq,bne
        zero_o=(result_o==0)?1'b1:1'b0;
      end      
      2:
      result_o=d0_i&d1_i; //and
      3:
      result_o=d0_i|d1_i; //or
      4:
      result_o=d0_i^d1_i; //xor
      5:
      result_o=~(d0_i|d1_i); //nor
      6:
      result_o=d1_i<<d0_i; //shift left
      7:
      result_o=d1_i>>d0_i; //shift right logically
      8:
      result_o=(d1_i)>>>d0_i; //shift right arithmatically
      9:
      zero_o=(d1_i==1)?(d0_i>=0?1'b1:1'b0):(d1_i>=0?1'b0:1'b1); // >= used by bgez(di_i:1),bltz(d1_i:0)
      10:
      zero_o=(d0_i<=0)?1'b1:1'b0; // <= used by blez
      11:
      zero_o=(d0_i>0)?1'b1:1'b0; // > used by bgtz
      12:
      result_o={d1_i[15:0],16'b0}; //lui
      13:
      result_o=(d0_i<d1_i)?1:0; //slt
      14:
      result_o=($signed(d0_i)<$signed(d1_i))?1:0;
      15:
      result_o=d1_i<<d0_i[5:0];
      16:
      result_o=d1_i>>d0_i[5:0];
      17:
      result_o=(d1_i)>>>d0_i[5:0];
    endcase
  end
  
endmodule
      
      
      
