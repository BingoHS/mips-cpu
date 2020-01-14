module stop(sto,inst_in,id_inst);
  output reg sto;
  input [31:0]inst_in;
  input [31:0]id_inst;
  
  always@(*)
  begin
    if((inst_in[31:26]==5 || inst_in[31:26]==4)&&(id_inst[31:26]==35)&&(id_inst[20:16]==inst_in[25:21]||id_inst[20:16]==inst_in[20:16]))
      sto=1;
    else
      sto=0;  
  end
  
  
  
endmodule
