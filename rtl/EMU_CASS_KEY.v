// CLK 20*14*2/1000 us
// 一个方波 277 us
// 50MHZ / 28
// 277 / (20*14*2/1000) = 277 * 1000 / 560 = 494.6

// 10MHZ
// 277 / (100/1000) = 277 * 10 = 2770

// TURBO_SPEED
// 2770*3/14 = 594

//`define		CASS_DELAY_1X			495
`define		CASS_DELAY_1X			2770
`define		CASS_DELAY_TURBO_SPEED	594

`define		ST_READY				6'd0

`define		ST_UART_DECODE			6'd1
`define		ST_UART_RX				6'd2
`define		ST_UART_TX				6'd3

// 模拟键盘
`define		ST_KEY_DECODE			6'd5
`define		ST_KEY_PRESS			6'd6
`define		ST_KEY_DELAY			6'd7
`define		ST_KEY_END				6'd8
`define		ST_KEY_ECHO				6'd9

// 模拟磁带
`define		ST_CASS_START			6'd11
`define		ST_CASS_LD_LEN			6'd12
`define		ST_CASS_LD_LEN1			6'd13
`define		ST_CASS_LD_LEN2			6'd14
`define		ST_CASS_LD_LEN3			6'd15
`define		ST_CASS_LD_FN_WAIT		6'd16
`define		ST_CASS_LD_FN_WAIT1		6'd17
`define		ST_CASS_READ_DAT		6'd18
`define		ST_CASS_FN_WAIT			6'd19
`define		ST_CASS_GEN_WAV			6'd20
`define		ST_CASS_SHIFT			6'd21
`define		ST_CASS_DELAY			6'd22


`define		ST_BUF_RD						6'd50

// 写入磁带缓冲
`define		ST_BUF_WR						6'd31
`define		ST_BUF_WR_RD_AL					6'd32
`define		ST_BUF_WR_RD_AH					6'd33
`define		ST_BUF_WR_RD_CNT				6'd34
`define		ST_BUF_WR_RD_CHK				6'd35
`define		ST_BUF_WR_RD_ECHO				6'd36
`define		ST_BUF_WR_OP_RD_DAT				6'd37
`define		ST_BUF_WR_OP					6'd38
`define		ST_BUF_WR_OP_WR					6'd39
`define		ST_BUF_WR_OP_WR1				6'd40
`define		ST_BUF_WR_OP_WR2				6'd41
`define		ST_BUF_WR_OP_WR_CNT				6'd42
`define		ST_BUF_WR_OP_WR_END				6'd43
`define		ST_BUF_WR_OP_ECHO				6'd44


module	EMU_CASS_KEY(
	CASS_PLAY,
	CASS_STOP,
	// cass emu
	CASS_BUF_RD,
	//
	CASS_BUF_A,
	CASS_BUF_WR,
	CASS_BUF_DAT,
	CASS_BUF_Q,
	//	Control Signals
	CASS_EN,
	CASS_DAT,

	// key emu
	KEY,
	KEY_EX,
	KEY_EN,

    /*
     * UART: 115200 bps, 8N1
     */
    UART_RXD,
    UART_TXD,

	// System
	TURBO_SPEED,
	// Clock: 10MHz
	CLK,
	RST_N
);

input CASS_PLAY, CASS_STOP;

//
output	reg		[12:0]	CASS_BUF_A;
output	reg				CASS_BUF_WR;
output	reg		[7:0]	CASS_BUF_DAT;
input			[7:0]	CASS_BUF_Q;

output	reg				CASS_BUF_RD;
output	reg				CASS_EN;
output	reg		[1:0]	CASS_DAT;

output	reg		[63:0]	KEY;
output	reg		[7:0]	KEY_EX;
output	reg				KEY_EN;

input	wire	UART_RXD;
output	wire	UART_TXD;

input TURBO_SPEED;
input CLK;
input RST_N;


reg		[5:0]	ST;
reg		[5:0]	RET_ST;

reg		[7:0]	DAT;
reg		[15:0]	DAT_C;
reg		[7:0]	FN_WAIT_A;
reg		[3:0]	WAIT_C;
reg		[3:0]	BIT_C;
reg		[5:0]	BIT_SHAPE;
reg		[2:0]	SHAPE_C;
reg		[11:0]	SHAPE_DELAY;


reg		[7:0]	UART_DAT;
reg		[19:0]	KEY_DELAY;


reg		[7:0]	DAT_CHK;
reg		[7:0]	BUF_CNT;
reg		[16:0]	BUF_WR_A;
//reg		[7:0]	BUF_WR_DAT;

reg		key_echo_en;


reg		[7:0]	uart_tx_tdata;
reg				uart_tx_tvalid;
wire			uart_tx_tready;

wire	[7:0]	uart_rx_tdata;
wire			uart_rx_tvalid;
reg				uart_rx_tready;

uart
uart_inst (
    .clk(CLK),
    .rst(~RST_N),
    // AXI input
    .s_axis_tdata(uart_tx_tdata),
    .s_axis_tvalid(uart_tx_tvalid),
    .s_axis_tready(uart_tx_tready),
    // AXI output
    .m_axis_tdata(uart_rx_tdata),
    .m_axis_tvalid(uart_rx_tvalid),
    .m_axis_tready(uart_rx_tready),
    // uart
    .rxd(UART_RXD),
    .txd(UART_TXD),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // configuration
    .prescale(10000000/(57600*8))
);

//9600 19200 38400 57600 115200

/*
   KD5 KD4 KD3 KD2 KD1 KD0 扫描用地址
A0  R   Q   E       W   T  68FEH       0
A1  F   A   D  CTRL S   G  68FDH       8
A2  V   Z   C  SHFT X   B  68FBH      16
A3  4   1   3       2   5  68F7H      24
A4  M  空格 ，      .   N  68EFH      32
A5  7   0   8   -   9   6  68DFH      40
A6  U   P   I  RETN O   Y  68BFH      48
A7  J   ；  K   :   L   H  687FH      56
*/

always @(posedge CLK or negedge RST_N)
begin
	if(~RST_N)
	begin
		ST				<=	`ST_READY;
		RET_ST			<=	`ST_READY;

		CASS_EN			<=	1'b0;
		CASS_DAT		<=	2'b00;

		CASS_BUF_A		<=	0;
		CASS_BUF_WR		<=	1'b0;
		CASS_BUF_RD		<=	1'b0;
		DAT_C			<=	0;
		FN_WAIT_A		<=	0;
		BIT_C			<=	0;

        uart_tx_tdata	<=	8'b0;
        uart_tx_tvalid	<=	1'b0;
        uart_rx_tready	<=	1'b1;

		KEY_EN			<=	1'b0;
		KEY				<=	64'hFFFFFFFFFFFFFFFF;
		KEY_EX			<=	8'hFF;
	end
	else
	begin
		case(ST)
			`ST_READY:
			begin
				CASS_EN			<=	1'b0;
				CASS_DAT		<=	2'b00;
				CASS_BUF_A		<=	0;
				CASS_BUF_WR		<=	1'b0;
				CASS_BUF_RD		<=	1'b0;

				KEY_EN			<=	1'b0;
				KEY				<=	64'hFFFFFFFFFFFFFFFF;
				KEY_EX			<=	8'hFF;

				uart_tx_tvalid	<=	1'b0;

				if(CASS_PLAY) begin
					ST				<=	`ST_CASS_START;
				end
				else begin

					if (uart_rx_tvalid) begin
						// send byte back out
						UART_DAT		<=	uart_rx_tdata;
						ST				<=	`ST_UART_DECODE;
					end

				end
			end

/////////////////////////////////////////////

		`ST_UART_DECODE:
		begin
			case(UART_DAT)
				8'h00:	// 同步
					ST			<=	`ST_READY;
				8'h01:	// 读缓冲
					ST			<=	`ST_BUF_RD;
				8'h02:	// 写缓冲
					ST			<=	`ST_BUF_WR;
				8'h5F:	// _ 播放磁带
					ST			<=	`ST_CASS_START;
				default:
					ST			<=	`ST_KEY_DECODE;
			endcase
		end

/////////////////////////////////////////////
		`ST_UART_RX:
		begin
			// ready to receive byte
			if (uart_rx_tvalid) begin
				UART_DAT		<=	uart_rx_tdata;
				ST				<=	RET_ST;
			end
		end

		`ST_UART_TX:
		begin
			if (uart_tx_tvalid) begin
				if (uart_tx_tready) begin
					uart_tx_tvalid	<=	1'b0;
					ST				<=	RET_ST;
				end
			end
		end

/////////////////////////////////////////////

			// 等1个周期读取数据
			`ST_CASS_START:
			begin
				ST				<=	`ST_CASS_LD_LEN;
			end

			`ST_CASS_LD_LEN:
			begin
				CASS_EN			<=	1'b1;
				DAT_C[7:0]		<=	CASS_BUF_Q;
				CASS_BUF_A		<=	1;
				ST				<=	`ST_CASS_LD_LEN1;
			end

			`ST_CASS_LD_LEN1:
			begin
				ST				<=	`ST_CASS_LD_LEN2;
			end

			`ST_CASS_LD_LEN2:
			begin
				DAT_C[15:8]		<=	CASS_BUF_Q;
				CASS_BUF_A		<=	2;
				ST				<=	`ST_CASS_LD_LEN3;
			end

			`ST_CASS_LD_LEN3:
			begin
				ST				<=	`ST_CASS_LD_FN_WAIT;
			end

			`ST_CASS_LD_FN_WAIT:
			begin
				FN_WAIT_A[7:0]	<=	CASS_BUF_Q;
				CASS_BUF_A		<=	3;
				ST				<=	`ST_CASS_LD_FN_WAIT1;
			end

			`ST_CASS_LD_FN_WAIT1:
			begin
				ST				<=	`ST_CASS_READ_DAT;
			end

			// 读取1个字节
			`ST_CASS_READ_DAT:
			begin
				DAT				<=	CASS_BUF_Q;
				CASS_BUF_A		<=	CASS_BUF_A+1;
				BIT_C			<=	0;
				DAT_C			<=	DAT_C-1;
				CASS_BUF_RD		<=	1'b1;
				WAIT_C			<=	0;

				if(DAT_C==0)
					ST				<=	`ST_READY;
				else
					if(CASS_BUF_A=={8'b0,FN_WAIT_A})
						ST				<=	`ST_CASS_FN_WAIT;
					else
						ST				<=	`ST_CASS_GEN_WAV;
			end

			// 延时约 0.003 秒
			`ST_CASS_FN_WAIT:
			begin
				RET_ST			<=	`ST_CASS_FN_WAIT;
				WAIT_C			<=	WAIT_C+1;
				CASS_DAT		<=	2'b00;
				SHAPE_DELAY		<=	0;
				if(WAIT_C==11)
					ST				<=	`ST_CASS_GEN_WAV;
				else
					ST				<=	`ST_CASS_DELAY;
			end

			// 读取1位 从高位到低位
			`ST_CASS_GEN_WAV:
			begin
				DAT[7:1]		<= DAT[6:0];
				//DAT[6:0] <= DAT[7:1];
				BIT_C			<=	BIT_C+1;
				SHAPE_C			<=	0;
				CASS_BUF_RD		<=	1'b0;

				if(DAT[7])
				//if(DAT[0])
					BIT_SHAPE		<=	6'b101010;
				else
					BIT_SHAPE		<=	6'b101100;

				if(BIT_C==8)
					ST				<=	`ST_CASS_READ_DAT;
				else
					ST				<=	`ST_CASS_SHIFT;
			end

			`ST_CASS_SHIFT:
			begin
				RET_ST			<=	`ST_CASS_SHIFT;
				SHAPE_C			<=	SHAPE_C+1;
				SHAPE_DELAY		<=	0;
				BIT_SHAPE[5:1]	<=	BIT_SHAPE[4:0];

				if(SHAPE_C==6)
				begin
					ST				<=	`ST_CASS_GEN_WAV;
				end
				else
				begin
					CASS_DAT		<=	BIT_SHAPE[5]?2'b10:2'b01;
					ST				<=	`ST_CASS_DELAY;
				end
			end

			// 延时
			`ST_CASS_DELAY:
			begin
				SHAPE_DELAY		<=	SHAPE_DELAY+1;
				if(CASS_STOP)
						ST			<=	`ST_READY;
				else
					if( TURBO_SPEED ? (SHAPE_DELAY==`CASS_DELAY_TURBO_SPEED) : (SHAPE_DELAY==`CASS_DELAY_1X) )
						ST			<=	RET_ST;
			end

/////////////////////////////////////////////

		`ST_KEY_DECODE:
		begin
			// 设置键盘编码，保持0.05s
			// ASCII 编码
			case(UART_DAT)
				8'h30:	KEY[44] <= 1'b0;	// 0
				8'h31:	KEY[28] <= 1'b0;	// 1
				8'h32:	KEY[25] <= 1'b0;	// 2
				8'h33:	KEY[27] <= 1'b0;	// 3
				8'h34:	KEY[29] <= 1'b0;	// 4
				8'h35:	KEY[24] <= 1'b0;	// 5
				8'h36:	KEY[40] <= 1'b0;	// 6
				8'h37:	KEY[45] <= 1'b0;	// 7
				8'h38:	KEY[43] <= 1'b0;	// 8
				8'h39:	KEY[41] <= 1'b0;	// 9

				8'h40:	begin	KEY[18] <= 1'b0;	KEY[44] <= 1'b0;	end		// @
				8'h21:	begin	KEY[18] <= 1'b0;	KEY[28] <= 1'b0;	end		// !
				8'h22:	begin	KEY[18] <= 1'b0;	KEY[25] <= 1'b0;	end		// "
				8'h23:	begin	KEY[18] <= 1'b0;	KEY[27] <= 1'b0;	end		// #
				8'h24:	begin	KEY[18] <= 1'b0;	KEY[29] <= 1'b0;	end		// $
				8'h25:	begin	KEY[18] <= 1'b0;	KEY[24] <= 1'b0;	end		// %
				8'h26:	begin	KEY[18] <= 1'b0;	KEY[40] <= 1'b0;	end		// &
				8'h27:	begin	KEY[18] <= 1'b0;	KEY[45] <= 1'b0;	end		// '
				8'h28:	begin	KEY[18] <= 1'b0;	KEY[43] <= 1'b0;	end		// (
				8'h29:	begin	KEY[18] <= 1'b0;	KEY[41] <= 1'b0;	end		// )

				8'h41:	KEY[12] <= 1'b0;	// A
				8'h42:	KEY[16] <= 1'b0;	// B
				8'h43:	KEY[19] <= 1'b0;	// C
				8'h44:	KEY[11] <= 1'b0;	// D
				8'h45:	KEY[ 3] <= 1'b0;	// E
				8'h46:	KEY[13] <= 1'b0;	// F
				8'h47:	KEY[ 8] <= 1'b0;	// G
				8'h48:	KEY[56] <= 1'b0;	// H
				8'h49:	KEY[51] <= 1'b0;	// I
				8'h4A:	KEY[61] <= 1'b0;	// J
				8'h4B:	KEY[59] <= 1'b0;	// K
				8'h4C:	KEY[57] <= 1'b0;	// L
				8'h4D:	KEY[37] <= 1'b0;	// M
				8'h4E:	KEY[32] <= 1'b0;	// N
				8'h4F:	KEY[49] <= 1'b0;	// O
				8'h50:	KEY[52] <= 1'b0;	// P
				8'h51:	KEY[ 4] <= 1'b0;	// Q
				8'h52:	KEY[ 5] <= 1'b0;	// R
				8'h53:	KEY[ 9] <= 1'b0;	// S
				8'h54:	KEY[ 0] <= 1'b0;	// T
				8'h55:	KEY[53] <= 1'b0;	// U
				8'h56:	KEY[21] <= 1'b0;	// V
				8'h57:	KEY[ 1] <= 1'b0;	// W
				8'h58:	KEY[17] <= 1'b0;	// X
				8'h59:	KEY[48] <= 1'b0;	// Y
				8'h5A:	KEY[20] <= 1'b0;	// Z

				// 无对应图形符号的小写字母，按对应的大写字母处理。
				8'h61:	begin	KEY[18] <= 1'b0;	KEY[12] <= 1'b0;	end		// a 图形
				8'h62:	begin						KEY[16] <= 1'b0;	end		// b 空
				8'h63:	begin						KEY[19] <= 1'b0;	end		// c 空
				8'h64:	begin	KEY[18] <= 1'b0;	KEY[11] <= 1'b0;	end		// d 图形
				8'h65:	begin	KEY[18] <= 1'b0;	KEY[ 3] <= 1'b0;	end		// e 图形
				8'h66:	begin	KEY[18] <= 1'b0;	KEY[13] <= 1'b0;	end		// f 图形
				8'h67:	begin	KEY[18] <= 1'b0;	KEY[ 8] <= 1'b0;	end		// g 图形
				8'h68:	begin	KEY[18] <= 1'b0;	KEY[56] <= 1'b0;	end		// h 图形
				8'h69:	begin	KEY[18] <= 1'b0;	KEY[51] <= 1'b0;	end		// i 图形
				8'h6A:	begin	KEY[18] <= 1'b0;	KEY[61] <= 1'b0;	end		// j 图形
				8'h6B:	begin						KEY[59] <= 1'b0;	end		// k
				8'h6C:	begin						KEY[57] <= 1'b0;	end		// l
				8'h6D:	begin						KEY[37] <= 1'b0;	end		// m
				8'h6E:	begin						KEY[32] <= 1'b0;	end		// n
				8'h6F:	begin						KEY[49] <= 1'b0;	end		// o
				8'h70:	begin						KEY[52] <= 1'b0;	end		// p
				8'h71:	begin	KEY[18] <= 1'b0;	KEY[ 4] <= 1'b0;	end		// q 图形
				8'h72:	begin	KEY[18] <= 1'b0;	KEY[ 5] <= 1'b0;	end		// r 图形
				8'h73:	begin	KEY[18] <= 1'b0;	KEY[ 9] <= 1'b0;	end		// s 图形
				8'h74:	begin	KEY[18] <= 1'b0;	KEY[ 0] <= 1'b0;	end		// t 图形
				8'h75:	begin	KEY[18] <= 1'b0;	KEY[53] <= 1'b0;	end		// y 图形
				8'h76:	begin						KEY[21] <= 1'b0;	end		// v
				8'h77:	begin	KEY[18] <= 1'b0;	KEY[ 1] <= 1'b0;	end		// w 图形
				8'h78:	begin						KEY[17] <= 1'b0;	end		// x
				8'h79:	begin	KEY[18] <= 1'b0;	KEY[48] <= 1'b0;	end		// y 图形
				8'h7A:	begin	KEY[18] <= 1'b0;	KEY[20] <= 1'b0;	end		// z 图形

				8'h20:	KEY[36] <= 1'b0;	// Space
				8'h0D:	KEY[50] <= 1'b0;	// CR
				//8'h0A:	KEY[50] <= 1'b0;	// LF
				8'h08:	begin	KEY[10] <= 1'b0;	KEY[37] <= 1'b0;	end		// BS
				8'h03:	begin	KEY[10] <= 1'b0;	KEY[42] <= 1'b0;	end		// ETX

				8'h2F:	begin	KEY[18] <= 1'b0;	KEY[59] <= 1'b0;	end		// K /
				8'h3F:	begin	KEY[18] <= 1'b0;	KEY[57] <= 1'b0;	end		// L ?
				8'h5C:	begin	KEY[18] <= 1'b0;	KEY[37] <= 1'b0;	end		// M \ endline
				8'h5E:	begin	KEY[18] <= 1'b0;	KEY[32] <= 1'b0;	end		// N ^
				8'h5B:	begin	KEY[18] <= 1'b0;	KEY[49] <= 1'b0;	end		// O [
				8'h5D:	begin	KEY[18] <= 1'b0;	KEY[52] <= 1'b0;	end		// P ]

				8'h3A:	KEY[58] <= 1'b0;	// :
				8'h3B:	KEY[60] <= 1'b0;	// ;
				8'h2C:	KEY[35] <= 1'b0;	// ,
				8'h2D:	KEY[42] <= 1'b0;	// -
				8'h2E:	KEY[33] <= 1'b0;	// .
				8'h2A:	begin	KEY[18] <= 1'b0;	KEY[58] <= 1'b0;	end		// *
				8'h2B:	begin	KEY[18] <= 1'b0;	KEY[60] <= 1'b0;	end		// +
				8'h3C:	begin	KEY[18] <= 1'b0;	KEY[35] <= 1'b0;	end		// <
				8'h3D:	begin	KEY[18] <= 1'b0;	KEY[42] <= 1'b0;	end		// =
				8'h3E:	begin	KEY[18] <= 1'b0;	KEY[33] <= 1'b0;	end		// >
			//	default:
			endcase
			ST			<=	`ST_KEY_PRESS;
		end

		`ST_KEY_PRESS:
		begin
			KEY_DELAY		<= 1;
			if(KEY==64'hFFFFFFFFFFFFFFFF)
			begin
				//uart_rx_tready	<=	1'b1;
				key_echo_en		<=	1'b0;
				ST				<=	`ST_KEY_ECHO;
			end
			else
			begin
				uart_tx_tdata	<=	UART_DAT;
				//uart_rx_tready	<=	1'b0;
				key_echo_en		<=	1'b1;
				ST				<=	`ST_KEY_DELAY;
			end
		end

		`ST_KEY_DELAY:
		begin
			KEY_EN			<=	1'b1;
			KEY_DELAY		<=	KEY_DELAY+1;
			// 延时
			if(KEY_DELAY==0)
				ST			<=	`ST_KEY_ECHO;
		end

		`ST_KEY_ECHO:
		begin
			KEY_EN	<=	1'b0;
			// 回复接收的数据
			if( key_echo_en )
			begin
				uart_tx_tvalid	<=	1'b1;
				//uart_rx_tready	<=	1'b1;
				RET_ST			<=	`ST_READY;
				ST				<=	`ST_UART_TX;
			end
			else
			begin
				ST				<=	`ST_READY;
			end
		end

/////////////////////////////////////////////

		`ST_BUF_RD:
		begin
			ST				<=	`ST_READY;
		end

		`ST_BUF_WR:
		begin
			DAT_CHK			<=	8'hAA;
			RET_ST			<=	`ST_BUF_WR_RD_AL;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_RD_AL:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_WR_A[7:0]	<=	UART_DAT;
			RET_ST			<=	`ST_BUF_WR_RD_AH;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_RD_AH:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_WR_A[15:8]	<=	UART_DAT;
			RET_ST			<=	`ST_BUF_WR_RD_CNT;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_RD_CNT:
		begin
			DAT_CHK			<=	DAT_CHK^UART_DAT;
			BUF_CNT			<=	UART_DAT;
			RET_ST			<=	`ST_BUF_WR_RD_CHK;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_RD_CHK:
		begin
			if(	DAT_CHK==UART_DAT ) begin
				// 接收正常
				uart_tx_tdata	<=	8'd0;
				ST				<=	`ST_BUF_WR_RD_ECHO;
			end else begin
				// 接收出错
				uart_tx_tdata	<=	8'd1;
				ST				<=	`ST_BUF_WR_OP_ECHO;
			end
		end

		`ST_BUF_WR_RD_ECHO:
		begin
			uart_tx_tvalid	<=	1'b1;
			// uart_rx_tready	<=	1'b1;
			RET_ST			<=	`ST_BUF_WR_OP_RD_DAT;
			ST				<=	`ST_UART_TX;
		end

		`ST_BUF_WR_OP_RD_DAT:
		begin
			// 读写循环
			BUF_CNT			<=	BUF_CNT-1;
			// 在之后的内存读取后计算校验值
			// DAT_CHK			<=	DAT_CHK^UART_DAT;
			RET_ST			<=	`ST_BUF_WR_OP;
			ST				<=	`ST_UART_RX;
		end

		`ST_BUF_WR_OP:
		begin
				CASS_BUF_A		<=	BUF_WR_A;
				CASS_BUF_DAT	<=	UART_DAT;
				ST				<=	`ST_BUF_WR_OP_WR;
		end

		`ST_BUF_WR_OP_WR:
		begin
				CASS_BUF_WR		<=	1'b1;
				ST				<=	`ST_BUF_WR_OP_WR1;
		end

		`ST_BUF_WR_OP_WR1:
		begin
				CASS_BUF_WR		<=	1'b0;
				ST				<=	`ST_BUF_WR_OP_WR2;
		end

		`ST_BUF_WR_OP_WR2:
		begin
				ST				<=	`ST_BUF_WR_OP_WR_CNT;
		end

		// 判断计数器是否为零
		`ST_BUF_WR_OP_WR_CNT:
		begin
			BUF_WR_A			<=	BUF_WR_A+1;
			DAT_CHK				<=	DAT_CHK^CASS_BUF_Q;
			if(BUF_CNT==0)	begin
				ST				<=	`ST_BUF_WR_OP_WR_END;
			end else begin
				ST				<=	`ST_BUF_WR_OP_RD_DAT;
			end
		end

		`ST_BUF_WR_OP_WR_END:
		begin
				uart_tx_tdata	<=	DAT_CHK;
				ST				<=	`ST_BUF_WR_OP_ECHO;
		end

		`ST_BUF_WR_OP_ECHO:
		begin
			uart_tx_tvalid	<=	1'b1;
			//uart_rx_tready	<=	1'b1;
			RET_ST			<=	`ST_READY;
			ST				<=	`ST_UART_TX;
		end

/////////////////////////////////////////////
		default:
			ST				<=	ST+1;
		endcase
	end
end

endmodule

/*
		// 读取数据对比
		`ST_BUF_WR_OP_WR_END:
		begin
			if(	CASS_BUF_Q!=BUF_WR_DAT ) begin
				// 写入出错
				uart_tx_tdata	<=	8'd2;
			end
			ST				<=	`ST_BUF_WR_OP_ECHO;
		end
*/
