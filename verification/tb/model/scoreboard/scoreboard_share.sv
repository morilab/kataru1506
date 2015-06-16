/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : 2012/01/19 12:00:00
// Design Name   : $RCSfile: scoreboard_share.sv,v $
// Project Name  : ScoreBoard
// Project No.   : 
// Syntax        : OVM2.0.3
// Tool versions : ModelSim10.1
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 05:38:31 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// 共有変数
/////////////////////////////////////////////////////////////////////////////

///@brief   チェックモード
///@details スコアボードで収集したアイテムのチェック方法を示します。
typedef enum {
	IN_ORDER   , ///< インオーダー比較
	OUT_ORDER  , ///< アウトオーダー比較
	COUNT_ONLY , ///< 数のみの比較
	NO_COMPARE   ///< 比較しない
} chk_rule;

///@brief   メモリ種別
///@details メモリ配列の型を示します。
///@warning この機能は将来的に実装するべきですが、現在は未実装です。
///@note    動的配列はアクセスは高速ですが、アドレスサイズ分のメモリを確保する為1MBを超えるような空間には向きません。
///         連想配列はアクセスは動的配列に比べると低速ですが、アクセスしたアドレスに関してのみ（アクセスした時点で）
///         メモリを確保する為、広いアドレス空間の一部のみアクセスするような動作に適しています。<br>
///         →現在は連想配列による実装を行っています。
typedef enum {
	RAM_IS_DYNAMIC_ARRAY     , ///< 動的配列
	RAM_IS_ASSOCIATIVE_ARRAY   ///< 連想配列
} sb_ram_type;
