`timescale 1 ns / 1 ns

// 使用FPGA外部 SRAM 芯片，数据口同时完成输入输出。一定要仔细调整时序，防止两个输出撞车。
// Using the FPGA's external SRAM chip, the data port completes both input and output. 
// Be sure to carefully adjust the timing to prevent the two outputs from crashing.

// 设计中，sys_rom 和 2K RAM 作为基础系统，保证系统最低需求。
// 即使 flash 不能成功写入，也不影响系统运行。
// sys_rom_altera sys_rom(); ram_2k_altera sys_ram_2k();

// In the design, sys_rom and 2K RAM are used as the base system to ensure the minimum system requirements.
// Even if the flash cannot be successfully written, it does not affect the system operation.
// sys_rom_altera sys_rom(); ram_2k_altera sys_ram_2k();


// DE1 512K SRAM (256K*16bit) IS61LV25616
// DE2 512K SRAM (256K*16bit) IS61LV25616
// DE2-70 2M SSRAM (512K*32bit)
// DE2-115 2M SRAM (1M*16bit) IS61WV102416

// DE1 DE2 FLASH 4M
// DE0 DE2-70 DE2-115 FLASH 8M


// 如果烧写 FLASH 成功，可以打开 ROM_ON_FLASH 选项。这样能提供更强的功能。
// If the FLASH is successfully programmed, the ROM_ON_FLASH option can be turned on. This provides a stronger function. ??
//`define ROM_ON_FLASH

// 选择开发板
// Select development board
//`define	DE0
`define	DE0_CV
//`define	DE1
//`define	DE2
//`define	DE2_70
//`define	DE2_115

// 选择 Z80 软核
`define	TV80
//`define	NEXTZ80

// 模拟磁带
// Analog Tape
`define CASS_EMU

// 扩展绘图模式支持
// Extended drawing mode support
`define SHRG

//=========================================================================================================

// Enable Lower Case chars in $00-$1F range
// Also requires SHRG extension active to allow access to GM0 bit
// GM0 = 0 selects INVERSE, GM0 = 1 selects L/CASE in Text mode (LATCHED_IO_SHRG[2] in Port $20)

// OUT 32,12 selects Lower Case chars, OUT 32,8 selects INVERSE chars.
 
// Mimics the behaviour of the 6847T1 chip.
// affects char gen rom select in module: char_gen_rom

`define LCASE		

//=========================================================================================================

// enable 64x16 text mode sysrom load.
// SWITCH 3 OFF selects 32x16 text mode, SWITCH3 ON selects 64x16 text mode
// only supported by ON-CHIP rom image at this point in time.

`define WIDTH_64

//=========================================================================================================

// 内存有三种配置方案：1、通过 FPGA 片上内存支持 16K  2、通过 FPGA 片上内存支持 16K 和 16K 扩展内存  3、通过 SRAM 或 SSRAM 支持 256K 扩展内存
// There are three configuration schemes for memory: 
// 1. Support 16K through on-chip memory of FPGA
// 2. Support 16K and 16K extended memory through FPGA on-chip memory 
// 3. Support 256K extended memory through SRAM or SSRAM

`ifdef DE0

`ifdef ROM_ON_FLASH

`define FPGA_ALTERA
`define FPGA_ALTERA_C3
`define CLOCK_50MHZ
`define VGA_RESISTOR
`define VGA_BIT12
`define AUDIO_GPIO
`define UART_CHIP
`define UART_CHIP_EXT
`define FLASH_CHIP
`define FLASH_CHIP_8M
//`define	BASE_RAM_78

// 用来从FLASH自动加载程序
// Used to automatically load programs from FLASH
`define BOOT_ROM_6000

`define RAM_ON_FPGA
`define	BASE_RAM_16K
`define	RAM_16K_EXPANSION
`define CASS_EMU_8K
`define VRAM_8K

`else

`define FPGA_ALTERA
`define FPGA_ALTERA_C3
`define CLOCK_50MHZ
`define VGA_RESISTOR
`define VGA_BIT12
`define AUDIO_GPIO
`define UART_CHIP
`define UART_CHIP_EXT
`define	BASE_SYS_ROM
//`define	BASE_DOS_ROM
//`define	BASE_RAM_78

`define RAM_ON_FPGA
`define	BASE_RAM_16K
//`define	RAM_16K_EXPANSION
`define CASS_EMU_4K
`define VRAM_8K

`endif

`endif

//============================================
`ifdef DE0_CV
// DE0_CV has no flash chip

`define FPGA_ALTERA
`define FPGA_ALTERA_C5
`define CLOCK_50MHZ
`define VGA_RESISTOR
`define VGA_BIT12
`define AUDIO_GPIO
//`define UART_CHIP
//`define UART_CHIP_EXT
`define	BASE_SYS_ROM
//`define	BASE_DOS_ROM
//`define	BASE_RAM_78

`define RAM_ON_FPGA
`define	BASE_RAM_16K
`define	RAM_16K_EXPANSION
`define CASS_EMU_4K
`define VRAM_8K

`endif
//=============================================

`ifdef DE1

`ifdef	ROM_ON_FLASH

`define FPGA_ALTERA
`define FPGA_ALTERA_C2
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define FLASH_CHIP
`define FLASH_CHIP_4M
`define VGA_RESISTOR
`define VGA_BIT12
`define UART_CHIP
//`define CASS_EMU_16K
`define CASS_EMU_8K

// 用来从FLASH自动加载程序
`define BOOT_ROM_6000

`define	BASE_RAM_78
`define RAM_ON_SRAM_CHIP
`define SRAM_CHIP_256x16
`define	RAM_256K_EXPANSION
`define GPIO_PIN
`define GPIO_TEST
`define VRAM_8K

`else

`define FPGA_ALTERA
`define FPGA_ALTERA_C2
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define VGA_RESISTOR
`define VGA_BIT12
`define UART_CHIP
`define CASS_EMU_2K
`define	BASE_SYS_ROM
//`define	BASE_DOS_ROM

`define	BASE_RAM_78
`define RAM_ON_SRAM_CHIP
`define SRAM_CHIP_256x16
`define	RAM_256K_EXPANSION
`define GPIO_PIN
`define GPIO_TEST
`define VRAM_2K

`endif

`endif



`ifdef DE2

`ifdef	ROM_ON_FLASH

`define FPGA_ALTERA
`define FPGA_ALTERA_C2
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define FLASH_CHIP
`define FLASH_CHIP_4M
`define VGA_ADV7123
`define VGA_BIT30
`define UART_CHIP

// 用来从FLASH自动加载程序
`define BOOT_ROM_6000

`define	BASE_RAM_78
`define RAM_ON_SRAM_CHIP
`define SRAM_CHIP_256x16
`define	RAM_256K_EXPANSION
//`define CASS_EMU_16K
`define CASS_EMU_8K
`define VRAM_8K

`else

`define FPGA_ALTERA
`define FPGA_ALTERA_C2
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define VGA_ADV7123
`define VGA_BIT30
`define UART_CHIP
`define	BASE_SYS_ROM
//`define	BASE_DOS_ROM

`define	BASE_RAM_78
`define RAM_ON_SRAM_CHIP
`define SRAM_CHIP_256x16
`define	RAM_256K_EXPANSION
`define CASS_EMU_16K
`define VRAM_8K

`endif

`endif



`ifdef DE2_70

`ifdef	ROM_ON_FLASH

`define FPGA_ALTERA
`define FPGA_ALTERA_C2
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define FLASH_CHIP
`define FLASH_CHIP_8M
`define VGA_ADV7123
`define VGA_BIT30
`define UART_CHIP
`define UART_CHIP_EXT
//`define	RAM_ON_FPGA
//`define	BASE_RAM_16K
//`define	RAM_16K_EXPANSION

// 用来从FLASH自动加载程序
`define BOOT_ROM_6000

`define	BASE_RAM_78
`define RAM_ON_SSRAM_CHIP
`define SSRAM_CHIP_512x32
`define	RAM_256K_EXPANSION
`define CASS_EMU_16K
`define VRAM_8K

`else

`define FPGA_ALTERA
`define FPGA_ALTERA_C2
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define VGA_ADV7123
`define VGA_BIT30
`define UART_CHIP
`define UART_CHIP_EXT
`define	BASE_SYS_ROM
`define	BASE_DOS_ROM
//`define	RAM_ON_FPGA
//`define	BASE_RAM_16K
//`define	RAM_16K_EXPANSION

`define	BASE_RAM_78
`define RAM_ON_SSRAM_CHIP
`define SSRAM_CHIP_512x32
`define	RAM_256K_EXPANSION
`define CASS_EMU_16K
`define VRAM_8K

`endif

`endif



`ifdef DE2_115

`ifdef	ROM_ON_FLASH

`define FPGA_ALTERA
`define FPGA_ALTERA_C4
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define FLASH_CHIP
`define FLASH_CHIP_8M
`define VGA_ADV7123
`define VGA_BIT24
`define UART_CHIP
`define UART_CHIP_EXT
//`define	RAM_ON_FPGA
//`define	BASE_RAM_16K
//`define	RAM_16K_EXPANSION

// 用来从FLASH自动加载程序
`define BOOT_ROM_6000

`define	BASE_RAM_78
`define RAM_ON_SRAM_CHIP
`define SRAM_CHIP_1024x16
`define	RAM_256K_EXPANSION
`define CASS_EMU_16K
`define VRAM_8K

`else

`define FPGA_ALTERA
`define FPGA_ALTERA_C4
`define CLOCK_27MHZ
`define AUDIO_WM8731
`define VGA_ADV7123
`define VGA_BIT24
`define UART_CHIP
`define UART_CHIP_EXT
`define	BASE_SYS_ROM
`define	BASE_DOS_ROM
//`define	RAM_ON_FPGA
//`define	BASE_RAM_16K
//`define	RAM_16K_EXPANSION

`define	BASE_RAM_78
`define RAM_ON_SRAM_CHIP
`define SRAM_CHIP_1024x16
`define	RAM_256K_EXPANSION
`define CASS_EMU_16K
`define VRAM_8K

`endif

`endif



`ifdef	RAM_256K_EXPANSION

`define	IO_BANK

`else

`ifdef	FLASH_CHIP
`define	IO_BANK
`endif

`endif

module LASER310_TOP(
	CLK50MHZ,

`ifdef CLOCK_27MHZ
	CLK27MHZ,
`endif

`ifdef RAM_ON_SRAM_CHIP
	// Altera DE1 512K SRAM
	RAM_DATA,			// 16 bit data bus to RAM
	RAM_ADDRESS,		// Common address
	RAM_WE_N,			// Common RW
	RAM_OE_N,
	RAM_CS_N,			// Chip Select for RAM
	RAM_BE0_N,			// Byte Enable for RAM
	RAM_BE1_N,			// Byte Enable for RAM
`endif


`ifdef RAM_ON_SSRAM_CHIP

`ifdef SSRAM_CHIP_512x32
	// Altera DE2-70 2048K SSRAM

	SSRAM_DATA,			// 32 bit data bus to RAM
	SSRAM_DPA,			// SRAM Parity Data Bus

	SSRAM_ADDRESS,		// Common address
	SSRAM_WE_N,			// SRAM Write Enable
	SSRAM_OE_N,

	SSRAM_GW_N,			// SRAM Global Write Enable

	SSRAM_CLK,

	SSRAM_BE_N,			// SRAM Byte Write Enable

	SSRAM_CE1_N,		// SRAM Chip Enable
	SSRAM_CE2,			// SRAM Chip Enable
	SSRAM_CE3_N,		// SRAM Chip Enable

	SSRAM_ADSC_N,		// SRAM Controller Address Status
	SSRAM_ADSP_N,		// SRAM Processor Address Status
	SSRAM_ADV_N,		// SRAM Burst Address Advance

`endif

`endif

	// Altera DE1 4MB FLASH
	// Altera DE2 4MB FLASH

	// Altera DE0 8MB FLASH
	// Altera DE2-70 8MB FLASH
	// Altera DE2-115 8MB FLASH
`ifdef FLASH_CHIP
	FL_ADDRESS,
	FL_DATA,
	FL_CE_N,
	FL_OE_N,
	FL_WE_N,
	FL_RESET_N,

`ifdef	DE0
	FL_BYTE_N,
	FL_RY,
	FL_WP_N,
	//FL_DQ15,
`endif

`ifdef	DE1
	//FL_BYTE_N,
	//FL_RY,
	//FL_WP_N,
	//FL_DQ15,
`endif

`ifdef	DE2
	//FL_BYTE_N,
	//FL_RY,
	//FL_WP_N,
	//FL_DQ15,
`endif

`ifdef	DE2_70
	FL_BYTE_N,
	FL_RY,
	FL_WP_N,
	//FL_DQ15,
`endif

`ifdef	DE2_115
	//FL_BYTE_N,
	FL_RY,
	FL_WP_N,
	//FL_DQ15,
`endif

`endif

	// VGA
`ifdef VGA_RESISTOR
	VGA_RED,
	VGA_GREEN,
	VGA_BLUE,
	VGA_HS,
	VGA_VS,
`endif

`ifdef VGA_ADV7123
	VGA_DAC_RED,
	VGA_DAC_GREEN,
	VGA_DAC_BLUE,
	VGA_HS,
	VGA_VS,
	VGA_DAC_BLANK_N,
	VGA_DAC_SYNC_N,
	VGA_DAC_CLOCK,
`endif

	// PS/2
	PS2_KBCLK,
	PS2_KBDAT,
	//Serial Ports
	//TXD1,
	//RXD1,
	// Display
	//DIGIT_N,
	//SEGMENT_N,
	// LEDs
	LED,
`ifdef GPIO_PIN
	LEDG,
`endif
	// Apple Perpherial
	//SPEAKER,
	//PADDLE,
	//P_SWITCH,
	//DTOA_CODE,
	// Extra Buttons and Switches
	SWITCH,

`ifdef AUDIO_WM8731
	////////////////	Audio CODEC		////////////////////////
	AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
	AUD_ADCDAT,						//	Audio CODEC ADC Data
	AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
	AUD_DACDAT,						//	Audio CODEC DAC Data
	AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
	AUD_XCK,						//	Audio CODEC Chip Clock

	////////////////////	I2C		////////////////////////////
	I2C_SDAT,						//	I2C Data
	I2C_SCLK,						//	I2C Clock

`endif

`ifdef GPIO_PIN
	////////////////////	GPIO	////////////////////////////
	GPIO_0,							//	GPIO Connection 0
	GPIO_1,							//	GPIO Connection 1
	GPIO_1_IN,							//	GPIO Connection 1
`endif

`ifdef UART_CHIP_EXT
	UART_RTS,
	UART_CTS,
`endif

`ifdef UART_CHIP
	UART_RXD,
	UART_TXD,
`endif

	// de0
	// de1
	BUTTON_N
);


input				CLK50MHZ;

`ifdef CLOCK_27MHZ
input				CLK27MHZ;
`endif


`ifdef	RAM_ON_SRAM_CHIP

`ifdef SRAM_CHIP_256x16

// Altera DE1 512K SRAM
// Altera DE2 512K SRAM
inout	wire	[15:0]	RAM_DATA;			// 16 bit data bus to RAM
output	wire	[17:0]	RAM_ADDRESS;		// Common address
output	reg				RAM_WE_N;			// Common RW
output	reg				RAM_OE_N;

output	wire			RAM_CS_N;			// Chip Select for RAM
output	wire			RAM_BE0_N;			// Byte Enable for RAM
output	wire			RAM_BE1_N;			// Byte Enable for RAM

`endif

`ifdef SRAM_CHIP_1024x16

// Altera DE2-115 2048K SRAM
inout	wire	[15:0]	RAM_DATA;			// 16 bit data bus to RAM
output	wire	[19:0]	RAM_ADDRESS;		// Common address
output	reg				RAM_WE_N;			// Common RW
output	reg				RAM_OE_N;

output	wire			RAM_CS_N;			// Chip Select for RAM
output	wire			RAM_BE0_N;			// Byte Enable for RAM
output	wire			RAM_BE1_N;			// Byte Enable for RAM

`endif

reg		[15:0]			LATCHED_CPU_A;
reg		[7:0]			LATCHED_CPU_DO;

`endif


`ifdef RAM_ON_SSRAM_CHIP

`ifdef SSRAM_CHIP_512x32

// Altera DE2-70 2048K SSRAM

inout	wire	[31:0]	SSRAM_DATA;			// 32 bit data bus to RAM
inout	wire	[3:0]	SSRAM_DPA;			// SRAM Parity Data Bus

output	wire	[18:0]	SSRAM_ADDRESS;		// Common address
output	reg				SSRAM_WE_N;			// SRAM Write Enable
output	reg				SSRAM_OE_N;

output	wire			SSRAM_CLK;

output	reg				SSRAM_GW_N;			// SRAM Global Write Enable

output	wire	[3:0]	SSRAM_BE_N;			// SRAM Byte Write Enable

output	reg				SSRAM_CE1_N;		// SRAM Chip Enable
output	reg				SSRAM_CE2;			// SRAM Chip Enable
output	reg				SSRAM_CE3_N;		// SRAM Chip Enable

output	wire			SSRAM_ADSC_N;		// SRAM Controller Address Status
output	reg				SSRAM_ADSP_N;		// SRAM Processor Address Status
output	wire			SSRAM_ADV_N;		// SRAM Burst Address Advance

`endif

//reg		[15:0]			LATCHED_CPU_A;
reg		[7:0]			LATCHED_CPU_DO;

reg		[7:0]			LATCHED_SSRAM_DO;

`endif


`ifdef FLASH_CHIP

// Altera DE1 4MB FLASH
`ifdef FLASH_CHIP_4M
output	[21:0]	FL_ADDRESS;
`endif

// Altera DE2-70 8MB FLASH
`ifdef FLASH_CHIP_8M
output	[22:0]	FL_ADDRESS;
`endif

//input	[15:0]	FL_DATA;
input	[7:0]	FL_DATA;
output	FL_CE_N;
output	FL_OE_N;
output	FL_WE_N;
output	FL_RESET_N;

`ifdef DE0
output		FL_BYTE_N;
input		FL_RY;
output		FL_WP_N;
//output	FL_DQ15;
`endif

`ifdef DE1
//output	FL_BYTE_N;
//input		FL_RY;
//output	FL_WP_N;
//output	FL_DQ15;
`endif

`ifdef DE2
//output	FL_BYTE_N;
//input		FL_RY;
//output	FL_WP_N;
//output	FL_DQ15;
`endif

`ifdef DE2_70
output		FL_BYTE_N;
input		FL_RY;
output		FL_WP_N;
//output	FL_DQ15;
`endif

`ifdef DE2_115
//output	FL_BYTE_N;
input		FL_RY;
output		FL_WP_N;
//output	FL_DQ15;
`endif

`endif



`ifdef VGA_RESISTOR
// de0 de1
`ifdef VGA_BIT12
output	wire	[3:0]	VGA_RED;
output	wire	[3:0]	VGA_GREEN;
output	wire	[3:0]	VGA_BLUE;
`endif

output	wire			VGA_HS;
output	wire			VGA_VS;
`endif


`ifdef VGA_ADV7123
// de2
`ifdef VGA_BIT30
output	wire	[9:0]	VGA_DAC_RED;
output	wire	[9:0]	VGA_DAC_GREEN;
output	wire	[9:0]	VGA_DAC_BLUE;
`endif

`ifdef VGA_BIT24
output	wire	[7:0]	VGA_DAC_RED;
output	wire	[7:0]	VGA_DAC_GREEN;
output	wire	[7:0]	VGA_DAC_BLUE;
`endif

output	reg				VGA_HS;
output	reg				VGA_VS;
output	wire			VGA_DAC_BLANK_N;
output	wire			VGA_DAC_SYNC_N;
output	wire			VGA_DAC_CLOCK;
`endif


// PS/2
input 			PS2_KBCLK;
input			PS2_KBDAT;

// LEDs
output	wire	[9:0]	LED;

`ifdef GPIO_PIN
output	wire	[7:0]	LEDG;
`endif

// Extra Buttons and Switches

//input	[3:0]		SWITCH;
input	[9:0]		SWITCH;

`ifdef	DE0
//input	[9:0]		SWITCH;
`endif

`ifdef	DE1
//input	[9:0]		SWITCH;
`endif

`ifdef	DE2
//input	[17:0]		SWITCH;
`endif

`ifdef	DE2_70
//input	[17:0]		SWITCH;
`endif

`ifdef	DE2_115
//input	[17:0]		SWITCH;
`endif

										//  7 System type 1	Not used
										//  6 System type 0	Not used
										//  5 Serial Port speed
										//  4 Swap floppy
										//  3 Write protect floppy 2
										//  2 Write protect floppy 1
										//  1 CPU_SPEED[1]
										//  0 CPU_SPEED[0]

//input	[3:0]		BUTTON;				//  3 RESET
										//  2 Not used
										//  1 Closed Apple
										//  0 Open Apple


`ifdef AUDIO_WM8731

////////////////////	Audio CODEC		////////////////////////////
// ADC
inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			AUD_ADCDAT;				//	Audio CODEC ADC Data

// DAC
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output	wire	AUD_DACDAT;				//	Audio CODEC DAC Data

inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output	wire	AUD_XCK;				//	Audio CODEC Chip Clock

////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock

`endif


`ifdef UART_CHIP
input		UART_RXD;
output		UART_TXD;
`endif

`ifdef UART_CHIP_EXT
output		UART_CTS = 1'bz;
input		UART_RTS;
`endif

`ifdef DE0
// DE0
input	[2:0]		BUTTON_N;
wire	[2:0]		BUTTON;
assign	BUTTON	=	~BUTTON_N;
`else
// DE1
input	[3:0]		BUTTON_N;
wire	[3:0]		BUTTON;
assign	BUTTON	=	~BUTTON_N;
`endif

`ifdef GPIO_PIN
////////////////////////	GPIO	////////////////////////////////
//inout	[35:0]	GPIO_0;		//	GPIO Connection 0
//inout	[35:0]	GPIO_1;		//	GPIO Connection 1
output	[35:0]	GPIO_0;		//	GPIO Connection 0
output	[35:0]	GPIO_1;		//	GPIO Connection 1
input	[7:0]	GPIO_1_IN;		//	GPIO Connection 1
`endif


// 10MHz 的频率用于模块计数， 包括产生 50HZ 的中断信号的时钟，uart 模块的时钟，模拟磁带模块的时钟
// 选择 10MHz 是因为 Cyclone II 的DLL 分频最多能到 5。最初打算用 1MHz。

// The frequency is used for the module count, including the clock that generates the 
// 50HZ interrupt signal, the clock of the uart module, and the clock of the analog tape module.
// The 10MHz is chosen because the Cyclone II PLL can be divided up to 5. Originally intended to use 1MHz.

wire				CLK10MHZ;

// Cyclone V uses different PLL component to C2-C4

`ifdef FPGA_ALTERA_C5
C5_CLK10MHZ_PLL C5_CLK10MHZ_PLL_INST(
		.refclk   (CLK50MHZ),
		.rst      (CPU_RESET),
		.outclk_0 (CLK10MHZ),
	);
	
`else
CLK10MHZ_PLL CLK10MHZ_PLL_INST(
	CLK50MHZ,
	CLK10MHZ);
	
`endif

// CLOCK & BUS
(*keep*)wire				BASE_CLK = CLK50MHZ;

reg		[3:0]		CLK;

reg					MEM_OP_WR;
//reg					MEM_RD;

// 50% 方波信号, 引出到 GPIO 端口
(*keep*)reg				GPIO_CPU_CLK;

// Processor
(*keep*)reg				CPU_CLK;
(*keep*)wire	[15:0]	CPU_A;
(*keep*)wire	[7:0]	CPU_DI;
(*keep*)wire	[7:0]	CPU_DO;

(*keep*)wire			CPU_RESET;
(*keep*)wire			CPU_HALT;
(*keep*)wire			CPU_WAIT;

(*keep*)wire			CPU_MREQ;
(*keep*)wire			CPU_RD;
(*keep*)wire			CPU_WR;
(*keep*)wire			CPU_IORQ;

(*keep*)reg				CPU_INT;
(*keep*)wire			CPU_NMI;
(*keep*)wire			CPU_M1;


wire					CPU_BUSRQ;
wire					CPU_BUSAK;

wire					CPU_RFSH;

`ifdef	TV80

(*keep*)wire			CPU_RESET_N;
(*keep*)wire			CPU_HALT_N;
(*keep*)wire			CPU_WAIT_N;

(*keep*)wire			CPU_MREQ_N;
(*keep*)wire			CPU_RD_N;
(*keep*)wire			CPU_WR_N;
(*keep*)wire			CPU_IORQ_N;

(*keep*)wire			CPU_INT_N;
(*keep*)wire			CPU_NMI_N;
(*keep*)wire			CPU_M1_N;

wire					CPU_BUSRQ_N;
wire					CPU_BUSAK_N;

wire					CPU_RFSH_N;

`endif

// VRAM
(*keep*)wire	[12:0]	VRAM_ADDRESS;
(*keep*)wire			VRAM_WR;
(*keep*)wire	[7:0]	VRAM_DATA_OUT;

(*keep*)wire			VDG_RD;
(*keep*)wire	[12:0]	VDG_ADDRESS;
(*keep*)wire	[7:0]	VDG_DATA;

// ROM IO RAM
reg					LATCHED_DOSROM_EN;
reg					LATCHED_BOOTROM_EN;
reg					LATCHED_AUTOSTARTROM_EN;

wire	[7:0]		SYS_ROM_DATA;
wire	[7:0]		DOS_ROM_DATA;
wire	[7:0]		AUTOSTART_ROM_DATA;

wire	[7:0]		BOOT_ROM_6000_DATA;

reg					BOOTROM_EN;
reg		[7:0]		BOOTROM_BANK;

reg					AUTOSTARTROM_EN;
reg		[7:0]		AUTOSTARTROM_BANK;

//wire	[7:0]		IO_DATA;
//wire	[7:0]		IO_WR;

wire				RAM_16K_WR;
wire	[7:0]		RAM_16K_DATA_OUT;

wire				RAM_78_WR;
wire	[7:0]		RAM_78_DATA;

wire				RAM_16K_EXP_WR;
wire	[7:0]		RAM_16K_EXP_DATA_OUT;

wire				RAM_256K_EXP_WR;
wire	[7:0]		RAM_256K_EXP_DATA_OUT;

wire				RAM_89AB_WR;
wire	[7:0]		RAM_89AB_DATA;

wire				RAM_CDEF_WR;
wire	[7:0]		RAM_CDEF_DATA;


wire	[7:0]		MEM_CDEF_DATA_OUT;
wire	[7:0]		RAM_89AB_DATA_OUT;
wire	[7:0]		RAM_CDEF_DATA_OUT;

wire				ADDRESS_ROM;
wire				ADDRESS_DOSROM;
wire				ADDRESS_IO;
wire				ADDRESS_VRAM;

wire				ADDRESS_BOOTROM_6000;
wire				ADDRESS_AUTOSTARTROM;

wire				ADDRESS_89AB;
wire				ADDRESS_CDEF;

wire				ADDRESS_RAM_78;

wire				ADDRESS_RAM_16K;
wire				ADDRESS_RAM_16K_EXP;
wire				ADDRESS_RAM_256K_EXP;

wire				ADDRESS_IO_SHRG;
wire				ADDRESS_IO_BANK;

wire				ADDRESS_RAM_CHIP;

/*
74LS174输出的各个控制信号是：  $6800-$6FFF write

Q5 蜂鸣器B端电平
Q4 IC15（6847）第39脚的CSS信号（控制显示基色）
Q3 IC15（6847）第35脚的~A/G信号（控制显示模式）
Q2 磁带记录信号电平
Q1 未用
Q0 蜂鸣器A端电平

The individual control signals output are:
Q5 Buzzer B terminal level
Q4 IC15（6847）CSS signal at pin 39 (control display base color)
Q3 IC15（6847）~A/G signal at pin 35 (control display mode)
Q2 Tape recording signal level
Q1 Not Connected?
Q0 Buzzer A terminal level

*/

reg		[7:0]		LATCHED_IO_DATA_WR;
//reg	[7:0]		LATCHED_IO_DATA_RD;

reg		[7:0]		LATCHED_BANK_0000;
reg		[7:0]		LATCHED_BANK_4000;
reg		[7:0]		LATCHED_BANK_C000;
reg		[7:0]		LATCHED_BANK_4DEF;

// 用于大于 4M 的 FLASH 区间切换
reg					LATCHED_FLASH_BANK_SW;

`ifdef SHRG
reg					LATCHED_SHRG_EN;
reg		[7:0]		LATCHED_IO_SHRG;		// 7:5 unused, 4:2 = 6847 GM[2:0], 1:0 = VRAM bank (4x2KB) 
`endif

`ifdef RAM_256K_EXPANSION
reg					LATCHED_RAM_256K_EN;
`endif

// VGA
wire	[7:0]		VGA_OUT_RED;
wire	[7:0]		VGA_OUT_GREEN;
wire	[7:0]		VGA_OUT_BLUE;

wire				VGA_OUT_HS;
wire				VGA_OUT_VS;

wire				VGA_OUT_BLANK;

`ifdef CLOCK_50MHZ
reg					VGA_CLK;
`else
// 通过 PLL 生成
wire				VGA_CLK;
`endif

// keyboard
reg		[4:0]		KB_CLK;

wire	[7:0]		SCAN;
wire				PRESS;
wire				PRESS_N;
wire				EXTENDED;

reg		[63:0]		KEY;
reg		[9:0]		KEY_EX;
reg		[11:0]		KEY_Fxx;
wire	[7:0]		KEY_DATA;
//reg	[63:0]		LAST_KEY;
//reg				CAPS_CLK;
//reg				CAPS;
wire				A_KEY_PRESSED;

reg		[7:0]		LATCHED_KEY_DATA;

// emu keyboard
wire	[63:0]		EMU_KEY;
wire	[9:0]		EMU_KEY_EX;
wire				EMU_KEY_EN;

// speaker

(*keep*)wire		SPEAKER_A = LATCHED_IO_DATA_WR[0];
(*keep*)wire		SPEAKER_B = LATCHED_IO_DATA_WR[5];

// cassette

(*keep*)wire	[1:0]	CASS_OUT;
(*keep*)wire			CASS_IN;
(*keep*)wire			CASS_IN_L;
(*keep*)wire			CASS_IN_R;


// 用于外部磁带仿真计数
//(*keep*)reg				EMU_CASS_CLK;

(*keep*)wire			EMU_CASS_EN;
(*keep*)wire	[1:0]	EMU_CASS_DAT;

// other
wire				SYS_RESET_N;
(*keep*)wire		RESET_N;
wire				RESET_AHEAD_N;

reg		[16:0]		RESET_KEY_COUNT;
wire				RESET_KEY_N;

wire				TURBO_SPEED		=	SWITCH[0];

`ifdef GPIO_PIN
wire				GPIO_SW			=	1'b1;
wire	[7:0]		GPIO_IN;
`else
wire				GPIO_SW			=	1'b0;
`endif


//	All inout port turn to tri-state
//assign	DRAM_DQ		=	16'hzzzz;
//assign	FL_DQ		=	8'hzz;
//assign	SRAM_DQ		=	16'hzzzz;
//assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;


// reset

assign SYS_RESET_N = !BUTTON[0];

RESET_DE RESET_DE(
	.CLK(CLK50MHZ),			// 50MHz
	.SYS_RESET_N(SYS_RESET_N && RESET_KEY_N),
	.RESET_N(RESET_N),		// 50MHz/32/65536
	.RESET_AHEAD_N(RESET_AHEAD_N)	// 提前恢复，可以接 FL_RESET_N
);


// 键盘 ctrl + f12 系统复位
assign RESET_KEY_N = RESET_KEY_COUNT[16];


`ifdef SIMULATE
initial
	begin
		VGA_CLK = 1'b0;
		CLK = 4'b0;
	end
`endif

`ifdef CLOCK_50MHZ

always @(negedge CLK50MHZ)
	VGA_CLK <= !VGA_CLK;

`endif


`ifdef CLOCK_27MHZ

VGA_Audio_PLL  VGA_AUDIO_PLL(.inclk0(CLK27MHZ),.c0(VGA_CLK),.c1(AUD_CTRL_CLK));

`endif


// 频率 50HZ
// 回扫周期暂定为：2线 x 800点 x 10MHZ / 25MHZ
// The retrace period is tentatively set to: 2 lines x 800 points x 10MHZ / 25MHZ

// ~FS 垂直同步信号，送往IC1、IC2称IC4。6847对CPU的唯一直接影响，便是它的~FS输出被作为Z80A的~INT控制信号；
// ~FS vertical sync signal, sent to IC1, IC2 called IC4. 
// The only direct impact of 6847 on the CPU is that its ~FS output is used as the ~INT control signal of Z80A;

// 每一场扫描结束，6847的~FS信号变低，便向Z80A发出中断请求。在PAL制中，场频为50Hz，每秒就有50次中断请求，以便系统程序利用场消隐期运行监控程序，访问显示RAM。
// At the end of each scan, the ~FS signal of 6847 goes low and an interrupt request is issued to the Z80A. 
// In the PAL system, the field rate is 50 Hz, and there are 50 interrupt requests per second, 
// so that the system program can use the field blanking period to run the monitor program and access the display RAM.

// 在加速模式中，要考虑对该计数器的影响
// In acceleration mode, consider the impact on this counter

// 系统中断：简化处理是直接接到 VGA 的垂直回扫信号，频率60HZ。带来的问题是软件计时器会产生偏差。
// System interrupt: Simplified processing is a vertical retrace signal directly connected to the VGA, frequency 60HZ. 
// The problem is that the software timer will be biased.

reg 		[17:0]	INT_CNT;

always @ (negedge CLK10MHZ)
	case(INT_CNT[17:0])
		18'd0:
		begin
			CPU_INT <= 1'b1;
			INT_CNT <= 18'd1;
		end
		18'd640:
		begin
			CPU_INT <= 1'b0;
			INT_CNT <= 18'd641;
		end
		18'd199999:
		begin
			INT_CNT <= 18'd0;
		end
		default:
		begin
			INT_CNT <= INT_CNT + 1;
		end
	endcase

// CPU clock

// 17.7MHz/5 = 3.54MHz
// LASER310 CPU：Z-80A/3.54MHz
// VZ300 CPU：Z-80A/3.54MHz

// 高速模式 50MHZ / 4  = 12.5MHz  ( TURBO_SPEED )
// 正常速度 50MHZ / 14 = 3.57MHz

// 同步内存操作
// 写 0 CPU 写信号和地址 1 锁存写和地址 2 完成写操作
// 读 0 CPU 读信号和地址 1 锁存读和地址 2 完读写操作，开始输出数据

// Write 0 CPU write signal and address 1 latch write and address 2 complete write operation
// Read 0 CPU read signal and address 1 Latch read and address 2 End read and write operations, output data

// 读取需要中间间隔一个时钟
// Reading requires an interval between the clocks


`ifdef SIMULATE
initial
	begin
		CLK = 4'b0;
	end
`endif

always @(posedge BASE_CLK or negedge RESET_N)
	if(~RESET_N)
	begin
		CPU_CLK					<=	1'b0;
		GPIO_CPU_CLK			<=	1'b0;

		// 复位期间设置，避免拨动开关引起错误
		// Sampled during reset to avoid the error caused by the switch toggling randomly
		LATCHED_DOSROM_EN		<=	SWITCH[1];

		LATCHED_BANK_0000		<=	{5'b0,SWITCH[6:4]};
		LATCHED_BANK_4000		<=	{5'b0,SWITCH[9:7]};

		LATCHED_BOOTROM_EN		<=	BOOTROM_EN;
		LATCHED_AUTOSTARTROM_EN	<=	AUTOSTARTROM_EN;

		//LATCHED_BOOTROM_EN		<=	1'b0;

		//LATCHED_FLASH_BANK_SW		<=	SWITCH[10];
		LATCHED_FLASH_BANK_SW	<=	1'b0;

`ifdef SHRG
		LATCHED_IO_SHRG			<=	8'b00001000;		// default to GM 010 mode: 128x64 colour + VRAM BANK 00
		// 复位期间设置，避免拨动开关引起错误
		// Sampled during reset to avoid the error caused by the switch toggling randomly
		LATCHED_SHRG_EN			<=	SWITCH[2];
`endif

`ifdef IO_BANK
		if(BOOTROM_EN)
			LATCHED_BANK_C000		<=	BOOTROM_BANK;
		else
			LATCHED_BANK_C000		<=	8'b0;

		if(AUTOSTARTROM_EN)
			LATCHED_BANK_4DEF		<=	AUTOSTARTROM_BANK;
		else
			LATCHED_BANK_4DEF		<=	8'b0;
`endif

`ifdef RAM_256K_EXPANSION
		// 复位期间设置，避免拨动开关引起错误
		LATCHED_RAM_256K_EN		<=	1'b1;
`endif

		MEM_OP_WR				<=	1'b0;

		LATCHED_KEY_DATA		<=	8'b0;
		LATCHED_IO_DATA_WR		<=	8'b0;

`ifdef FLASH_CHIP
`endif

`ifdef RAM_ON_SRAM_CHIP
		RAM_OE_N				<=	1'b1;
		RAM_WE_N				<=	1'b1;

		LATCHED_CPU_A			<=	16'b0;
		LATCHED_CPU_DO			<=	8'b0;
`endif

`ifdef RAM_ON_SSRAM_CHIP
		SSRAM_OE_N				<=	1'b1;
		SSRAM_WE_N				<=	1'b1;

		SSRAM_CE1_N				<=	1'b1;
		SSRAM_CE2				<=	1'b1;
		SSRAM_CE3_N				<=	1'b1;

		SSRAM_GW_N				<=	1'b1;

		SSRAM_ADSP_N			<=	1'b1;

		//LATCHED_CPU_A			<=	16'b0;
		LATCHED_CPU_DO			<=	8'b0;

		LATCHED_SSRAM_DO		<=	8'b0;
`endif

		//EMU_CASS_CLK <= 1'b0;
		CLK						<=	4'd0;

	end
	else
	begin
		case (CLK[3:0])
		4'd0:
			begin
				// 同步内存，等待读写信号建立
				// Synchronize memory, wait for read and write signals to be established
				CPU_CLK				<=	1'b1;
				GPIO_CPU_CLK		<=	1'b1;

				MEM_OP_WR			<=	1'b1;

				//EMU_CASS_CLK <= ~EMU_CASS_CLK;

`ifdef FLASH_CHIP
`endif

`ifdef RAM_ON_SRAM_CHIP
				// 异步SRAM内存，等待读写信号建立
				// Asynchronous SRAM memory, waiting for read and write signals to be established
				RAM_OE_N			<=	1'b1;
				RAM_WE_N			<=	1'b1;
`endif

`ifdef RAM_ON_SSRAM_CHIP
				// 同步SRAM内存，建立信号，在下个沿锁存地址
				// Synchronize SRAM memory, establish signal, latch address on next rising edge
				SSRAM_ADSP_N		<=	1'b0;

				SSRAM_OE_N			<=	1'b1;
				SSRAM_WE_N			<=	1'b1;

				SSRAM_GW_N			<=	1'b1;

				SSRAM_CE1_N			<=	1'b0;
				SSRAM_CE2			<=	1'b1;
				SSRAM_CE3_N			<=	1'b0;
`endif

				CLK					<=	4'd1;
			end

		4'd1:
			begin
				// 同步内存，锁存读写信号和地址
				// Synchronous memory, latch read and write signals and addresses
				
				CPU_CLK				<=	1'b0;
				MEM_OP_WR			<=	1'b0;

				LATCHED_KEY_DATA	<=	KEY_DATA;

				if({CPU_MREQ,CPU_RD,CPU_WR,ADDRESS_IO}==4'b1011)
					LATCHED_IO_DATA_WR	<=	CPU_DO;

`ifdef SHRG
				if(LATCHED_SHRG_EN)
					if({CPU_IORQ,CPU_RD,CPU_WR,ADDRESS_IO_SHRG}==4'b1011)
						LATCHED_IO_SHRG		<=	CPU_DO;
`endif


`ifdef IO_BANK
				if({CPU_IORQ,CPU_RD,CPU_WR,ADDRESS_IO_BANK}==4'b1011)
					LATCHED_BANK_C000	<=	CPU_DO;
`endif

`ifdef GPIO_PIN
`endif


`ifdef RAM_ON_SRAM_CHIP
				// 异步SRAM内存，锁存读写信号和地址，使能写信号
				// Asynchronous SRAM memory, latching read and write signals and addresses, enable write signals
				
				if({CPU_MREQ,CPU_RD,CPU_WR,ADDRESS_RAM_CHIP}==4'b1011)
				begin
					RAM_OE_N		<=	1'b1;
					RAM_WE_N		<=	1'b0;
				end
				else
				begin
					RAM_OE_N		<=	1'b1;
					RAM_WE_N		<=	1'b1;
				end

				LATCHED_CPU_A		<=	CPU_A;
				LATCHED_CPU_DO		<=	CPU_DO;
`endif

`ifdef RAM_ON_SSRAM_CHIP
				LATCHED_CPU_DO		<=	CPU_DO;

				// 同步SRAM内存 等待1个周期
				// Synchronize SRAM memory Wait 1 cycle
				SSRAM_ADSP_N		<=	1'b1;

				// 发送需要写入的数据
				// Send data out
				if({CPU_MREQ,CPU_RD,CPU_WR,ADDRESS_RAM_CHIP}==4'b1011)
					SSRAM_WE_N			<=	1'b0;

				SSRAM_CE1_N			<=	1'b1;
				SSRAM_CE2			<=	1'b1;
				SSRAM_CE3_N			<=	1'b1;
`endif


				CLK					<=	4'd2;
			end

		4'd2:
			begin
				// 完成读写操作，开始输出
				// Read and write operations, start output
				CPU_CLK				<=	1'b0;
				GPIO_CPU_CLK		<=	~TURBO_SPEED;

				MEM_OP_WR			<=	1'b0;

`ifdef FLASH_CHIP
`endif

`ifdef RAM_ON_SRAM_CHIP
				// 进行异步内存读写操作
				// 读取操作，下个周期可以读取
				// 写入操作，下个周期完成
				// Perform asynchronous memory read and write operations
				// Read operation, can be read in the next cycle
				// Write operation, completed in the next cycle
				if({CPU_MREQ,CPU_RD,CPU_WR,ADDRESS_RAM_CHIP}==4'b1101)
				begin
					RAM_WE_N		<=	1'b1;
					RAM_OE_N		<=	1'b0;
				end
				else
				begin
					RAM_WE_N		<=	1'b1;
					RAM_OE_N		<=	1'b0;
				end
`endif

`ifdef RAM_ON_SSRAM_CHIP
				// 同步SRAM内存 等待1个周期
				// Synchronize SRAM memory Wait 1 cycle
				SSRAM_WE_N			<=	1'b1;


				if({CPU_MREQ,CPU_RD,CPU_WR,ADDRESS_RAM_CHIP}==4'b1011)
				begin
					SSRAM_ADSP_N		<=	1'b1;

					SSRAM_OE_N			<=	1'b0;

					SSRAM_CE1_N			<=	1'b0;
					SSRAM_CE2			<=	1'b1;
					SSRAM_CE3_N			<=	1'b0;
				end
				else
				begin
					// 发送读取命令
					//Send read command
					SSRAM_ADSP_N		<=	1'b0;

					SSRAM_OE_N			<=	1'b0;

					SSRAM_CE1_N			<=	1'b0;
					SSRAM_CE2			<=	1'b1;
					SSRAM_CE3_N			<=	1'b0;
				end
`endif

				CLK					<=	4'd3;
			end

		4'd3:
			begin
`ifdef RAM_ON_SSRAM_CHIP
				LATCHED_SSRAM_DO	<=	SSRAM_DATA[7:0];

				SSRAM_ADSP_N		<=	1'b1;

				SSRAM_WE_N			<=	1'b1;
				SSRAM_OE_N			<=	1'b0;

				SSRAM_CE1_N			<=	1'b0;
				SSRAM_CE2			<=	1'b1;
				SSRAM_CE3_N			<=	1'b0;
`endif

				if(TURBO_SPEED)
					CLK				<=	4'd0;
				else
					CLK				<=	4'd4;
			end

		4'd7:
			begin
				CPU_CLK				<=	1'b0;
				GPIO_CPU_CLK		<=	1'b0;

				MEM_OP_WR			<=	1'b0;

				CLK					<=	4'd8;
			end

		// 正常速度
		4'd13:
			begin
				CPU_CLK				<=	1'b0;

				MEM_OP_WR			<=	1'b0;

`ifdef FLASH_CHIP
`endif

`ifdef RAM_ON_SRAM_CHIP
				// 异步SRAM内存，完成了写操作
				// Asynchronous SRAM memory, complete write operation
				RAM_WE_N			<=	1'b1;
				// 不改变读状态
				// Does not change the read status
`endif

`ifdef RAM_ON_SSRAM_CHIP
				// 同步SRAM内存，完成了写操作
				// Synchronize SRAM memory complete write operation
				SSRAM_WE_N			<=	1'b1;
				// 不改变读状态
				// Does not change the read status
`endif

				CLK					<=	4'd0;
			end
		default:
			begin
				CPU_CLK				<=	1'b0;

				MEM_OP_WR			<=	1'b0;

`ifdef FLASH_CHIP
`endif

`ifdef RAM_ON_SRAM_CHIP
				// 异步SRAM内存，完成了写操作
				RAM_WE_N			<=	1'b1;
				// 不改变读状态
`endif

`ifdef RAM_ON_SSRAM_CHIP
				// 同步SRAM内存，完成了写操作
				SSRAM_WE_N			<=	1'b1;
				// 不改变读状态
`endif

				CLK					<=	CLK + 1'b1;
			end
		endcase
	end

/*
// 另一种写法，给 CPU WAIT 信号，等待内存完成操作。
// Another way to write to the CPU WAIT signal is to wait for the memory to complete the operation.

reg	LATCHED_CPU_WAIT;

//always @ (negedge CLK50MHZ or negedge RESET_N)
always @ (posedge BASE_CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		CPU_WAIT <= 1'b0;
		LATCHED_IO_DATA_WR <= 8'b0;
	end
	else
	begin
		// CPU_WAIT 等2个周期
		LATCHED_CPU_WAIT <= CPU_WAIT;
		CPU_WAIT <= CPU_WAIT?~LATCHED_CPU_WAIT:CPU_MREQ;

		LATCHED_KEY_DATA <= KEY_DATA;

		if(CPU_WR&&ADDRESS_IO)
			LATCHED_IO_DATA_WR <= IO_DATA;
	end
end
*/

	//vga_pll vgapll(CLK50MHZ, VGA_CLOCK);
	/* This module generates a clock with half the frequency of the input clock.
	 * For the VGA adapter to operate correctly the clock signal 'clock' must be
	 * a 50MHz clock. The derived clock, which will then operate at 25MHz, is
	 * required to set the monitor into the 640x480@60Hz display mode (also known as
	 * the VGA mode).
	 */


//wire [7:0] InPort = ADDR[0] ? {3'b000, INP[2:0], vcount[9:8]} : vcount[7:0];

`ifdef GPIO_PIN
wire [7:0] InPort = GPIO_IN;
`else
wire [7:0] InPort = 8'b0;
`endif


// CPU

`ifdef NEXTZ80

assign CPU_RD = ~CPU_WR;

// 输入控制信号 RESET_N INT_N NMI_N WAIT_N BUSRQ_N DI

NextZ80 Z80CPU (
	.DI(CPU_IORQ ? (CPU_M1 ? 8'b00000000 : InPort) : CPU_DI),
	.DO(CPU_DO),
	.ADDR(CPU_A),
	.WR(CPU_WR),
	.MREQ(CPU_MREQ),
	.IORQ(CPU_IORQ),
	.HALT(CPU_HALT),
	.CLK(CPU_CLK),
	.RESET(CPU_RESET),
	.INT(CPU_INT),
	.NMI(CPU_NMI),
	.WAIT(CPU_WAIT),
	.M1(CPU_M1)
);

`endif


`ifdef TV80

assign CPU_M1 = ~CPU_M1_N;
assign CPU_MREQ = ~CPU_MREQ_N;
assign CPU_IORQ = ~CPU_IORQ_N;
assign CPU_RD = ~CPU_RD_N;
assign CPU_WR = ~CPU_WR_N;
assign CPU_RFSH = ~CPU_RFSH_N;
assign CPU_HALT= ~CPU_HALT_N;
assign CPU_BUSAK = ~CPU_BUSAK_N;

assign CPU_RESET_N = ~CPU_RESET;
assign CPU_WAIT_N = ~CPU_WAIT;
assign CPU_INT_N = ~CPU_INT;	// 50HZ
//assign CPU_INT_N = ~VGA_VS;	// 接 VGA 垂直回扫信号 60HZ
assign CPU_NMI_N = ~CPU_NMI;
assign CPU_BUSRQ_N = ~CPU_BUSRQ;

/*
  // Outputs
  m1_n, mreq_n, iorq_n, rd_n, wr_n, rfsh_n, halt_n, busak_n, A, dout,
  // Inputs
  reset_n, clk, wait_n, int_n, nmi_n, busrq_n, di
*/

tv80s Z80CPU (
	.m1_n(CPU_M1_N),
	.mreq_n(CPU_MREQ_N),
	.iorq_n(CPU_IORQ_N),
	.rd_n(CPU_RD_N),
	.wr_n(CPU_WR_N),
	.rfsh_n(CPU_RFSH_N),
	.halt_n(CPU_HALT_N),
	.busak_n(CPU_BUSAK_N),
	.A(CPU_A),
	.dout(CPU_DO),
	.reset_n(CPU_RESET_N),
	.clk(CPU_CLK),
	.wait_n(CPU_WAIT_N),
	.int_n(CPU_INT_N),
	.nmi_n(CPU_NMI_N),
	.busrq_n(CPU_BUSRQ_N),
	.di(CPU_IORQ_N ? CPU_DI : (CPU_M1_N ? InPort: 8'b00000000))
);

`endif

assign CPU_RESET = ~RESET_N;

assign CPU_NMI = 1'b0;

// LASER310 的 WAIT_N 始终是高电平。
assign CPU_WAIT = 1'b0;

//assign CPU_WAIT = CPU_MREQ && (~CLKStage[2]);


// 0000 -- 3FFF ROM 16KB
// 4000 -- 5FFF DOS
// 6000 -- 67FF BOOT ROM
// 6800 -- 6FFF I/O
// 7000 -- 77FF VRAM 2KB (SRAM 6116)
// 7800 -- 7FFF RAM 2KB
// 8000 -- B7FF RAM 14KB
// B800 -- BFFF RAM ext 2KB
// C000 -- F7FF RAM ext 14KB

assign ADDRESS_ROM				=	(CPU_A[15:14] == 2'b00)?1'b1:1'b0;
assign ADDRESS_DOSROM			=	(CPU_A[15:13] == 3'b010)?LATCHED_DOSROM_EN:1'b0;
assign ADDRESS_BOOTROM_6000		=	(CPU_A[15:11] == 5'b01100)?LATCHED_BOOTROM_EN:1'b0;
assign ADDRESS_AUTOSTARTROM		=	(CPU_A[15:12] == 4'h4||CPU_A[15:12] == 4'hD||CPU_A[15:12] == 4'hE||CPU_A[15:12] == 4'hF)?LATCHED_AUTOSTARTROM_EN:1'b0;
assign ADDRESS_IO				=	(CPU_A[15:11] == 5'b01101)?1'b1:1'b0;
assign ADDRESS_VRAM				=	(CPU_A[15:11] == 5'b01110)?1'b1:1'b0;

assign ADDRESS_89AB				=	(CPU_A[15:14] == 2'b10)?1'b1:1'b0;
assign ADDRESS_CDEF				=	(CPU_A[15:14] == 2'b11)?1'b1:1'b0;

// 7800 -- 7FFF RAM 2KB
assign ADDRESS_RAM_78			=	(CPU_A[15:11] == 5'b01111)?1'b1:1'b0;


// 7800 -- 7FFF RAM 2KB
// 8000 -- B7FF RAM 14KB

assign ADDRESS_RAM_16K		=	(CPU_A[15:12] == 4'h8)?1'b1:
								(CPU_A[15:12] == 4'h9)?1'b1:
								(CPU_A[15:12] == 4'hA)?1'b1:
								(CPU_A[15:11] == 5'b01111)?1'b1:
								(CPU_A[15:11] == 5'b10110)?1'b1:
								1'b0;

// B800 -- BFFF RAM ext 2KB
// C000 -- F7FF RAM ext 14KB

assign ADDRESS_RAM_16K_EXP	=	(CPU_A[15:12] == 4'hC)?1'b1:
								(CPU_A[15:12] == 4'hD)?1'b1:
								(CPU_A[15:12] == 4'hE)?1'b1:
								(CPU_A[15:11] == 5'b10111)?1'b1:
								(CPU_A[15:11] == 5'b11110)?1'b1:
								1'b0;

// 8 9 A B C D E F
assign ADDRESS_RAM_256K_EXP	=	({LATCHED_BANK_C000[7:4],CPU_A[15]} == 5'b00001);

assign ADDRESS_IO_SHRG		=	(CPU_A[7:0] == 8'd32)?1'b1:1'b0;					// I/O $20

// 64K RAM expansion cartridge vz300_review.pdf 中的端口号是 IO 7FH 127
// 128K SIDEWAYS RAM SHRG2 HVVZUG23 (Mar-Apr 1989).PDF 中的端口号是 IO 70H 112

assign ADDRESS_IO_BANK	=	(CPU_A[7:0] == 8'd127 || CPU_A[7:0] == 8'd112)?1'b1:1'b0;


`ifdef RAM_256K_EXPANSION

assign	ADDRESS_RAM_CHIP	=	ADDRESS_RAM_256K_EXP;

`else

`ifdef RAM_16K_EXPANSION
assign	ADDRESS_RAM_CHIP	=	ADDRESS_RAM_16K|ADDRESS_RAM_16K_EXP;
`else
assign	ADDRESS_RAM_CHIP	=	ADDRESS_RAM_16K;
`endif

`endif


assign VRAM_WR			= ({ADDRESS_VRAM,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;
assign RAM_78_WR		= ({ADDRESS_RAM_78,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;
assign RAM_16K_WR		= ({ADDRESS_RAM_16K,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;
assign RAM_16K_EXP_WR	= ({ADDRESS_RAM_16K_EXP,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;

assign RAM_256K_EXP_WR	= ({ADDRESS_RAM_256K_EXP,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;
assign RAM_256K_EXP_RD	= ({ADDRESS_RAM_256K_EXP,MEM_OP_WR,CPU_RD,CPU_IORQ} == 4'b1110)?1'b1:1'b0;

assign RAM_89AB_WR		= ({ADDRESS_89AB,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;
assign RAM_CDEF_WR		= ({ADDRESS_CDEF,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;

assign RAM_89AB_WR		= ({ADDRESS_89AB,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;
assign RAM_CDEF_WR		= ({ADDRESS_CDEF,MEM_OP_WR,CPU_WR,CPU_IORQ} == 4'b1110)?1'b1:1'b0;



`ifdef	RAM_ON_SRAM_CHIP
assign CPU_DI = 	ADDRESS_ROM				? SYS_ROM_DATA			:
					ADDRESS_AUTOSTARTROM	? AUTOSTART_ROM_DATA	:
					ADDRESS_DOSROM			? DOS_ROM_DATA			:
`ifdef BOOT_ROM_6000
					ADDRESS_BOOTROM_6000	? BOOT_ROM_6000_DATA	:
`endif
					ADDRESS_IO				? LATCHED_KEY_DATA		:
					ADDRESS_VRAM			? VRAM_DATA_OUT			:
					ADDRESS_RAM_78			? RAM_78_DATA			:
					ADDRESS_89AB			? RAM_89AB_DATA_OUT		:
					ADDRESS_CDEF			? MEM_CDEF_DATA_OUT		:
					8'hzz;
`endif


`ifdef	RAM_ON_SSRAM_CHIP
assign CPU_DI = 	ADDRESS_ROM				? SYS_ROM_DATA			:
					ADDRESS_AUTOSTARTROM	? AUTOSTART_ROM_DATA	:
					ADDRESS_DOSROM			? DOS_ROM_DATA			:
`ifdef BOOT_ROM_6000
					ADDRESS_BOOTROM_6000	? BOOT_ROM_6000_DATA	:
`endif
					ADDRESS_IO				? LATCHED_KEY_DATA		:
					ADDRESS_VRAM			? VRAM_DATA_OUT			:
					ADDRESS_RAM_78			? RAM_78_DATA			:
					ADDRESS_89AB			? RAM_89AB_DATA_OUT		:
					ADDRESS_CDEF			? MEM_CDEF_DATA_OUT		:
					8'hzz;
`endif


`ifdef	RAM_ON_FPGA
assign CPU_DI = 	ADDRESS_ROM				? SYS_ROM_DATA			:
					ADDRESS_AUTOSTARTROM	? AUTOSTART_ROM_DATA	:
					ADDRESS_DOSROM			? DOS_ROM_DATA			:
`ifdef BOOT_ROM_6000
					ADDRESS_BOOTROM_6000	? BOOT_ROM_6000_DATA	:
`endif
					ADDRESS_IO				? LATCHED_KEY_DATA		:
					ADDRESS_VRAM			? VRAM_DATA_OUT			:
`ifdef BASE_RAM_16K
					ADDRESS_RAM_16K			? RAM_16K_DATA_OUT		:
`endif
`ifdef RAM_16K_EXPANSION
					ADDRESS_RAM_16K_EXP		? RAM_16K_EXP_DATA_OUT	:
`else
`ifdef FLASH_CHIP
					ADDRESS_CDEF			? MEM_CDEF_DATA_OUT		:
`endif
`endif
					8'hzz;
`endif



`ifdef BASE_SYS_ROM
`ifdef FPGA_ALTERA
`ifdef WIDTH_64

// This ROM is 32KB.
// Low half is normal V2.0, top half is patched version of V2.0 for 64x16 text mode

sys_rom_altera_64 sys_rom(
	.address({SWITCH[3],CPU_A[13:0]}),			// SW3 selects 64x16 text mode
	.clock(BASE_CLK),
	.q(SYS_ROM_DATA)
);

`else

sys_rom_altera sys_rom(
	.address(CPU_A[13:0]),
	.clock(BASE_CLK),
	.q(SYS_ROM_DATA)
);

`endif
`endif

`endif


`ifdef BASE_DOS_ROM

`ifdef FPGA_ALTERA

dos_rom_altera dos_rom(
	.address(CPU_A[12:0]),
	.clock(BASE_CLK),
	.q(DOS_ROM_DATA)
);

`endif

`endif


`ifdef BASE_RAM_78

`ifdef FPGA_ALTERA

ram_2k_altera sys_ram_2k(
	.address(CPU_A[10:0]),
	.clock(BASE_CLK),
	.data(CPU_DO),
	.wren(CPU_MREQ & RAM_78_WR),
	.q(RAM_78_DATA)
);

`endif

`endif


`ifdef BOOT_ROM_6000

`ifdef FPGA_ALTERA

boot_rom_6000_altera boot_rom_6000(
	.address(CPU_A[8:0]),
	.clock(BASE_CLK),
	.q(BOOT_ROM_6000_DATA)
);

`endif

`endif



`ifdef FLASH_CHIP

// bank 1 bank255

// Altera DE1 4MB FLASH
`ifdef FLASH_CHIP_4M
//output	[21:0]	FL_ADDRESS;
assign	FL_ADDRESS[21:0]	=	(ADDRESS_AUTOSTARTROM)		?	{LATCHED_BANK_4DEF, CPU_A[13:0]}				:
								(ADDRESS_CDEF)				?	{LATCHED_BANK_C000, CPU_A[13:0]}				:
								(ADDRESS_DOSROM)			?	{5'b00001, LATCHED_BANK_4000[2:0], CPU_A[13:0]}	:
																{5'b00000, LATCHED_BANK_0000[2:0], CPU_A[13:0]}	;
`endif

// Altera DE2-70 8MB FLASH
`ifdef FLASH_CHIP_8M
//output	[22:0]	FL_ADDRESS;
assign	FL_ADDRESS[21:0]	=	(ADDRESS_AUTOSTARTROM)		?	{LATCHED_BANK_4DEF, CPU_A[13:0]}				:
								(ADDRESS_CDEF)				?	{LATCHED_BANK_C000, CPU_A[13:0]}				:
								(ADDRESS_DOSROM)			?	{5'b00001, LATCHED_BANK_4000[2:0], CPU_A[13:0]}	:
																{5'b00000, LATCHED_BANK_0000[2:0], CPU_A[13:0]}	;
assign	FL_ADDRESS[22]		=	LATCHED_FLASH_BANK_SW;
`endif

assign	FL_RESET_N	=	RESET_AHEAD_N;
assign	FL_CE_N		=	1'b0;
assign	FL_OE_N		=	1'b0;
assign	FL_WE_N		=	1'b1;


`ifndef BASE_SYS_ROM
assign	SYS_ROM_DATA	=	FL_DATA;
`endif

`ifndef BASE_DOS_ROM
assign	DOS_ROM_DATA	=	FL_DATA;
`endif

assign	AUTOSTART_ROM_DATA	=	FL_DATA;

`ifdef DE1
assign	FL_BYTE_N	=	1'b0;
//output	FL_DQ15;
//input		FL_RY;
assign	FL_WP_N		=	1'bz;
`endif

`ifdef DE2
assign	FL_BYTE_N	=	1'b0;
//output	FL_DQ15;
//input		FL_RY;
assign	FL_WP_N		=	1'bz;
`endif

`ifdef DE2_70
assign	FL_BYTE_N	=	1'b0;
//output	FL_DQ15;
//input		FL_RY;
assign	FL_WP_N		=	1'bz;
`endif

`ifdef DE2_115
//assign	FL_BYTE_N	=	1'b0;
//output	FL_DQ15;
//input		FL_RY;
assign	FL_WP_N		=	1'bz;
`endif


`else

assign	AUTOSTART_ROM_DATA	=	8'bz;

`endif



`ifdef	RAM_ON_SRAM_CHIP

// bank 0 bank15
wire	[3:0]	RAM_BANK		=	(ADDRESS_89AB) 						? 4'd0	:
									(LATCHED_BANK_C000[3:0] == 4'b0000)	? 4'd1	:
									LATCHED_BANK_C000[3:0]						;


`ifdef SRAM_CHIP_256x16

// Altera DE1 512K SRAM
// Altera DE2 512K SRAM

assign RAM_CS_N					=	1'b0;
assign RAM_BE0_N				=	1'b0;
assign RAM_BE1_N				=	1'b1;

assign	RAM_ADDRESS				=	{RAM_BANK,LATCHED_CPU_A[13:0]};
assign	RAM_89AB_DATA_OUT		=	RAM_DATA[7:0];
assign	RAM_CDEF_DATA_OUT		=	RAM_DATA[7:0];
assign	RAM_DATA[7:0]			=	RAM_OE_N?LATCHED_CPU_DO:8'bzzzz_zzzz;
assign	RAM_DATA[15:8]			=	8'bzzzz_zzzz;

`endif

`ifdef SRAM_CHIP_1024x16

// Altera DE2-115 2048K SRAM

assign RAM_CS_N					=	1'b0;
assign RAM_BE0_N				=	1'b0;
assign RAM_BE1_N				=	1'b1;

assign	RAM_ADDRESS				=	{2'b0,RAM_BANK,LATCHED_CPU_A[13:0]};
assign	RAM_89AB_DATA_OUT		=	RAM_DATA[7:0];
assign	RAM_CDEF_DATA_OUT		=	RAM_DATA[7:0];
assign	RAM_DATA[7:0]			=	RAM_OE_N?LATCHED_CPU_DO:8'bzzzz_zzzz;
assign	RAM_DATA[15:8]			=	8'bzzzz_zzzz;

`endif

`ifdef FLASH_CHIP
assign	MEM_CDEF_DATA_OUT	=	(LATCHED_BANK_C000[7:4]==4'b0)	?	RAM_CDEF_DATA_OUT	:	FL_DATA;
`else
assign	MEM_CDEF_DATA_OUT	=	(LATCHED_BANK_C000[7:4]==4'b0)	?	RAM_CDEF_DATA_OUT	:	8'bz;
`endif

`endif


`ifdef RAM_ON_SSRAM_CHIP

// bank 0 bank15
wire	[3:0]	RAM_BANK		=	(ADDRESS_89AB) 						? 4'd0	:
									(LATCHED_BANK_C000[3:0] == 4'b0000)	? 4'd1	:
									LATCHED_BANK_C000[3:0]						;

`ifdef SSRAM_CHIP_512x32

// Altera DE2-70 2048K SSRAM

assign	SSRAM_DPA		=	4'bz;		// SRAM Parity Data Bus

//output	wire	[18:0]	SSRAM_ADDRESS;					// Common address
//output	reg				SSRAM_WE_N;						// SRAM Global Write Enable
//output	reg				SSRAM_OE_N;

assign	SSRAM_CLK		=	BASE_CLK;

assign	SSRAM_ADDRESS	=	{RAM_BANK,CPU_A[13:0]};

//assign	SSRAM_BE_N		=	4'b1110;	// SRAM Byte Write Enable
assign	SSRAM_BE_N		=	4'b1110;	// SRAM Byte Write Enable
assign	SSRAM_ADSC_N	=	1'b1;		// SRAM Controller Address Status
//output	reg	SSRAM_ADSP_N;				// SRAM Processor Address Status
assign	SSRAM_ADV_N		=	1'b1;		// SRAM Burst Address Advance

assign	RAM_89AB_DATA_OUT		=	LATCHED_SSRAM_DO[7:0];
assign	RAM_CDEF_DATA_OUT		=	LATCHED_SSRAM_DO[7:0];

assign	SSRAM_DATA[7:0]			=	SSRAM_OE_N?LATCHED_CPU_DO:8'bzzzz_zzzz;
assign	SSRAM_DATA[31:8]		=	24'bzzzz_zzzz;

`endif

`ifdef FLASH_CHIP
assign	MEM_CDEF_DATA_OUT	=	(LATCHED_BANK_C000[7:4]==4'b0)	?	RAM_CDEF_DATA_OUT	:	FL_DATA;
`else
assign	MEM_CDEF_DATA_OUT	=	(LATCHED_BANK_C000[7:4]==4'b0)	?	RAM_CDEF_DATA_OUT	:	8'bz;
`endif

`endif



`ifdef	RAM_ON_FPGA


`ifdef BASE_RAM_16K

`ifdef FPGA_ALTERA

ram_altera sys_ram_16k(
	.address(CPU_A[13:0]),
	.clock(BASE_CLK),
	.data(CPU_DO),
	.wren(CPU_MREQ & RAM_16K_WR),
	.q(RAM_16K_DATA_OUT)
);

`endif

`endif


`ifdef RAM_16K_EXPANSION

`ifdef FPGA_ALTERA

ram_altera ram_16k_exp(
	.address(CPU_A[13:0]),
	.clock(BASE_CLK),
	.data(CPU_DO),
	.wren(CPU_MREQ & RAM_16K_EXP_WR),
	.q(RAM_16K_EXP_DATA_OUT)
);

`endif


`else

assign	RAM_16K_DATA_OUT		=	8'bz;
assign	RAM_16K_EXP_DATA_OUT	=	8'bz;

`endif


`endif


/*****************************************************************************
* Video
******************************************************************************/
// Request for every other line to be black
// Looks more like the original video


`ifdef VRAM_2K

`ifdef FPGA_ALTERA

vram_altera vram_2k(
	.address_a(CPU_A[10:0]),
	.address_b(VDG_ADDRESS[10:0]),
	.clock_a(BASE_CLK),
	.clock_b(VDG_RD),
	.data_a(CPU_DO),
	.data_b(),
	.wren_a(CPU_MREQ & VRAM_WR),
	.wren_b(1'b0),
	.q_a(VRAM_DATA_OUT),
	.q_b(VDG_DATA)
);

`endif

`endif


`ifdef VRAM_8K

`ifdef FPGA_ALTERA

vram_8k_altera vram_8k(
	.address_a({LATCHED_IO_SHRG[1:0],CPU_A[10:0]}),	// CPU only has a 2KB window for access. 
	.address_b(VDG_ADDRESS[12:0]),
	.clock_a(BASE_CLK),
	.clock_b(VDG_RD),
	.data_a(CPU_DO),
	.data_b(),
	.wren_a(CPU_MREQ & VRAM_WR),
	.wren_b(1'b0),
	.q_a(VRAM_DATA_OUT),
	.q_b(VDG_DATA)
);

`endif

`endif


// Video timing and modes
MC6847_VGA MC6847_VGA(
	.PIX_CLK(VGA_CLK),				//25 MHz = 40 nS
	.RESET_N(RESET_N),
	.width_64(SWITCH[3]),			// Switch 3 enables 64x16 text
	
	.RD(VDG_RD),						// same as pixel clock
	.DD(VDG_DATA),
	.DA(VDG_ADDRESS),

	.AG(LATCHED_IO_DATA_WR[3]),			// _A/G     	_Alphanumeric/Graphics
	.AS(1'b0),							// _A/S			_Alphanumeric/Semi-Graphics
	.EXT(1'b0),							// _INT/EXT		_Internal/external 
	.INV(1'b0),							// INV			0 = normal, 1 = inverse
`ifdef SHRG
	.GM(LATCHED_IO_SHRG[4:2]),			// GM[2:0]		Select 1 of 8 Gfx modes when _AG == 0
`else
	.GM(3'b010),						// fixed graphic 010 mode = 128x64 colour 
`endif
	.CSS(LATCHED_IO_DATA_WR[4]),		// CSS			Colour Set Select. 0 = BLACK/GREEN, 1 = BLACK/ORANGE

	// vga
	.VGA_OUT_HSYNC(VGA_OUT_HS),
	.VGA_OUT_VSYNC(VGA_OUT_VS),
	.VGA_OUT_RED(VGA_OUT_RED),
	.VGA_OUT_GREEN(VGA_OUT_GREEN),
	.VGA_OUT_BLUE(VGA_OUT_BLUE)
);


`ifdef VGA_RESISTOR

`ifdef VGA_BIT12
assign VGA_RED = VGA_OUT_RED[7:4];
assign VGA_GREEN = VGA_OUT_GREEN[7:4];
assign VGA_BLUE = VGA_OUT_BLUE[7:4];
`endif

assign VGA_HS = VGA_OUT_HS;
assign VGA_VS = VGA_OUT_VS;

`endif

`ifdef VGA_ADV7123

`ifdef VGA_BIT24
assign VGA_DAC_RED = VGA_OUT_RED;
assign VGA_DAC_GREEN = VGA_OUT_GREEN;
assign VGA_DAC_BLUE = VGA_OUT_BLUE;
`endif

`ifdef VGA_BIT30
assign VGA_DAC_RED = {VGA_OUT_RED,2'b0};
assign VGA_DAC_GREEN = {VGA_OUT_GREEN,2'b0};
assign VGA_DAC_BLUE = {VGA_OUT_BLUE,2'b0};
`endif

assign VGA_DAC_BLANK_N = 1'b1;
assign VGA_DAC_SYNC_N = ~(VGA_OUT_HS | VGA_OUT_VS);
assign VGA_DAC_CLOCK = VGA_CLK;

always @(posedge VGA_CLK)
	begin
		VGA_HS <= VGA_OUT_HS;
		VGA_VS <= VGA_OUT_VS;
	end

`endif


// keyboard

/*****************************************************************************
* Convert PS/2 keyboard to ASCII keyboard
******************************************************************************/

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

//  7: 0
// 15: 8
// 23:16
// 31:24
// 39:32
// 47:40
// 55:48
// 63:56

/*
`ifdef SIMULATE
initial
	begin
		LAST_KEY = 72'b0;
	end
`endif
*/

// 键盘检测的方法，就是循环地问每一行线发送低电平信号，也就是用该地址线为“0”的地址去读取数据。
// 例如，检测第一行时，使A0为0，其余为1；加上选通IC4的高五位地址01101，成为01101***11111110B（A8~A10不起作用，
// 可为任意值，故68FEH，69FEH，6AFEH，6BFEH，6CFEH，6DFEH，6EFEH，6FFEH均可）。
// 读 6800H 判断是否有按键按下。

// The method of keyboard detection is to cyclically ask each line to send a low level signal, 
// that is, to read the data with the address line "0".
// For example, when detecting the first line, make A0 0 and the rest 1; plus the high five-bit address 01101 of the strobe IC4, 
// become 01101***11111110B (A8~A10 does not work,
// It can be any value, so 68FEH, 69FEH, 6AFEH, 6BFEH, 6CFEH, 6DFEH, 6EFEH, 6FFEH can be).
// Read 6800H to determine if there is a button press.

// 键盘选通，整个竖列有一个选通的位置被按下，对应值为0。
// The keyboard is strobed, and a strobe position is pressed in the entire vertical column, and the corresponding value is 0.

// 键盘扩展
// 加入方向键盘
// Keyboard extension

// left:  ctrl M      37 KEY_EX[5]
// right: ctrl ,      35 KEY_EX[6]
// up:    ctrl .      33 KEY_EX[4]
// down:  ctrl space  36 KEY_EX[7]
// esc:   ctrl -      42 KEY_EX[3]
// backspace:  ctrl M      37 KEY_EX[8]

// R-Shift


wire	[63:0]	KEY_C		=	EMU_KEY_EN?EMU_KEY:KEY;
wire	[9:0]	KEY_EX_C	=	EMU_KEY_EN?EMU_KEY_EX:KEY_EX;

//wire KEY_CTRL_ULRD = (KEY_EX[7:4]==4'b1111);
wire KEY_CTRL_ULRD_BRK = (KEY_EX[8:3]==6'b111111);

wire KEY_DATA_BIT5 = (CPU_A[7:0]|{KEY_C[61], KEY_C[53], KEY_C[45],           KEY_C[37]&KEY_EX_C[5]&KEY_EX_C[8], KEY_C[29], KEY_C[21],           KEY_C[13],                   KEY_C[ 5]})==8'hff;
wire KEY_DATA_BIT4 = (CPU_A[7:0]|{KEY_C[60], KEY_C[52], KEY_C[44],           KEY_C[36]&KEY_EX_C[7], KEY_C[28], KEY_C[20],           KEY_C[12],                   KEY_C[ 4]})==8'hff;
wire KEY_DATA_BIT3 = (CPU_A[7:0]|{KEY_C[59], KEY_C[51], KEY_C[43],           KEY_C[35]&KEY_EX_C[6], KEY_C[27], KEY_C[19],           KEY_C[11],                   KEY_C[ 3]})==8'hff;
wire KEY_DATA_BIT2 = (CPU_A[7:0]|{KEY_C[58], KEY_C[50], KEY_C[42]&KEY_EX_C[3], KEY_C[34],           KEY_C[26], KEY_C[18]&KEY_EX_C[0], KEY_C[10]&KEY_CTRL_ULRD_BRK, KEY_C[ 2]})==8'hff;
wire KEY_DATA_BIT1 = (CPU_A[7:0]|{KEY_C[57], KEY_C[49], KEY_C[41],           KEY_C[33]&KEY_EX_C[4], KEY_C[25], KEY_C[17],           KEY_C[ 9],                   KEY_C[ 1]})==8'hff;
wire KEY_DATA_BIT0 = (CPU_A[7:0]|{KEY_C[56], KEY_C[48], KEY_C[40],           KEY_C[32],             KEY_C[24], KEY_C[16],           KEY_C[ 8],                   KEY_C[ 0]})==8'hff;

/*
wire KEY_DATA_BIT5 = (CPU_A[7:0]|{KEY[61], KEY[53], KEY[45], KEY[37], KEY[29], KEY[21], KEY[13], KEY[ 5]})==8'hff;
wire KEY_DATA_BIT4 = (CPU_A[7:0]|{KEY[60], KEY[52], KEY[44], KEY[36], KEY[28], KEY[20], KEY[12], KEY[ 4]})==8'hff;
wire KEY_DATA_BIT3 = (CPU_A[7:0]|{KEY[59], KEY[51], KEY[43], KEY[35], KEY[27], KEY[19], KEY[11], KEY[ 3]})==8'hff;
wire KEY_DATA_BIT2 = (CPU_A[7:0]|{KEY[58], KEY[50], KEY[42], KEY[34], KEY[26], KEY[18], KEY[10], KEY[ 2]})==8'hff;
wire KEY_DATA_BIT1 = (CPU_A[7:0]|{KEY[57], KEY[49], KEY[41], KEY[33], KEY[25], KEY[17], KEY[ 9], KEY[ 1]})==8'hff;
wire KEY_DATA_BIT0 = (CPU_A[7:0]|{KEY[56], KEY[48], KEY[40], KEY[32], KEY[24], KEY[16], KEY[ 8], KEY[ 0]})==8'hff;
*/

wire KEY_DATA_BIT7 = 1'b1;	// 没有空置，具体用途没有理解
//wire KEY_DATA_BIT6 = CASS_IN;
wire KEY_DATA_BIT6 = ~CASS_IN;

assign KEY_DATA = { KEY_DATA_BIT7, KEY_DATA_BIT6, KEY_DATA_BIT5, KEY_DATA_BIT4, KEY_DATA_BIT3, KEY_DATA_BIT2, KEY_DATA_BIT1, KEY_DATA_BIT0 };

/*
assign KEY_DATA = 	(CPU_A[0]==1'b0) ? KEY[ 7: 0] :
					(CPU_A[1]==1'b0) ? KEY[15: 8] :
					(CPU_A[2]==1'b0) ? KEY[23:16] :
					(CPU_A[3]==1'b0) ? KEY[31:24] :
					(CPU_A[4]==1'b0) ? KEY[39:32] :
					(CPU_A[5]==1'b0) ? KEY[47:40] :
					(CPU_A[6]==1'b0) ? KEY[55:48] :
					(CPU_A[7]==1'b0) ? KEY[63:56] :
					8'hff;

assign KEY_DATA =
					(CPU_A[7]==1'b0) ? KEY[63:56] :
					(CPU_A[6]==1'b0) ? KEY[55:48] :
					(CPU_A[5]==1'b0) ? KEY[47:40] :
					(CPU_A[4]==1'b0) ? KEY[39:32] :
					(CPU_A[3]==1'b0) ? KEY[31:24] :
					(CPU_A[2]==1'b0) ? KEY[23:16] :
					(CPU_A[1]==1'b0) ? KEY[15: 8] :
					(CPU_A[0]==1'b0) ? KEY[ 7: 0] :
					8'hff;
*/


assign A_KEY_PRESSED = (KEY[63:0] == 64'hFFFFFFFFFFFFFFFF) ? 1'b0:1'b1;

always @(posedge KB_CLK[3] or negedge SYS_RESET_N)
begin
	if(~SYS_RESET_N)
	begin
		KEY					<=	64'hFFFFFFFFFFFFFFFF;
		KEY_EX				<=	10'h3FF;
		KEY_Fxx				<=	12'h000;
//		CAPS_CLK			<=	1'b0;
		RESET_KEY_COUNT		<=	17'h1FFFF;

		BOOTROM_BANK		<=	0;
		BOOTROM_EN			<=	1'b0;

		AUTOSTARTROM_BANK	<=	0;
		AUTOSTARTROM_EN		<=	1'b0;
	end
	else
	begin
		//KEY[?] <= CAPS;
		if(RESET_KEY_COUNT[16]==1'b0)
			RESET_KEY_COUNT <= RESET_KEY_COUNT+1;

		case(SCAN)
		8'h07:
		begin
				KEY_Fxx[11]	<= PRESS;	// F12 RESET
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b0;
					BOOTROM_BANK		<=	0;
					AUTOSTARTROM_EN		<=	1'b0;
					AUTOSTARTROM_BANK	<=	0;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h78:	KEY_Fxx[10] <= PRESS;	// F11
		8'h09:	KEY_Fxx[ 9] <= PRESS;	// F10 CASS STOP
		8'h01:	KEY_Fxx[ 8] <= PRESS;	// F9  CASS PLAY
		8'h0A:
		begin
				KEY_Fxx[ 7] <= PRESS;	// F8  Ctrl or L-Shift BOOT 8
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	39;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	23;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h83:
		begin
				KEY_Fxx[ 6] <= PRESS;	// F7  Ctrl or L-Shift BOOT 7
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	38;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	22;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h0B:
		begin
				KEY_Fxx[ 5] <= PRESS;	// F6  Ctrl or L-Shift BOOT 6
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	37;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	21;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h03:
		begin
				KEY_Fxx[ 4] <= PRESS;	// F5  Ctrl or L-Shift BOOT 5
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	36;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	20;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h0C:
		begin
				KEY_Fxx[ 3] <= PRESS;	// F4  Ctrl or L-Shift BOOT 4
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	35;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	19;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h04:
		begin
				KEY_Fxx[ 2] <= PRESS;	// F3  Ctrl or L-Shift BOOT 3
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	34;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	18;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h06:
		begin
				KEY_Fxx[ 1] <= PRESS;	// F2  Ctrl or L-Shift BOOT 2
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	33;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	17;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end
		8'h05:
		begin
				KEY_Fxx[ 0] <= PRESS;	// F1  Ctrl or L-Shift BOOT 1
				if(PRESS && (KEY[18]==PRESS_N))
				begin
					BOOTROM_EN			<=	1'b1;
					BOOTROM_BANK		<=	32;
					RESET_KEY_COUNT		<=	17'h0;
				end
				else
				if(PRESS && (KEY[10]==PRESS_N))
				begin
					AUTOSTARTROM_EN		<=	1'b1;
					AUTOSTARTROM_BANK	<=	16;
					RESET_KEY_COUNT		<=	17'h0;
				end
		end

		8'h16:	KEY[28] <= PRESS_N;	// 1 !
		8'h1E:	KEY[25] <= PRESS_N;	// 2 @
		8'h26:	KEY[27] <= PRESS_N;	// 3 #
		8'h25:	KEY[29] <= PRESS_N;	// 4 $
		8'h2E:	KEY[24] <= PRESS_N;	// 5 %
		8'h36:	KEY[40] <= PRESS_N;	// 6 ^
		8'h3D:	KEY[45] <= PRESS_N;	// 7 &
//		8'h0D:	KEY[?] <= PRESS_N;	// TAB
		8'h3E:	KEY[43] <= PRESS_N;	// 8 *
		8'h46:	KEY[41] <= PRESS_N;	// 9 (
		8'h45:	KEY[44] <= PRESS_N;	// 0 )
		8'h4E:	KEY[42] <= PRESS_N;	// - _
//		8'h55:	KEY[?] <= PRESS_N;	// = +
		8'h66:	KEY_EX[8] <= PRESS_N;	// backspace
//		8'h0E:	KEY[?] <= PRESS_N;	// ` ~
//		8'h5D:	KEY[?] <= PRESS_N;	// \ |
		8'h49:	KEY[33] <= PRESS_N;	// . >
		8'h4b:	KEY[57] <= PRESS_N;	// L
		8'h44:	KEY[49] <= PRESS_N;	// O
//		8'h11	KEY[?] <= PRESS_N; // line feed (really right ALT (Extended) see below
		8'h5A:	KEY[50] <= PRESS_N;	// CR
//		8'h54:	KEY[?] <= PRESS_N;	// [ {
//		8'h5B:	KEY[?] <= PRESS_N;	// ] }
		8'h52:	KEY[58] <= PRESS_N;	// ' "
		8'h1D:	KEY[ 1] <= PRESS_N;	// W
		8'h24:	KEY[ 3] <= PRESS_N;	// E
		8'h2D:	KEY[ 5] <= PRESS_N;	// R
		8'h2C:	KEY[ 0] <= PRESS_N;	// T
		8'h35:	KEY[48] <= PRESS_N;	// Y
		8'h3C:	KEY[53] <= PRESS_N;	// U
		8'h43:	KEY[51] <= PRESS_N;	// I
		8'h1B:	KEY[ 9] <= PRESS_N;	// S
		8'h23:	KEY[11] <= PRESS_N;	// D
		8'h2B:	KEY[13] <= PRESS_N;	// F
		8'h34:	KEY[ 8] <= PRESS_N;	// G
		8'h33:	KEY[56] <= PRESS_N;	// H
		8'h3B:	KEY[61] <= PRESS_N;	// J
		8'h42:	KEY[59] <= PRESS_N;	// K
		8'h22:	KEY[17] <= PRESS_N;	// X
		8'h21:	KEY[19] <= PRESS_N;	// C
		8'h2a:	KEY[21] <= PRESS_N;	// V
		8'h32:	KEY[16] <= PRESS_N;	// B
		8'h31:	KEY[32] <= PRESS_N;	// N
		8'h3a:	KEY[37] <= PRESS_N;	// M
		8'h41:	KEY[35] <= PRESS_N;	// , <
		8'h15:	KEY[ 4] <= PRESS_N;	// Q
		8'h1C:	KEY[12] <= PRESS_N;	// A
		8'h1A:	KEY[20] <= PRESS_N;	// Z
		8'h29:	KEY[36] <= PRESS_N;	// Space
//		8'h4A:	KEY[?] <= PRESS_N;	// / ?
		8'h4C:	KEY[60] <= PRESS_N;	// ; :
		8'h4D:	KEY[52] <= PRESS_N;	// P
		8'h14:	KEY[10] <= PRESS_N;	// Ctrl either left or right
		8'h12:	KEY[18] <= PRESS_N;	// L-Shift
		8'h59:	KEY_EX[0] <= PRESS_N;	// R-Shift
		8'h11:
		begin
			if(~EXTENDED)
					KEY_EX[1] <= PRESS_N;	// Repeat really left ALT
			else
					KEY_EX[2] <= PRESS_N;	// LF really right ALT
		end
		8'h76:	KEY_EX[3] <= PRESS_N;	// Esc
		8'h75:	KEY_EX[4] <= PRESS_N;	// up
		8'h6B:	KEY_EX[5] <= PRESS_N;	// left
		8'h74:	KEY_EX[6] <= PRESS_N;	// right
		8'h72:	KEY_EX[7] <= PRESS_N;	// down
		endcase
	end
end


`ifdef SIMULATE
initial
	begin
		KB_CLK = 5'b0;
	end
`endif

always @ (posedge CLK50MHZ)				// 50MHz
	KB_CLK <= KB_CLK + 1'b1;			// 50/32 = 1.5625 MHz

ps2_keyboard KEYBOARD(
		.RESET_N(RESET_N),
		.CLK(KB_CLK[4]),
		.PS2_CLK(PS2_KBCLK),
		.PS2_DATA(PS2_KBDAT),
		.RX_SCAN(SCAN),
		.RX_PRESSED(PRESS),
		.RX_EXTENDED(EXTENDED)
);

assign PRESS_N = ~PRESS;


`ifdef AUDIO_WM8731

AUDIO_IF AUD_IF(
	//	Audio Side
	.oAUD_BCLK(AUD_BCLK),
	.oAUD_DACLRCK(AUD_DACLRCK),
	.oAUD_DACDAT(AUD_DACDAT),
	.oAUD_ADCLRCK(AUD_ADCLRCK),
	.iAUD_ADCDAT(AUD_ADCDAT),
	//	Control Signals
	.iSPK_A(SPEAKER_A),
	.iSPK_B(SPEAKER_B),
	.iCASS_OUT(CASS_OUT),
	.oCASS_IN_L(CASS_IN_L),
	.oCASS_IN_R(CASS_IN_R),
	// System
	.iCLK_18_4(AUD_CTRL_CLK),
	.iRST_N(RESET_N)
);

I2C_AV_Config AUD_I2C(
	//	Host Side
	.iCLK(CLK50MHZ),
	.iRST_N(RESET_N),
	//	I2C Side
	.I2C_SCLK(I2C_SCLK),
	.I2C_SDAT(I2C_SDAT)
);

assign	AUD_XCK = AUD_CTRL_CLK;

`endif


`ifdef AUDIO_GPIO
`endif

`ifdef CASS_EMU

wire			CASS_BUF_RD;
wire	[15:0]	CASS_BUF_A;
wire			CASS_BUF_WR;
wire	[7:0]	CASS_BUF_DAT;
wire	[7:0]	CASS_BUF_Q;

// F9    CASS PLAY
// F10   CASS STOP

EMU_CASS_KEY	EMU_CASS_KEY(
	KEY_Fxx[8],
	KEY_Fxx[9],
	// cass emu
	CASS_BUF_RD,
	//
	CASS_BUF_A,
	CASS_BUF_WR,
	CASS_BUF_DAT,
	CASS_BUF_Q,
	//	Control Signals
	EMU_CASS_EN,
	EMU_CASS_DAT,

	// key emu
	EMU_KEY,
	EMU_KEY_EX,
	EMU_KEY_EN,
    /*
     * UART: 115200 bps, 8N1
     */
    UART_RXD,
    UART_TXD,

	// System
	TURBO_SPEED,
	// Clock: 10MHz
	CLK10MHZ,
	RESET_N
);


`ifdef CASS_EMU_16K

cass_ram_16k_altera cass_buf(
	.address(CASS_BUF_A[13:0]),
	.clock(CLK10MHZ),
	.data(CASS_BUF_DI),
	.wren(CASS_BUF_WR),
	.q(CASS_BUF_Q)
);

`endif


`ifdef CASS_EMU_8K

cass_ram_8k_altera cass_buf(
	.address(CASS_BUF_A[12:0]),
	.clock(CLK10MHZ),
	.data(CASS_BUF_DI),
	.wren(CASS_BUF_WR),
	.q(CASS_BUF_Q)
);

`endif


`ifdef CASS_EMU_4K

cass_ram_4k_altera cass_buf(
	.address(CASS_BUF_A[11:0]),
	.clock(CLK10MHZ),
	.data(CASS_BUF_DAT),
	.wren(CASS_BUF_WR),
	.q(CASS_BUF_Q)
);

`endif


`ifdef CASS_EMU_2K

cass_ram_2k_altera cass_buf(
	.address(CASS_BUF_A[10:0]),
	.clock(CLK10MHZ),
	.data(CASS_BUF_DAT),
	.wren(CASS_BUF_WR),
	.q(CASS_BUF_Q)
);

`endif

`endif


`ifdef CASS_EMU

assign	CASS_OUT = EMU_CASS_EN ? EMU_CASS_DAT : {LATCHED_IO_DATA_WR[2], 1'b0};

`ifdef AUDIO_WM8731
assign	CASS_IN =  EMU_CASS_EN ? EMU_CASS_DAT[0] : CASS_IN_L;
`endif

`ifdef AUDIO_GPIO
assign	CASS_IN =  EMU_CASS_EN ? EMU_CASS_DAT[0] : 1'b0;
`endif

`else

assign	CASS_OUT		=	{LATCHED_IO_DATA_WR[2], 1'b0};

`ifdef AUDIO_WM8731
assign	CASS_IN			=	CASS_IN_L;
`endif

`ifdef AUDIO_GPIO
assign	CASS_IN			=	1'b0;
`endif

assign	EMU_KEY_EN		=	1'b0;

`endif


`ifdef GPIO_PIN
assign	GPIO_0[35:0]	=	36'bz;		//	GPIO Connection 0
//assign	GPIO_1[35:0]	=	36'bz;		//	GPIO Connection 1

`ifdef GPIO_TEST
assign	GPIO_IN			=	GPIO_1_IN[7:0];
//assign	LEDG			=	GPIO_IN;
//assign	LEDG			=	CPU_A[7:0];
//assign	LEDG			=	CPU_DO[7:0];
//assign	LEDG			=	CPU_IORQ?CPU_A[7:0]:8'b0;
//assign	LEDG			=	CPU_IORQ?CPU_DO[7:0]:8'b0;
assign	LEDG			=	(CPU_IORQ&(CPU_WR||CPU_RD))?CPU_A[7:0]:8'b0;


assign	GPIO_1[9:0]		=	10'bz;
//assign	GPIO_1[9:0]		=	{9'bz,GPIO_SW};
assign	GPIO_1[25:10]	=	{CPU_A[7:0],CPU_DO[7:0]};
assign	GPIO_1[35:26]	=	{5'bz, CPU_IORQ_N, CPU_RD_N, CPU_WR_N, CPU_RESET_N, GPIO_CPU_CLK};
`else
assign	GPIO_1[35:0]	=	36'bz;		//	GPIO Connection 1
`endif

`endif

// other

//(*keep*)wire trap = CPU_WR && (CPU_A == 16'h7000);
//(*keep*)wire trap = CPU_WR && (CPU_A == 16'h7000) && (CPU_DO!=8'h00);
//(*keep*)wire trap = CPU_WR && (CPU_A == 16'h7001) && (CPU_DO!=8'h00);
//(*keep*)wire trap = (VDG_ADDRESS == 11'h001);
//(*keep*)wire trap = CPU_RD && ADDRESS_IO && (CPU_DI[6]);
//(*keep*)wire trap = CPU_RD && (CPU_A == 16'h37B0);

//(*keep*)wire trap = CPU_RD && (CPU_A == 16'h6800);
//(*keep*)wire trap = (CPU_RD|CPU_WR) && (CPU_A == 16'h8000);
//(*keep*)wire trap = (CPU_RD|CPU_WR) && (CPU_A[15:12] == 4'hC);
(*keep*)wire trap = (CPU_RD|CPU_WR) && (CPU_A[15:12] == 4'h0);
//(*keep*)wire trap = (CPU_RD|CPU_WR) && (CPU_A[15] == 1'b1);

//(*keep*)wire trap = CPU_IORQ&&(CPU_WR||CPU_RD);

// boot rom start
//(*keep*)wire trap = CPU_RD && (CPU_A == 16'h6004);

// boot rom halt
//(*keep*)wire trap = CPU_RD && CPU_MREQ && (CPU_A == 16'h606d);

// boot rom jp rom start
//(*keep*)wire trap = CPU_RD && CPU_MREQ && (CPU_A == 16'h606c);

//(*keep*)wire trap = 1'b0;

//(*keep*)wire	ADDR_FLAG = ADDRESS_IO&&(CPU_A[7:0]!=8'h00);
//assign LED = {RESET_N, ADDR_FLAG, KEY[ 7: 0]!=8'hff, KEY[15: 8]!=8'hff, KEY[23:16]!=8'hff, KEY[31:24]!=8'hff, KEY[39:32]!=8'hff, KEY[47:40]!=8'hff, KEY[55:48]!=8'hff, KEY[63:56]!=8'hff};
//assign LED = {RESET_N, CLK50MHZ, CLKStage, trap, KB_CLK, A_KEY_PRESSED, PS2_KBDAT, BUTTON[0]};

//assign LED = {CASS_IN_L, CASS_IN_R, CASS_OUT, SPEAKER_A, SPEAKER_B, AUD_ADCDAT, A_KEY_PRESSED, PS2_KBDAT, RESET_N, TURBO_SPEED};
//assign LED = {CASS_IN, CASS_IN_L, CASS_IN_R, CASS_OUT, EMU_CASS_DAT, (SPEAKER_A==SPEAKER_B), A_KEY_PRESSED, ~RESET_N, GPIO_SW, LATCHED_SHRG_EN, LATCHED_DOSROM_EN, TURBO_SPEED};
`ifdef GPIO_TEST
assign LED = {CASS_IN, CASS_IN_L, CASS_IN_R, CASS_OUT, EMU_CASS_DAT, A_KEY_PRESSED, GPIO_SW, LATCHED_SHRG_EN, LATCHED_DOSROM_EN, TURBO_SPEED};
//assign LED = {CASS_IN, CASS_IN_L, CASS_IN_R, CASS_OUT, EMU_CASS_DAT, A_KEY_PRESSED, trap, LATCHED_SHRG_EN, LATCHED_DOSROM_EN, TURBO_SPEED};
`else
assign LED = {CASS_IN, CASS_IN_L, CASS_IN_R, CASS_OUT, EMU_CASS_DAT, A_KEY_PRESSED, trap, LATCHED_SHRG_EN, LATCHED_DOSROM_EN, TURBO_SPEED};
//assign LED = {LATCHED_BANK_0000, LATCHED_DOSROM_EN, TURBO_SPEED};
//assign LED = {LATCHED_IO_SHRG[4:2], CASS_OUT, EMU_CASS_DAT, A_KEY_PRESSED, trap, LATCHED_SHRG_EN, LATCHED_DOSROM_EN, TURBO_SPEED};
`endif

endmodule
