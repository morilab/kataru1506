/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: tb_top.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.3 $
// Last Update   : $Date: 2012/10/19 13:13:44 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// 検証環境モジュール
// 全体検証環境
/////////////////////////////////////////////////////////////////////////////
// OVM標準ライブラリ
import ovm_pkg::*;            ///< OVM標準ライブラリ
import ovm_container_pkg::*;  ///< OVM用コンテナライブラリ
`include "ovm_macros.svh"

// インターフェース宣言
`include "verienv_apb2iic_if.sv" ///< 検証環境インターフェース

// ラッパー
`include "DUV.v"

/// 検証トップモジュール
module tb_top();
	timeunit      1ps;
	timeprecision 1ps;
	
	// OVMモデルライブラリ
	import verienv_apb2iic_pkg::*;    ///< OVM検証環境
	
	// 型宣言
	typedef virtual verienv_apb2iic_if  verienv_t;
	
	// インターフェース
	verienv_apb2iic_if verienv_port();
	
	// 検証RTLトップ
	DUV DUV (                                 // <DUV>
		.port_if          (verienv_port     ) // verienv_apb2iic_if
	);                                        // </>
	
	///< OVM処理
	initial begin
	//	$timeformat(-12.0,"[ps]",16); // ModelSim非対応
		ovm_container#(verienv_t)::set_value_in_global_config("VERIENV_PORT"  ,verienv_port);
		ovm_container#(time     )::set_value_in_global_config("SYS_CLK_CYCLE" ,10*1000);       // クロック周期[ps]
		run_test();
	end
endmodule
