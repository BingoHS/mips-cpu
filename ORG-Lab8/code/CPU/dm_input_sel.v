module dm_input_sel(d,q,DMSource);
  input [31:0] d;
  output reg [31:0]q;
  input [1:0] DMSource;
  
  always@(d or DMSource)
  begin
    case(DMSource)
      0:
      q=d;
      1:
      q={16'b0,d[15:0]};
      2:
      q={24'b0,d[7:0]};
    endcase
  end
endmodule

