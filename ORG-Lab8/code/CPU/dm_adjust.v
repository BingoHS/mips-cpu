`include "define.v"
module dm_adjust(dout1_i,dout2_o,op);
  input [31:0] dout1_i;
  output reg[31:0] dout2_o;
  input [5:0] op;
  
  always@(dout1_i,op)
  begin
    case(op)
      `LBUOP:
      dout2_o={24'b0,dout1_i[7:0]};
      `LHUOP:
      dout2_o={16'b0,dout1_i[15:0]};
      default:
      dout2_o=dout1_i;
    endcase
  end
endmodule