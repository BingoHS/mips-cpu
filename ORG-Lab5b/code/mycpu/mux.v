
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:17:17 03/31/2019 
// Design Name: 
// Module Name:    mux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux(s, y,d0, d1, d2, d3);
    parameter num=2,sigwid=1,width=32; //sigwid控制信号宽度 width输出信号宽度
    input [width-1:0]d0;
    input [width-1:0]d1;
    input [width-1:0]d2;
    input [width-1:0]d3;
    input [sigwid-1:0]s;
    output reg [width-1:0]y;
    always@(s or d0 or d1 or d2 or d3)
      case(s)
        0:y=d0;
        1:y=d1;
        2:y=d2;
        3:y=d3;
        default:y=0;
      endcase
endmodule
