module dm_4k(addr,be,din,DMWr,clk,dout);
  input [11:2] addr;
  input [3:0] be;  //lower two bits means bytes address,higher two bits means extendszzzzzzzza
  input[31:0] din;
  input DMWr;
  input clk;
  output reg [31:0] dout;
  reg [31:0] dout_temp;
  
  
  reg [31:0]  DMem[1023:0];
	
	always@(posedge clk)
	begin
		if(DMWr)
		  begin
		    case(be[3:2])
		      0:
		      DMem[addr] <= din;
		      1:
		      begin
		        case(be[1:0])
		          0:
		          DMem[addr][7:0]<=din[7:0];
		          1:
		          DMem[addr][15:8]<=din[7:0];
		          2:
		          DMem[addr][23:16]<=din[7:0];
		          3:
		          DMem[addr][31:24]<=din[7:0];
		        endcase
		      end
		      2:
		      begin
		        case(be[1:0])
		          0:
		          DMem[addr][15:0]<=din[15:0];
		          2:
		          DMem[addr][31:16]<=din[15:0];
		        endcase
		      end
		          
		    endcase
		  end
	end
	
	always@(addr)
	begin
	    dout_temp =DMem[addr];
	    case(be[3:2])
	      2'b00:     //lw
	      dout=dout_temp; 
	      
	      2'b01:     //lb and lbu, lb default, need to decide whether to set high 24 bits to 0 outside
	      begin
	        case(be[1:0])
	          2'b00:
	          dout={{24{dout_temp[7]}},dout_temp[7:0]};
	          2'b01:
	          dout={{24{dout_temp[15]}},dout_temp[15:8]};
	          2'b10:
	          dout={{24{dout_temp[23]}},dout_temp[23:16]};
	          2'b11:
	          dout={{24{dout_temp[31]}},dout_temp[31:24]};
	        endcase
	      end
	      
	      2'b10: //lh and lhu, lh default
	      begin
	        case(be[1:0])
	          2'b00:
	          dout={{16{dout_temp[7]}},dout_temp[15:0]};
	          2'b01:
	          dout={{16{dout_temp[23]}},dout_temp[23:8]};
	          2'b10:
	          dout={{16{dout_temp[31]}},dout_temp[31:16]};
	          2'b11:
	          begin
	            dout={24'b0,dout_temp[31:24]};
	            dout_temp=DMem[addr+1];
	            dout=dout|{16'b0,dout_temp[7:0],8'b0};
	          end
	        endcase
	      end
	    endcase
	          
	end
endmodule
	
	
  