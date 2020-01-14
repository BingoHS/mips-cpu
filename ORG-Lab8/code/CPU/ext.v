module ext(shamt_i,imme_i,EXTOp,extout_o);
  input [15:0] imme_i;
  input [1:0] EXTOp;
  input [4:0] shamt_i;
  
  output reg [31:0] extout_o;
  
  always@(shamt_i or imme_i or EXTOp)
  begin
    case(EXTOp)
      0:
      extout_o={16'b0,imme_i[15:0]};  
      // extend unsigned ,for {lb lbu lh lhu sb sh} {addiu andi ori xori} {sll sra srl} {lui} {sltiu}
      1:
      extout_o={{16{imme_i[15]}},imme_i[15:0]}; 
      //extend signed , for {lw sw} {addi} {slti} {branch} 
      2:
      extout_o={27'b0,shamt_i[4:0]}; 
      //extend rs's low 5bits unsigned
    endcase
  end
  
endmodule
      
