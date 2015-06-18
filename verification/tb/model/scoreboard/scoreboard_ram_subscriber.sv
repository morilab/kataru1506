/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : 2011/12/18 12:00:00
// Design Name   : $RCSfile: scoreboard_ram_subscriber.sv,v $
// Project Name  : ScoreBoard
// Project No.   : 
// Syntax        : OVM2.0.3
// Tool versions : ModelSim10.1
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 05:38:31 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
///@brief   メモリモデル比較器
///@details トランザクションアイテムがアドレスとデータ（の配列）を持つ場合、一定
///         のメモリ空間に対してメモリリード・ライト動作をエミュレートします。
///         ライト動作ではメモリ空間に値を保存し、リード動作ではメモリ空間の値を
///         期待値、トランザクションアイテムが持つデータを観測値として比較します。
////////////////////////////////////////////////////////////////////////////////
class scoreboard_ram_subscriber #(type T=ovm_sequence_item ,int WORD_WIDTH=8) extends scoreboard_subscriber #(T);
	/*  ※動的配列のほうが高速だが、対応アドレス空間が広い場合は連想配列のほうがメモリ使用量が抑えられる。
	**	set_config_enumで選択できるようにしたいが、その場合はメモリ部分(ram)をクラス化し、アクセスメソッドを
	**	用意してオブジェクト化する必要がある。
	*/
	string              title;          ///< タイトル
	bit[WORD_WIDTH-1:0] ram[bit[31:0]]; ///< 連想配列
//	bit[WORD_WIDTH-1:0] ram[];          ///< 動的配列
	bit[31:0]           ram_size;       ///< メモリサイズ
	bit[31:0]           start_addr;     ///< 開始アドレス
	
	`ovm_component_param_utils_begin(scoreboard_ram_subscriber#(T,WORD_WIDTH))
		`ovm_field_int(start_addr ,OVM_ALL_ON)
		`ovm_field_int(ram_size   ,OVM_ALL_ON)
	`ovm_component_utils_end
	
	///@brief   スコアボードの初期化
	///@details 内部データをすべて初期値に戻します。
	virtual function void reset;
		super.reset;
		ram.delete;
	endfunction
	
	///@brief   期待値プレフィルタ
	///@details メモリアクセス処理前に、トランザクションアイテム自体を
	///         変更することが可能です。
	///@return  トランザクションアイテムの参照を返します。nullの場合は破棄されます。
	///@note    必要ならば関数のオーバーライドを行ってください。
	virtual function T pre_exp_filter(T tr);
		return tr;
	endfunction
	
	///@brief   期待値ポストフィルタ
	///@details 期待値リストへ追加する前に、トランザクションアイテム自体を
	///         変更することが可能です。
	///@return  リストへ追加するトランザクションアイテムの参照を返します。
	///         nullの場合、リストへは追加されません。
	///@note    必要ならば関数のオーバーライドを行ってください。
	virtual function T post_exp_filter(T tr);
		// 戻り値がtrなら期待値になります。nullの場合は除外します。
		return tr;
	endfunction
	
	///@brief   観測値プレフィルタ
	///@details メモリアクセス処理前に、トランザクションアイテム自体を
	///         変更することが可能です。
	///@return  トランザクションアイテムの参照を返します。nullの場合は破棄されます。
	///@note    必要ならば関数のオーバーライドを行ってください。
	virtual function T pre_dat_filter(T tr);
		// 戻り値が0ならメモリアクセスの対象になります。1の場合は除外します。
		return tr;
	endfunction
	
	///@brief   観測値ポストフィルタ
	///@details 観測値リストへ追加する前に、トランザクションアイテム自体を
	///         変更することが可能です。
	///@return  リストへ追加するトランザクションアイテムの参照を返します。
	///         nullの場合、リストへは追加されません。
	///@note    必要ならば関数のオーバーライドを行ってください。
	virtual function T post_dat_filter(T tr);
		// 戻り値がtrなら観測値になります。nullの場合は除外します。
		return tr;
	endfunction

	///@brief   ライトアクセス判定（期待値）
	///@details トランザクションアイテムがライトアクセスかどうかを判定します。
	///@return  - 0 : ライト以外
	///         - 1 : ライト
	///@note    トランザクションアイテムに応じてオーバーライドする必要があります。
	virtual function bit is_exp_write(T tr);
		return 0;
	endfunction
	
	///@brief   リードアクセス判定（期待値）
	///@details トランザクションアイテムがリードアクセスかどうかを判定します。
	///@return  - 0 : リード以外
	///         - 1 : リード
	///@note    トランザクションアイテムに応じてオーバーライドする必要があります。
	virtual function bit is_exp_read(T tr);
		return 0;
	endfunction
	
	///@brief   リードアクセス判定（観測値）
	///@details トランザクションアイテムがリードアクセスかどうかを判定します。
	///@return  - 0 : リード以外
	///         - 1 : リード
	///@note    トランザクションアイテムに応じてオーバーライドする必要があります。
	virtual function bit is_dat_read(T tr);
		return 0;
	endfunction
	
	///@brief   アドレス抽出
	///@details トランザクションアイテムからアドレスを抽出して返します。
	///@note    トランザクションアイテムに応じてオーバーライドする必要があります。
	virtual function bit[31:0] tr_addr(T tr);
	//	return tr.addr;
		return 32'h0000_0000;
	endfunction
	
	///@brief   データ抽出
	///@details トランザクションアイテムからデータを抽出して返します。
	///@note    トランザクションアイテムに応じてオーバーライドする必要があります。
//	virtual function void tr_data(T tr ,output bit[7:0] data[]);
	virtual function void tr_data(T tr ,output bit[WORD_WIDTH-1:0] data[]);
	//	data = new[tr.data.size](tr.data);
		data = new[0];
	endfunction

	///@brief   期待値フィルタ
	///@details ライトアクセス時、データをメモリに保存します。<br>
	///         リードアクセス時、メモリのデータを期待値とします。
	///@note    プレフィルタ関数pre_exp_filter、ポストフィルタ関数post_exp_filter
	///         を追加していますので、フィルタ処理をオーバーライドする場合は
	///         pre_exp_filterおよびpost_exp_filterを対象としてください。
	virtual function T exp_filter(T tr);
		T                   tr_exp;
		bit[31:0]           addr;
		bit[WORD_WIDTH-1:0] data[];
		
		// プレフィルタ実施
		tr = pre_exp_filter(tr);
		if(tr==null) return tr;
		// アドレス、データ抽出
		tr_data(tr,data);
		addr = tr_addr(tr);
		// RAM Write
		if(is_exp_write(tr))begin
			for(int pt=0; pt<data.size; pt++)begin
				ram[addr+pt-start_addr] = data[pt];
			end
		end
		// RAM Read
		if(is_exp_read(tr))begin
			$cast(tr_exp ,tr.clone());
			// ポストフィルタ実施
			return post_exp_filter(tr_exp);
		end
		return null;
	endfunction
	
	///@brief   観測値フィルタ
	///@details リードアクセスを検出し、期待値とします。
	///@note    プレフィルタ関数pre_dat_filter、ポストフィルタ関数post_dat_filter
	///         を追加していますので、フィルタ処理をオーバーライドする場合は
	///         pre_dat_filterおよびpost_dat_filterを対象としてください。
	virtual function T dat_filter(T tr);
		T tr_dat;
		// プレフィルタ実施
		tr = pre_dat_filter(tr);
		if(tr==null) return tr;
		// RAM Read
		if(is_dat_read(tr))begin
			$cast(tr_dat ,tr.clone());
			// ポストフィルタ実施
			return post_dat_filter(tr_dat);
		end
		return null;
	endfunction
	
	///@brief   メモリダンプ
	///@details メモリの内容を見やすい文字列で返します。
	virtual function string dump;
		bit[31:0] end_addr;
		int       sum;
		bit       flag;
		string    msg;
		string    l_msg;
		
		end_addr = start_addr+ram_size-1;
		msg = $psprintf("\n/--%s%s\n",msg_index,{(78-msg_index.len()){"-"}});
		msg = $psprintf("%s%s(%s)\n",msg,title ,get_full_name());
		msg = $psprintf("%sAddress      = 0x%04x_%04x - 0x%04x_%04x\n",msg,start_addr[31:16],start_addr[15:0],end_addr[31:16],end_addr[15:0]);
		if(ram.num>0)begin
			bit[31:0] first_addr;
			bit[31:0] last_addr;
			int       c;
			
			msg = $psprintf("%s%s :",msg,{11{" "}});
			for(int i=0;i<16;i++) msg = $psprintf("%s%s%0x",msg,{(WORD_WIDTH/4){" "}},i);
			msg = $psprintf("%s\n",msg);
			msg = $psprintf("%s%s-:",msg,{11{"-"}});
			for(int i=0;i<16;i++) msg = $psprintf("%s%s",msg,{(WORD_WIDTH/4+1){"-"}});
			msg = $psprintf("%s",msg);
			c = ram.first(first_addr);
			c = ram.last (last_addr );
			first_addr += start_addr;
			last_addr  += start_addr;
			for(bit[31:0] addr={first_addr[31:4],4'h0}; addr<=last_addr; addr++)begin
		//	for(bit[31:0] addr={start_addr[31:4],4'h0}; addr<start_addr+ram_size; addr++)begin // 動的配列
				if(addr[3:0]==4'h0) begin
					l_msg = $psprintf("0x%04x_%04x :",addr[31:16],{addr[15:4],4'h0});
				end
				if(addr>=start_addr && addr<start_addr+ram_size)begin
					case(WORD_WIDTH/4)
					1 : l_msg = $psprintf("%s %01x",l_msg,ram[addr-start_addr]);
					2 : l_msg = $psprintf("%s %02x",l_msg,ram[addr-start_addr]);
					3 : l_msg = $psprintf("%s %03x",l_msg,ram[addr-start_addr]);
					4 : l_msg = $psprintf("%s %04x",l_msg,ram[addr-start_addr]);
					5 : l_msg = $psprintf("%s %05x",l_msg,ram[addr-start_addr]);
					6 : l_msg = $psprintf("%s %06x",l_msg,ram[addr-start_addr]);
					7 : l_msg = $psprintf("%s %07x",l_msg,ram[addr-start_addr]);
					8 : l_msg = $psprintf("%s %08x",l_msg,ram[addr-start_addr]);
					default : l_msg = $psprintf("%s %x",l_msg,ram[addr-start_addr]);
					endcase
					sum |= ram[addr-start_addr];
				end else begin
					l_msg = $psprintf("%s %s",l_msg,{(WORD_WIDTH/4){" "}});
				end
				if(addr[3:0]==4'hF)begin
					if(sum>0)begin
						msg = $psprintf("%s\n%s",msg,l_msg);
						flag = 0;
					end else
					if(flag==0)begin
						msg = $psprintf("%s\n  ...",msg);
						flag = 1;
					end
					sum = 0;
				end
			end
			msg = $psprintf("\n%s\n%s-:",msg,{11{"-"}});
			for(int i=0;i<16;i++) msg = $psprintf("%s%s",msg,{(WORD_WIDTH/4+1){"-"}});
			msg = $psprintf("%s\n",msg);
		end
		msg = $psprintf("%s%s/\n",msg,{80{"-"}});
		return msg;
	endfunction
	
	////////////////////////////////////////////////////////////////////////////
	///@name OVMフェーズ
	///      OVM標準のシミュレーションフェーズメソッド
	//////////////////////////////////////////////////////////////////////////@{
	/// コンストラクタ
	function new (string name="ScoreBoard" ,ovm_component parent=null);
		super.new(name, parent);
		title = "RAM Model ScoreBoard";
	endfunction : new
	
	///@brief   環境設定
	///@details 動的配列メモリの初期化を行います。
	///@warning 現在はメモリを連想配列で実装しているため、何も処理は行っていません。
	virtual function void end_of_elaboration;
		super.end_of_elaboration;
	//	ram = new[ram_size]; // 動的配列
	endfunction
	
	///@brief   シミュレーション開始時処理
	///@details 動作条件の表示を行います。
	virtual function void start_of_simulation;
		bit[31:0] end_addr;
		
		super.start_of_simulation;
		end_addr = start_addr+ram_size-1;
		$display("/--%s%s",msg_index,{(90-msg_index.len()){"-"}});
		$display("%s(%s)",title ,get_full_name());
		$display("Address      = 0x%04x_%04x - 0x%04x_%04x",start_addr[31:16],start_addr[15:0],end_addr[31:16],end_addr[15:0]);
		$display("%s/",{92{"-"}});
	endfunction
	
	///@brief   シミュレーション終了時処理
	///@details 通常の比較結果に加え、メモリのダンプ表示を行います。
	///@note    ダンプ表示はOVM_MEDIUMレベルです。
	virtual function void report;
		string msg;
		
		super.report;
		`ovm_info(msg_index,$psprintf("%s%s%s",{`VT100_BLUE},dump,{`VT100_NORMAL}),OVM_MEDIUM);
	endfunction
	//////////////////////////////////////////////////////////////////////////@}
endclass
