`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:18 03/24/2019 
// Design Name: 
// Module Name:    top 
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
module top(RSTN,BTN_y,SW,clk_100mhz,
			  BTN_x,CR,RDY,readn,seg_clk,seg_sout,SEG_PEN,seg_clrn,
			  led_clk,led_sout,LED_PEN,led_clrn
    );
	input RSTN;
	input [3:0]BTN_y;
	input [15:0]SW;
	input clk_100mhz;
	output [4:0]BTN_x;
	output CR;
	output RDY;
	output readn;
	output seg_clk,seg_sout,SEG_PEN,seg_clrn;
	output led_clk,led_sout,LED_PEN,led_clrn;
	
	
	//////////////U1 done
	wire mem_w;
	wire[31:0]PC;
	wire[31:0]Addr_out;
	wire[31:0]Data_out; 
	wire [31:0]CPU_MIO;
	wire MIO_ready; //一个输入，该赋值为什么？
	assign MIO_ready=1'b0;
	

	
	////////////////U2 done
	wire [31:0]inst;

	
	///////////////U3 done
	wire [31:0] douta;

	
	///////////////U4 done
	wire[31:0]Data_in;			
	wire[31:0]ram_data_in;				
	wire[9:0]ram_addr;					
	wire data_ram_we;
	wire GPIOF0;
	wire GPIOE0;
	wire counter_we;
	wire[31:0]CPU2IO;


	
	///////////////////////////U5 done
	wire [7:0] point_out;
	wire [7:0] LE_out;
	wire [31:0]Disp_num;

	
	//////////////////////////U6 done

	
   //////////////////////////U7 done
	wire[1:0] counter_set;
	wire[15:0] LED_out;
	wire[13:0] GPIOf0;

	
	/////////////////////////U8 done
	wire [31:0]Div;
	wire Clk_CPU;
	wire IO_clk;
	assign IO_clk=~Clk_CPU;

   
	//////////////////////U9 done
	wire[4:0] Key_out;
	wire[3:0] Pulse;
	wire[3:0] BTN_OK;
	wire[15:0]SW_OK;
	wire 	  rst;
	wire Key_ready;
	assign RDY=Key_ready;

	
	///////////////////////////////U10 done
	wire counter0_OUT;
	wire counter1_OUT;
	wire counter2_OUT;
	wire [31:0] counter_out;

	
	///////////////////////////////M4 done
	wire [31:0]Ai;
	wire [31:0]Bi;
	wire [7:0]blink;

	
	/////////////////////////////////////end wire
	
	////////////////////////////////////begin module
	PCPU U1(.clk(Clk_CPU),
			  .reset(rst),
			  .inst_in(inst[31:0]),
			  .INT(counter0_OUT),
			  .PC_out(PC),
			  .mem_w(mem_w),
			  .Addr_out(Addr_out),
			  .Data_in(Data_in),
			  .Data_out(Data_out),
			  .CPU_MIO(CPU_MIO),
			  .MIO_ready(MIO_ready)
	);
	
	ROM_D U2(.a(PC[11:2]),
				.spo(inst)
	);
	RAM_B U3(.addra(ram_addr[9:0]),
				.wea(data_ram_we),
				.dina(ram_data_in),
				.clka(clk_100mhz),
				.douta(douta)
	);
	MIO_BUS U4(.clk(clk_100mhz),
				  .rst(rst),
				  .BTN(BTN_OK),
				  .SW(SW_OK),
				  .mem_w(mem_w),
				  .addr_bus(Addr_out),
				  .Cpu_data4bus(Data_in),
				  .Cpu_data2bus(Data_out),
				  .ram_data_in(ram_data_in),
				  .data_ram_we(data_ram_we),
				  .ram_addr(ram_addr),
				  .ram_data_out(douta),
				  .Peripheral_in(CPU2IO),
				  .GPIOe0000000_we(GPIOE0),
				  .GPIOf0000000_we(GPIOF0),
				  .led_out(LED_out),
				  .counter_out(counter_out),
				  .counter2_out(counter2_OUT),
				  .counter1_out(counter1_OUT),
				  .counter0_out(counter0_OUT),
				  .counter_we(counter_we)
	);
	Multi_8CH32 U5(.clk(IO_clk),
						.rst(rst),
						.EN(GPIOE0),
						.Test(SW_OK[7:5]),     //印象流，记得检查一下
						.point_in({Div[31:0],Div[31:0]}),
						.LES({64{1'b0}}),
						.Data0(CPU2IO),
						.data1({2'b0,PC[31:2]}),
						.data2(inst[31:0]),
						.data3(counter_out[31:0]),
						.data4(Addr_out[31:0]),
						.data5(Data_out[31:0]),
						.data6(Data_in[31:0]),
						.data7(PC[31:0]),
						.Disp_num(Disp_num),
						.point_out(point_out),
						.LE_out(LE_out)
	);
	SSeg7_Dev U6(.clk(clk_100mhz),
				    .rst(rst),
					 .Start(Div[20]),
					 .SW0(SW_OK[0]),
					 .flash(Div[25]),
					 .Hexs(Disp_num),
					 .point(point_out),
					 .LES(LE_out),
					 .seg_clk(seg_clk),
					 .seg_sout(seg_sout),
					 .SEG_PEN(SEG_PEN),
					 .seg_clrn(seg_clrn)
	);
	SPIO U7(.clk(IO_clk),
			  .rst(rst),
			  .EN(GPIOF0),
			  .Start(Div[20]),
			  .P_Data(CPU2IO),
			  .counter_set(counter_set),
			  .LED_out(LED_out),
			  .GPIOf0(GPIOf0),
			  .led_clk(led_clk),
			  .led_sout(led_sout),
			  .LED_PEN(LED_PEN),
			  .led_clrn(led_clrn)
	);
	clk_div U8(.clk(clk_100mhz),
				  .rst(rst),
				  .SW2(SW_OK[2]),
				  .clkdiv(Div),
				  .Clk_CPU(Clk_CPU)
	);
	SAnti_jitter U9(.RSTN(RSTN),
						 .clk(clk_100mhz),
						 .Key_y(BTN_y),
						 .Key_x(BTN_x),
						 .SW(SW),
						 .readn(readn),
						 .CR(CR),
						 .Key_out(Key_out),
						 .Key_ready(Key_ready),
						 .pulse_out(Pulse),
						 .BTN_OK(BTN_OK),
						 .SW_OK(SW_OK),
						 .rst(rst)
	);
	Counter_x U10(.clk(IO_clk),
					  .rst(rst),
					  .clk0(Div[6]),
					  .clk1(Div[9]),
					  .clk2(Div[11]),
					  .counter_we(counter_we),
					  .counter_val(CPU2IO),
					  .counter_ch(counter_set),
					  .counter0_OUT(counter0_OUT),
					  .counter1_OUT(counter1_OUT),
					  .counter2_OUT(counter2_OUT),
					  .counter_out(counter_out)
	);
	SEnter_2_32 M4(.clk(clk_100mhz),
					  .Din(Key_out),
					  .D_ready(Key_ready),
					  .BTN(BTN_OK[2:0]),
					  .Ctrl({SW_OK[7:5],SW_OK[15],SW_OK[0]}),
					  .readn(readn),
					  .Ai(Ai),
					  .Bi(Bi),
					  .blink(blink)
	);
	////////////////////////////////////end module

endmodule
