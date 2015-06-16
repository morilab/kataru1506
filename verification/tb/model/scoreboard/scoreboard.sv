/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : 2011/12/18 12:00:00
// Design Name   : $RCSfile: scoreboard.sv,v $
// Project Name  : ScoreBoard
// Project No.   : 
// Syntax        : OVM2.0.3
// Tool versions : ModelSim10.1
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 05:38:30 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
///@brief   スコアボードクラス
///@details 期待値、観測値を受け取るアナリシスエクスポートを持ちます。
///         扱うトランザクションアイテムの型はパラメータで指定します。
///         期待値と観測値の比較方法はset_config_intで指定します。
////////////////////////////////////////////////////////////////////////////////
class scoreboard #(type T=ovm_sequence_item) extends ovm_scoreboard;
	`ovm_component_param_utils_begin(scoreboard#(T))
		`ovm_field_string(msg_index ,OVM_ALL_ON)
	`ovm_component_utils_end
	
	string                                     msg_index;            ///< メッセージインデックス
	scoreboard_subscriber #(T)                 item_comp;            ///< 汎用比較器
	ovm_analysis_imp      #(T ,scoreboard#(T)) exp_collected_export; ///< 期待値アナリシスエクスポート
	ovm_analysis_export   #(T)                 dat_collected_export; ///< 観測値アナリシスエクスポート
	
	////////////////////////////////////////////////////////////////////////////
	///@name OVMフェーズ
	///      OVM標準のシミュレーションフェーズメソッド
	//////////////////////////////////////////////////////////////////////////@{
	/// コンストラクタ
	function new (string name, ovm_component parent);
		super.new(name, parent);
		exp_collected_export = new("exp_port",this);
		dat_collected_export = new("dat_port",this);
	endfunction : new
	/// 環境構築
	virtual function void build();
		super.build;
		item_comp = scoreboard_subscriber#(T)::type_id::create("SB",this);
	endfunction
	
	/// コンポーネント間接続
	virtual function void connect;
		dat_collected_export.connect(item_comp.analysis_export);
	endfunction
	
	/// 環境設定
    virtual function void end_of_elaboration();
		if(msg_index=="")begin
			msg_index = $psprintf("%s",get_full_name());
		end
		item_comp.msg_index = msg_index;
    endfunction
	
	/// 期待値アナリシスエクスポート処理
	virtual function void write(T tr);
		T exp;
		$cast(exp,tr.clone());
		exp = item_comp.exp_filter(exp);
		if(exp!=null)begin
			item_comp.exp.push_back(exp);
			item_comp.exp_item_num++;
			fork
				item_comp.do_compare_item;
			join_none
		end
	endfunction
	//////////////////////////////////////////////////////////////////////////@}
	
	/// スコアボードの初期化
	virtual function void reset;
		item_comp.reset;
	endfunction
endclass
