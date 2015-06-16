/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : 2011/12/18 12:00:00
// Design Name   : $RCSfile: scoreboard_subscriber.sv,v $
// Project Name  : ScoreBoard
// Project No.   : 
// Syntax        : OVM2.0.3
// Tool versions : ModelSim10.1
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 05:38:32 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
///@brief   スコアボード用比較器
///@details 指定ルールに従い、2つのトランザクションアイテムの比較を行います。
///         受け取った期待値、観測値はそれぞれフィルタ関数で必要に応じて前処理を
///         行ってから比較を行い、シミュレーション終了時に最終レポートを出力します。
////////////////////////////////////////////////////////////////////////////////
class scoreboard_subscriber#(type T=ovm_sequence_item) extends ovm_subscriber#(T);
	string       msg_index;     ///< メッセージインデックス
	T            dat[$];        ///< 観測値リスト
	T            exp[$];        ///< 期待値リスト
	chk_rule     rule;          ///< 比較方法設定
	int          dat_item_num;  ///< 観測値の数
	int          exp_item_num;  ///< 期待値の数
	int          error_num;     ///< 不一致した数
	int          collect_num;   ///< 一致した数
	ovm_comparer cmp;           ///< 比較器
	protected    semaphore sem; ///< セマフォ
	
	`ovm_component_param_utils_begin(scoreboard_subscriber#(T))
		`ovm_field_string(msg_index       ,OVM_ALL_ON)
		`ovm_field_enum  (chk_rule  ,rule ,OVM_ALL_ON)
	`ovm_component_utils_end
	
	///@brief   期待値フィルタ
	///@details 期待値リストへ追加する前に、トランザクションアイテム自体を
	///         変更することが可能です。
	///@return  リストへ追加するトランザクションアイテムの参照を返します。
	///         nullの場合、リストへは追加されません。
	///@note    一般的には関数のオーバーライドを行い、期待した動作をするように修正します。
	virtual function T exp_filter(T tr);
		return tr;
	endfunction
	
	///@brief   観測値フィルタ
	///@details 観測値リストへ追加する前に、トランザクションアイテム自体を
	///         変更することが可能です。
	///@return  リストへ追加するトランザクションアイテムの参照を返します。
	///         nullの場合、リストへは追加されません。
	///@note    一般的には関数のオーバーライドを行い、期待した動作をするように修正します。
	virtual function T dat_filter(T tr);
		return tr;
	endfunction
	
	////////////////////////////////////////////////////////////////////////////
	///@name 比較処理
	///      期待値、観測値の比較を行う関数群です。
	//////////////////////////////////////////////////////////////////////////@{
	
	///@brief   比較処理の選択・実行
	///@details 指定ルールに従い、2つのトランザクションアイテムの比較を行います。
	virtual task do_compare_item;
		sem.get;
		case(rule)
		OUT_ORDER  : check_item_outorder;
		IN_ORDER   : check_item_inorder;
		COUNT_ONLY : check_item_countonly;
		NO_COMPARE : check_item_nocomp;
		endcase
		sem.put;
	endtask
	
	///@brief   比較(アウトオーダー)
	///@details 期待値と観測値の間で一致するトランザクションアイテムがあるか
	///         どうかを総当たりでチェックします。
	///         一致した場合は、一致した期待値・観測値をリストから削除します。
	///         アルゴリズム上、不一致は発生しません。
	virtual function void check_item_outorder;
		T tr;
		
		cmp.show_max = 0; // 比較結果を表示させない
		if(dat.size>0 && exp.size>0)begin
			foreach(dat[m])begin : loop
				foreach(exp[n])begin
					if(dat[m].compare(exp[n],cmp))begin
						exp.delete(n);
						dat.delete(m);
						collect_num++;
						disable loop;
					end
				end
			end
		end
	endfunction
	
	///@brief   比較(インオーダー)
	///@details 期待値と観測値の間で一致するトランザクションアイテムがあるか
	///         どうかを順番にチェックします。
	///         一致した場合は、一致した期待値・観測値をリストから削除します。
	virtual function void check_item_inorder;
		T tr;
		
		cmp.show_max = 5;
		while(dat.size>0 && exp.size>0)begin
			bit result;
			result = dat[0].compare(exp[0],cmp);
			exp.delete(0);
			dat.delete(0);
			case(result)
			0 : error_num++;
			1 : collect_num++;
			endcase
		end
	endfunction
	
	///@brief   比較(パケット数のみ)
	///@details 期待値と観測値の数が一致するかどうかをチェックします。
	///         トランザクションアイテムの中身はチェックを行いません。
	///         アルゴリズム上、不一致は発生しません。
	virtual function void check_item_countonly;
		while(dat.size>0 && exp.size>0)begin
			exp.delete(0);
			dat.delete(0);
		end
	endfunction
	
	///@brief   比較しない
	///@details チェック動作を行いません。
	///         期待値と観測値の数をレポートするのみです。
	virtual function void check_item_nocomp;
		while(exp.size>0)begin
			exp.delete(0);
		end
		while(dat.size>0)begin
			dat.delete(0);
		end
	endfunction
	//////////////////////////////////////////////////////////////////////////@}
	///@name OVMフェーズ
	///      OVM標準のシミュレーションフェーズメソッド
	//////////////////////////////////////////////////////////////////////////@{
	/// コンストラクタ
	function new (string name="ScoreBoard" ,ovm_component parent=null);
		super.new(name, parent);
		sem          = new(1);
		cmp          = new;
		rule         = IN_ORDER;
		dat_item_num = 0;
		exp_item_num = 0;
		error_num    = 0;
		collect_num  = 0;
	endfunction
	/// レポート
	virtual function void report;
		if(exp_item_num==0 && dat_item_num==0)begin
			if(rule!=NO_COMPARE)begin
				$display("%s:No ScoreBoard target item.",msg_index);
			end
		end else begin
			case(rule)
			OUT_ORDER : begin
				$display("%s",msg_index);
				$display("+----------+------+------+------+");
				$display("|%-10s| Tgt  | OK   | Rest |",rule.name);
				$display("+----------+------+------+------+");
				$display("|  Exp.    | %4d | ---- | %4d |",exp_item_num,exp.size);
				$display("|  Dat.    | %4d | %4d | %4d |",dat_item_num,collect_num,dat.size);
				$display("+----------+------+------+------+");
			end
			IN_ORDER : begin
				$display("%s",msg_index);
				$display("+----------+------+------+------+------+");
				$display("|%-10s| Tgt  | OK   | NG   | Rest |",rule.name);
				$display("+----------+------+------+------+------+");
				$display("|  Exp.    | %4d | ---- | ---- | %4d |",exp_item_num,exp.size);
				$display("|  Dat.    | %4d | %4d | %4d | %4d |",dat_item_num,collect_num,error_num,dat.size);
				$display("+----------+------+------+------+------+");
			end
			COUNT_ONLY : begin
				$display("%s",msg_index);
				$display("+----------+------+------+------+");
				$display("|%-10s| Tgt  | OK   | Rest |",rule.name);
				$display("+----------+------+------+------+");
				$display("|  Exp.    | %4d | ---- | %4d |",exp_item_num,exp.size);
				$display("|  Dat.    | %4d | %4d | %4d |",dat_item_num,collect_num,dat.size);
				$display("+----------+------+------+------+");
			end
			NO_COMPARE : begin
				$display("%s",msg_index);
				$display("+----------+------+");
				$display("|%-10s| Tgt  |",rule.name);
				$display("+----------+------+");
				$display("|  Exp.    | %4d |",exp_item_num);
				$display("|  Dat.    | %4d |",dat_item_num);
				$display("+----------+------+");
			end
			endcase
			if(exp.size>0 || dat.size>0 || error_num>0)begin
				string msg;
				
				if(exp.size>0)begin
					$display("%s%sExp. : Rest.%s",{`VT100_RED},msg_index,{`VT100_NORMAL});
					foreach(exp[n]) exp[n].print;
				end
				if(dat.size>0)begin
					$display("%s%sDat. : Rest.%s",{`VT100_RED},msg_index,{`VT100_NORMAL});
					foreach(dat[n]) dat[n].print;
				end
				$sformat(msg,"\n%s%s:%s detect compare error.%s",{`VT100_RED},msg_index,rule.name,{`VT100_NORMAL});
				`ovm_error("SBERR",msg)
				reset;
			end
		end
	endfunction
	
	/// スコアボードの初期化
	virtual function void reset;
		exp = {}; // Queueのクリア
		dat = {}; // Queueのクリア
		dat_item_num = 0;
		exp_item_num = 0;
		error_num    = 0;
		collect_num  = 0;
	endfunction
	
	/// 観測値アナリシスエクスポート処理
	virtual function void write(T t);
		T dat;
		$cast(dat,t.clone());
		dat = dat_filter(dat);
		if(dat!=null)begin
			this.dat.push_back(dat);
			dat_item_num++;
			fork
				do_compare_item;
			join_none
		end
	endfunction
	//////////////////////////////////////////////////////////////////////////@}
endclass
