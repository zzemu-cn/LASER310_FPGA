`timescale 1ns / 1ps

// https://www.cnblogs.com/qiwacode/p/5438062.html

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:
// Design Name:	   
// Module Name:	   my_uart_top
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

/*
module my_uart_top(
	clk,
	rst_n,
	rs232_rx,
	rs232_tx
);

input clk;						// 50MHz时钟
input rst_n;					// 低电平复位信号

input rs232_rx;					// RS232接收数据信号
output rs232_tx;				// RS232发送数据信号

wire bps_start1,bps_start2;		// 接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;			// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点	
wire[7:0] rx_data;				// 接收数据寄存器，保存直至下一个数据来到
wire rx_int;					// 接收数据中断信号,接收到数据期间始终为高电平

//----------------------------------------------------
// 下面的四个模块中，speed_rx和speed_tx是两个完全独立的硬件模块，可称之为逻辑复制
//（不是资源共享，和软件中的同一个子程序调用不能混为一谈）
////////////////////////////////////////////
speed_select	speed_rx(	 
	.clk(clk),					// 波特率选择模块
	.rst_n(rst_n),
	.bps_start(bps_start1),
	.clk_bps(clk_bps1)
);

my_uart_rx	my_uart_rx(		 
	.clk(clk),					// 接收数据模块
	.rst_n(rst_n),
	.rs232_rx(rs232_rx),
	.rx_data(rx_data),
	.rx_int(rx_int),
	.clk_bps(clk_bps1),
	.bps_start(bps_start1)
);

///////////////////////////////////////////						   
speed_select	speed_tx(	 
	.clk(clk),					// 波特率选择模块
	.rst_n(rst_n),
	.bps_start(bps_start2),
	.clk_bps(clk_bps2)
);

my_uart_tx	my_uart_tx(		 
	.clk(clk),					// 发送数据模块
	.rst_n(rst_n),
	.rx_data(rx_data),
	.rx_int(rx_int),
	.rs232_tx(rs232_tx),
	.clk_bps(clk_bps2),
	.bps_start(bps_start2)
);

endmodule

*/

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:	   17:11:32 08/28/08
// Design Name:	   
// Module Name:	   my_uart_rx
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module my_uart_tx(
	clk,
	rst_n,
	rx_data,
	rx_int,
	rs232_tx,
	clk_bps,
	bps_start
);

input clk;				// 50MHz主时钟
input rst_n;			// 低电平复位信号
input clk_bps;			// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
input[7:0] rx_data;		// 接收数据寄存器
input rx_int;			// 接收数据中断信号,接收到数据期间始终为高电平,在该模块中利用它的下降沿来启动串口发送数据
output rs232_tx;		// RS232发送数据信号
output bps_start;		// 接收或者要发送数据，波特率时钟启动信号置位

//---------------------------------------------------------
reg rx_int0,rx_int1,rx_int2;	// rx_int信号寄存器，捕捉下降沿滤波用
wire neg_rx_int;				// rx_int下降沿标志位

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			rx_int0 <= 1'b0;
			rx_int1 <= 1'b0;
			rx_int2 <= 1'b0;
		end
	else begin
			rx_int0 <= rx_int;
			rx_int1 <= rx_int0;
			rx_int2 <= rx_int1;
		end
end

assign neg_rx_int =	 ~rx_int1 & rx_int2;	//捕捉到下降沿后，neg_rx_int拉高保持一个主时钟周期

//---------------------------------------------------------
reg[7:0] tx_data;	 //待发送数据的寄存器
//---------------------------------------------------------
reg bps_start_r;
reg tx_en;	  //发送数据使能信号，高有效
reg[3:0] num;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			bps_start_r <= 1'bz;
			tx_en <= 1'b0;
			tx_data <= 8'd0;
		end
	else if(neg_rx_int) begin	 //接收数据完毕，准备把接收到的数据发回去
			bps_start_r <= 1'b1;
			tx_data <= rx_data;	   //把接收到的数据存入发送数据寄存器
			tx_en <= 1'b1;		  //进入发送数据状态中
		end
	else if(num==4'd11) begin	 //数据发送完成，复位
			bps_start_r <= 1'b0;
			tx_en <= 1'b0;
		end
end

assign bps_start = bps_start_r;

//---------------------------------------------------------
reg rs232_tx_r;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		num <= 4'd0;
		rs232_tx_r <= 1'b1;
	end
	else if(tx_en) begin
			if(clk_bps)	   begin
				num <= num+1'b1;
				case (num)
					4'd0: rs232_tx_r <= 1'b0;			// 发送起始位
					4'd1: rs232_tx_r <= tx_data[0];		// 发送bit0
					4'd2: rs232_tx_r <= tx_data[1];		// 发送bit1
					4'd3: rs232_tx_r <= tx_data[2];		// 发送bit2
					4'd4: rs232_tx_r <= tx_data[3];		// 发送bit3
					4'd5: rs232_tx_r <= tx_data[4];		// 发送bit4
					4'd6: rs232_tx_r <= tx_data[5];		// 发送bit5
					4'd7: rs232_tx_r <= tx_data[6];		// 发送bit6
					4'd8: rs232_tx_r <= tx_data[7];		// 发送bit7
					4'd9: rs232_tx_r <= 1'b1;			// 发送结束位
					default: rs232_tx_r <= 1'b1;
				endcase
			end
			else if(num==4'd11) num <= 4'd0;	//复位
		end
end

assign rs232_tx = rs232_tx_r;

endmodule


//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:	   17:11:32 08/28/08
// Design Name:	   
// Module Name:	   my_uart_rx
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module my_uart_rx(
	clk,
	rst_n,
	rs232_rx,
	rx_data,
	rx_int,
	clk_bps,
	bps_start
);

input clk;				// 50MHz主时钟
input rst_n;			// 低电平复位信号
input rs232_rx;			// RS232接收数据信号
input clk_bps;			// clk_bps的高电平为接收或者发送数据位的中间采样点
output bps_start;		// 接收到数据后，波特率时钟启动信号置位
output[7:0] rx_data;	// 接收数据寄存器，保存直至下一个数据来到 
output rx_int;			// 接收数据中断信号,接收到数据期间始终为高电平

//----------------------------------------------------------------
reg rs232_rx0,rs232_rx1,rs232_rx2,rs232_rx3;	// 接收数据寄存器，滤波用
wire neg_rs232_rx;		// 表示数据线接收到下降沿

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rs232_rx0 <= 1'b0;
		rs232_rx1 <= 1'b0;
		rs232_rx2 <= 1'b0;
		rs232_rx3 <= 1'b0;
	end
	else begin
		rs232_rx0 <= rs232_rx;
		rs232_rx1 <= rs232_rx0;
		rs232_rx2 <= rs232_rx1;
		rs232_rx3 <= rs232_rx2;
	end
end
	// 下面的下降沿检测可以滤掉<20ns-40ns的毛刺(包括高脉冲和低脉冲毛刺)，
	// 这里就是用资源换稳定（前提是我们对时间要求不是那么苛刻，因为输入信号打了好几拍） 
	//（当然我们的有效低脉冲信号肯定是远远大于40ns的）
assign neg_rs232_rx = rs232_rx3 & rs232_rx2 & ~rs232_rx1 & ~rs232_rx0;	// 接收到下降沿后neg_rs232_rx置高一个时钟周期

//----------------------------------------------------------------
reg bps_start_r;
reg[3:0] num;		// 移位次数
reg rx_int;			// 接收数据中断信号,接收到数据期间始终为高电平

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		bps_start_r <= 1'bz;
		rx_int <= 1'b0;
	end
	else if(neg_rs232_rx) begin	// 接收到串口接收线rs232_rx的下降沿标志信号
		bps_start_r <= 1'b1;	// 启动串口准备数据接收
		rx_int <= 1'b1;			// 接收数据中断信号使能
	end
	else if(num==4'd12) begin	// 接收完有用数据信息
		bps_start_r <= 1'b0;	// 数据接收完毕，释放波特率启动信号
		rx_int <= 1'b0;			// 接收数据中断信号关闭
	end

assign bps_start = bps_start_r;

//----------------------------------------------------------------
reg[7:0] rx_data_r;		// 串口接收数据寄存器，保存直至下一个数据来到
//----------------------------------------------------------------

reg[7:0] rx_temp_data;	// 当前接收数据寄存器

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
		rx_temp_data <= 8'd0;
		num <= 4'd0;
		rx_data_r <= 8'd0;
	end
	else if(rx_int) begin		// 接收数据处理
		if(clk_bps) begin		// 读取并保存数据,接收数据为一个起始位，8bit数据，1或2个结束位		
			num <= num+1'b1;
			case (num)
				4'd1: rx_temp_data[0] <= rs232_rx;	// 锁存第0bit
				4'd2: rx_temp_data[1] <= rs232_rx;	// 锁存第1bit
				4'd3: rx_temp_data[2] <= rs232_rx;	// 锁存第2bit
				4'd4: rx_temp_data[3] <= rs232_rx;	// 锁存第3bit
				4'd5: rx_temp_data[4] <= rs232_rx;	// 锁存第4bit
				4'd6: rx_temp_data[5] <= rs232_rx;	// 锁存第5bit
				4'd7: rx_temp_data[6] <= rs232_rx;	// 锁存第6bit
				4'd8: rx_temp_data[7] <= rs232_rx;	// 锁存第7bit
				default: ;
			endcase
		end
		else if(num == 4'd12) begin			// 我们的标准接收模式下只有1+8+1(2)=11bit的有效数据
			num <= 4'd0;					// 接收到STOP位后结束,num清零
			rx_data_r <= rx_temp_data;		// 把数据锁存到数据寄存器rx_data中
		end
	end

assign rx_data = rx_data_r;	   

endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:	   17:27:40 08/28/08
// Design Name:	   
// Module Name:	   speed_select
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module speed_select(
	clk,
	rst_n,
	bps_start,
	clk_bps
);

input clk;			// 50MHz主时钟
input rst_n;		// 低电平复位信号
input bps_start;	// 接收到数据后，波特率时钟启动信号置位
output clk_bps;		// clk_bps的高电平为接收或者发送数据位的中间采样点 

/*
parameter		bps9600		= 5207,		//波特率为9600bps
				bps19200	= 2603,		//波特率为19200bps
				bps38400	= 1301,		//波特率为38400bps
				bps57600	= 867,		//波特率为57600bps
				bps115200	= 433;		//波特率为115200bps

parameter		bps9600_2	= 2603,
				bps19200_2	= 1301,
				bps38400_2	= 650,
				bps57600_2	= 433,
				bps115200_2	= 216;	
*/

// 以下波特率分频计数值可参照上面的参数进行更改
//`define		BPS_PARA		5207	// 波特率为9600时的分频计数值
//`define		BPS_PARA_2		2603	// 波特率为9600时的分频计数值的一半，用于数据采样

`define		BPS_PARA		5207	// 波特率为9600时的分频计数值
`define		BPS_PARA_2		2603	// 波特率为9600时的分频计数值的一半，用于数据采样

reg[12:0] cnt;			  //分频计数
reg clk_bps_r;			  //波特率时钟寄存器

//----------------------------------------------------------
reg[2:0] uart_ctrl;	   // uart波特率选择寄存器
//----------------------------------------------------------

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 13'd0;
	else if((cnt == `BPS_PARA) || !bps_start) cnt <= 13'd0;		// 波特率计数清零
	else cnt <= cnt+1'b1;										// 波特率时钟计数启动

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt == `BPS_PARA_2) clk_bps_r <= 1'b1;				// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule
