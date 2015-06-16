`ifndef VT100_MONO
	`define VT100_NORMAL  8'h1b,"[0m"
	`define VT100_RED     8'h1b,"[31m"
	`define VT100_GREEN   8'h1b,"[32m"
	`define VT100_YELLOW  8'h1b,"[33m"
	`define VT100_BLUE    8'h1b,"[34m"
	`define VT100_MAGENTA 8'h1b,"[35m"
	`define VT100_CYAN    8'h1b,"[36m"
	`define VT100_WHITE   8'h1b,"[37m"
`else
	`define VT100_NORMAL  ""
	`define VT100_RED     ""
	`define VT100_GREEN   ""
	`define VT100_YELLOW  ""
	`define VT100_BLUE    ""
	`define VT100_MAGENTA ""
	`define VT100_CYAN    ""
	`define VT100_WHITE   ""
`endif
