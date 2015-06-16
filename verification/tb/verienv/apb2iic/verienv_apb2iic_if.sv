/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_if.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.3 $
// Last Update   : $Date: 2012/10/19 12:34:19 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// インターフェース
// 検証環境トップ汎用ポート
/////////////////////////////////////////////////////////////////////////////

/// apb2iic用インターフェース
interface verienv_apb2iic_if();
	timeunit      1ps;
	timeprecision 1ps;
	
	// パラメータ
	time CLK_CYCLE = 0;
	
	// 接続ポート<CNCT>
	logic       pclk;           ///< 
	logic       presetn;        ///< 
	logic[31:0] paddr;          ///< 
	logic[31:0] pwdata;         ///< 
	logic       pwrite;         ///< 
	logic       pselx;          ///< 
	logic       penable;        ///< 
	logic       pready;         ///< 
	logic       pslverr;        ///< 
	logic       int_rx;         ///< 
	logic       int_tx;         ///< 
	logic[31:0] prdata;         ///< 
	logic       sda_enable;     ///< 
	logic       scl_enable;     ///< 
	wire        sda;            ///< 
	wire        scl;            ///< 
	
	reg         r_pclk;
	reg         r_presetn;
	reg  [31:0] r_paddr;
	reg  [31:0] r_pwdata;
	reg         r_pwrite;
	reg         r_pselx;
	reg         r_penable;
	reg         r_sda;
	reg         r_scl;
	assign pclk             = r_pclk;
	assign presetn          = r_presetn;
	assign paddr            = r_paddr;
	assign pwdata           = r_pwdata;
	assign pwrite           = r_pwrite;
	assign pselx            = r_pselx;
	assign penable          = r_penable;
	assign sda              = r_sda;
	assign scl              = r_scl;
	//</>
	
	// クロック生成回路
	// 周期を0に設定した場合、クロックの生成を行わない。
	always begin
		if(CLK_CYCLE>0)begin
			#(CLK_CYCLE/2.0);
			r_pclk = 1;
			#(CLK_CYCLE - CLK_CYCLE/2.0);
			r_pclk = 0;
		end else begin
			r_pclk = 1'bz;
			@CLK_CYCLE;
		end
	end
	always @(CLK_CYCLE)begin
		if(CLK_CYCLE>0)begin
			deassign r_pclk;
		end else begin
			assign r_pclk = 1'bz;
		end
	end
endinterface
