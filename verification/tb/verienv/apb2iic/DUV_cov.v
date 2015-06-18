/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: DUV.v,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.2 $
// Last Update   : $Date: 2012/10/19 13:13:44 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// TOP検証用トップモジュール
/////////////////////////////////////////////////////////////////////////////
module DUV(
);
	
	//トップモジュール                                  // <DUV>
	i2c u_i2c (
		.PCLK             (port_if.pclk             ) , // in
		.PRESETn          (port_if.presetn          ) , // in
		.PADDR            (port_if.paddr            ) , // in[31:0]
		.PWDATA           (port_if.pwdata           ) , // in[31:0]
		.PWRITE           (port_if.pwrite           ) , // in
		.PSELx            (port_if.pselx            ) , // in
		.PENABLE          (port_if.penable          ) , // in
		.PREADY           (port_if.pready           ) , // out
		.PSLVERR          (port_if.pslverr          ) , // out
		.INT_RX           (port_if.int_rx           ) , // out
		.INT_TX           (port_if.int_tx           ) , // out
		.PRDATA           (port_if.prdata           ) , // out[31:0]
		.SDA_ENABLE       (port_if.sda_enable       ) , // out
		.SCL_ENABLE       (port_if.scl_enable       ) , // out
		.SDA              (port_if.sda              ) , // io
		.SCL              (port_if.scl              )   // io
	);                                                  // </>
endmodule
