/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic.svh,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 06:00:20 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// 検証環境
/////////////////////////////////////////////////////////////////////////////
package verienv_apb2iic_pkg;
	`include "vt100.svh"
	`include "ovm_macros.svh"
	import ovm_pkg::*;
	import ovm_container_pkg::*;
	import ovm_ScoreBoard_pkg::*; ///< OVMスコアボード
	import xml_report_server_pkg::*;
	/* 必要なモデルがある場合はここでインポートする */
	
	`include "verienv_apb2iic_share.sv"       // 共通変数
	`include "verienv_apb2iic_config.sv"      // コンフィグ
	`include "verienv_apb2iic_v_sequencer.sv" // 全体制御シーケンサ
	`include "verienv_apb2iic_seq_lib.sv"     // シーケンスライブラリ
	`include "verienv_apb2iic_base_test.sv"   // テスト基本設定
	`include "verienv_apb2iic_test_list.sv"   // 試験項目一覧
endpackage
