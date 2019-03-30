module CHAR_GEN_ROM
(
	input        pixel_clock,
	input		 	 GM0,
	input [11:0] address,
	output [7:0] data
);

wire lcase_add = GM0 & !(address[11] | address[10] | address[9]);		// A[11:9] = char[7:5]  $00-$1F
// test only
//wire lcase_add = !(address[11] | address[10] | address[9]);		// A[11:9] = char[7:5]  $00-$1F

`ifdef LCASE

// 6847T1 Character generator
char_rom_4k_lcase_altera char_rom(
	.address({lcase_add,address}),				// lcase == select for lower case chars, which sit above normal font defs
	.clock(pixel_clock),
	.q(data)
);

`else

// Old character generator
char_rom_4k_altera char_rom(
	.address(address),
	.clock(pixel_clock),
	.q(data)
);

`endif

endmodule //CHAR_GEN_ROM
