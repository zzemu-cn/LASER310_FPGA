set_global_assignment -entity "C5_CLK10MHZ_PLL" -library "lib_C5_CLK10MHZ_PLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "C5_CLK10MHZ_PLL" -library "lib_C5_CLK10MHZ_PLL" -name IP_TOOL_VERSION "18.0"
set_global_assignment -entity "C5_CLK10MHZ_PLL" -library "lib_C5_CLK10MHZ_PLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_C5_CLK10MHZ_PLL" -name SPD_FILE [file join $::quartus(sip_path) "C5_CLK10MHZ_PLL.spd"]

set_global_assignment -library "lib_C5_CLK10MHZ_PLL" -name MISC_FILE [file join $::quartus(sip_path) "C5_CLK10MHZ_PLL_sim/C5_CLK10MHZ_PLL.vo"]
