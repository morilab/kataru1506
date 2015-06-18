/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : 2012/01/30 12:00:00
// Design Name   : $RCSfile: scoreboard.svh,v $
// Project Name  : ScoreBoard
// Project No.   : 
// Syntax        : OVM2.0.3
// Tool versions : ModelSim10.1
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 05:38:30 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// 汎用スコアボード
/////////////////////////////////////////////////////////////////////////////
package ovm_ScoreBoard_pkg;
	`include "vt100.svh"
	`include "ovm_macros.svh"
	import ovm_pkg::*;
	// 全体
	`include "scoreboard_share.sv"
	`include "scoreboard_subscriber.sv"
	`include "scoreboard_ram_subscriber.sv"
	`include "scoreboard.sv"
endpackage
