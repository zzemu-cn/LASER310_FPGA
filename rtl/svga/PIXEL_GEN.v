module PIXEL_GEN(
	// control
	reset,

	pixel_code,
	graph_pixel,

	pixel_clock,
	pixel_bit
);

input			pixel_clock;
input			reset;

input	[7:0]	pixel_code;
input	[8:0]	graph_pixel;		// pixel number on the current line

output	reg	[1:0]	pixel_bit;

reg		[7:0]	latched_data;

// 延时：图形模式 128x64 4色
// 1、(001)锁存 vram 地址，2、(010)读取 vram  3、(011)锁存 vram 数据 4、(100)空 5、(101)数据锁存至移位寄存器
// 6、(110)移位得到点阵 7、(111)建立调色板，锁存色彩

// serialize the GRAPH MODE data
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
 		begin
			pixel_bit = 2'b00;
			latched_data  = 8'h00;
		end
	else begin
		case(graph_pixel[3:0])
			4'b0101:
				latched_data [7:0] = pixel_code;
			default:
			if(graph_pixel[1:0]==2'b10)
				{pixel_bit,latched_data [7:2]} <= latched_data [7:0];
		endcase
		end

	end

endmodule //PIXEL_GEN
