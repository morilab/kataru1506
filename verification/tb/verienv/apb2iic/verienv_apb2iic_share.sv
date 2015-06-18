/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_share.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.2 $
// Last Update   : $Date: 2012/10/19 12:34:19 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// 共有変数
/////////////////////////////////////////////////////////////////////////////

// モジュールトップ端子<ENUM>
typedef enum {
	PORT_PCLK               , 
	PORT_PRESETN            , 
	PORT_PADDR              , 
	PORT_PWDATA             , 
	PORT_PWRITE             , 
	PORT_PSELX              , 
	PORT_PENABLE            , 
	PORT_PREADY             , 
	PORT_PSLVERR            , 
	PORT_INT_RX             , 
	PORT_INT_TX             , 
	PORT_PRDATA             , 
	PORT_SDA_ENABLE         , 
	PORT_SCL_ENABLE         , 
	PORT_SDA                , 
	PORT_SCL                  
} verienv_apb2iic_port;
//</>
