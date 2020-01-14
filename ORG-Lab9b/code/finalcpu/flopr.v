module flopr(clk, rst, d, q);
    parameter width=32;
    input clk;
    input rst;
    input [width-1:0] d;
    output reg [width-1:0] q;

    always @(posedge clk or posedge rst)
	 begin
        if (rst)
            q <= 0;
        else
            q <= d;
	 end
endmodule