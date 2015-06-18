/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_base_test.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.2 $
// Last Update   : $Date: 2012/03/26 12:04:16 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// 検証環境モデルトップ(ベース)
/////////////////////////////////////////////////////////////////////////////
class verienv_apb2iic_base_test extends ovm_test;
	`ovm_component_utils(verienv_apb2iic_base_test)
	
	// 機能モデル
	verienv_apb2iic_config       m_config;         ///< テストコンフィグ
	verienv_apb2iic_v_sequencer  sys_v_sequencer;  ///< シーケンサ
	ovm_table_printer         printer;          ///< メッセージ表示用プリンタ
	
	/// コンストラクタ
	function new(string name="" ,ovm_component parent=null);
		super.new(name ,parent);
		m_config = new; // 最上位コンフィグレーションクラスの作成
	endfunction
	
	/// 環境構築
	virtual function void build;
		super.build;
		// コンフィグレーション処理
		$display("Config VERIENV_PORT");
		m_config.intf          = ovm_container#(virtual verienv_apb2iic_if)::get_value_from_config(this ,"VERIENV_PORT");
		m_config.sys_clk_cycle = ovm_container#(time                   )::get_value_from_config(this ,"SYS_CLK_CYCLE");
		
		// オーバーライド
		
		// コンポーネント生成
		sys_v_sequencer = verienv_apb2iic_v_sequencer::type_id::create  ("sys_v_sequencer" ,this);
		
		// コンフィグレーションオブジェクトの展開
		set_config_object("*"             ,"verienv_apb2iic_config" ,m_config               ,0);
		
		// システムクロック設定
		m_config.intf.CLK_CYCLE = m_config.sys_clk_cycle;
		
		// プリンター設定
		printer = new();
		printer.knobs.name_width  = 25+25;
		printer.knobs.type_width  = 20+10;
		printer.knobs.size_width  = 5;
		printer.knobs.value_width = 20+10;
	endfunction
	
	/// コンポーネント間接続
	function void connect;
	//	sys_v_sequencer.hoge_v_seqr = hoge.v_sequencer;
	endfunction
	
	/// 検証環境構成の表示
	function void end_of_elaboration();
		`ovm_info(get_type_name(),$psprintf("<<< Verification Infomation >>>\n%s", this.sprint(printer)), OVM_LOW)
	endfunction : end_of_elaboration
	
	/// シミュレーション
	task run;
		`ovm_info("INFO",$psprintf("%s--- Simulation Start ---%s",{`VT100_GREEN},{`VT100_NORMAL}),OVM_LOW)
		// システムクロックの生成
		// シナリオタイムアウト(10msec)
		for(int i=0;i<10;i++)begin
			$display("%ssimulation time = %12.3f[ns]%s",{`VT100_YELLOW},$time/1000.0,{`VT100_NORMAL});
			#1ms;
		end
		`ovm_error("SYSTEM",$psprintf("%s***** senario timeout !! *****%s",{`VT100_RED},{`VT100_NORMAL}))
		global_stop_request;
	endtask
	
	function void report;
		ovm_report_server rep;
		
		super.report;
		`ovm_info("INFO",$psprintf("%s--- Simulation End ---%s",{`VT100_GREEN},{`VT100_NORMAL}),OVM_LOW)
		rep = ovm_top.get_report_server();
		if(rep.get_severity_count(OVM_FATAL))begin
			$display("");
			$display("%s #######                           ##%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  #    #           #                #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  #                #                #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  #  #    ####    ####    ####      #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  ####        #    #          #     #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  #  #    #####    #      #####     #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  #      #    #    #     #    #     #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s  #      #    #    #  #  #    #     #%s"  ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s ####     #### #    ##    #### #  #####%s",{`VT100_RED},{`VT100_NORMAL});
		end else
		if(rep.get_severity_count(OVM_ERROR))begin
			$display("");
			$display("%s #######%s"                                 ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #%s"                                       ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #%s"                                       ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #         # ###   # ###   ###     # ###%s" ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s ######    ##      ##     #   #    ##%s"    ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #         #       #     #     #   #%s"     ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #         #       #     #     #   #%s"     ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #         #       #      #   #    #%s"     ,{`VT100_RED},{`VT100_NORMAL});
			$display("%s #######   #       #       ###     #%s"     ,{`VT100_RED},{`VT100_NORMAL});
		end else
		if(rep.get_severity_count(OVM_WARNING))begin
			$display("");
			$display("%s ### ###                            #%s"                   ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s  #   #%s"                                                 ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s  #   #%s"                                                 ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s  #   #   ####   ### ##  ## ##    ###    ## ##    ######%s",{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s  # # #       #    ##  #  ##  #     #     ##  #  #    #%s" ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s  # # #   #####    #      #   #     #     #   #  #    #%s" ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s  # # #  #    #    #      #   #     #     #   #  #    #%s" ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s   # #   #    #    #      #   #     #     #   #   #####%s" ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s   # #    #### # #####   ### ###  #####  ### ###      #%s" ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s                                                      #%s" ,{`VT100_YELLOW},{`VT100_NORMAL});
			$display("%s                                                  ####%s"  ,{`VT100_YELLOW},{`VT100_NORMAL});
		end else begin
			$display("");
			$display("%s   ####   ###  ##     #   # %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s  #||||#   #   #     ##  ## %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s #-  -  #  #  #      ##  ## %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s #@  @  #  #  #      ##  ## %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s # ,    #  # #       ##  ## %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s # ___  #  ###       #   #  %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s #  _/  #  #  #      #   #  %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s  #    #   #   #            %s" ,{`VT100_GREEN},{`VT100_NORMAL});
			$display("%s   ####   ###  ##   ##  ##  %s" ,{`VT100_GREEN},{`VT100_NORMAL});
		end
	endfunction
endclass
