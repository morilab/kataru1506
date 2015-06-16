/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_seq_lib.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.5 $
// Last Update   : $Date: 2013/07/16 05:33:01 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// verienv_apb2iic固有シーケンス
/////////////////////////////////////////////////////////////////////////////
/// verienv_apb2iic_v_sequencer用基底シーケンス
class verienv_apb2iic_base_vseq extends ovm_sequence#(ovm_sequence_item,ovm_sequence_item);
	`ovm_sequence_utils(verienv_apb2iic_base_vseq ,verienv_apb2iic_v_sequencer)
	function new (string name="verienv_apb2iic_vseq");
		super.new(name);
	endfunction : new
	
	///////////////////////////////////////////////////////////////////////////
	// apb2iic環境の端子制御
	task set_port(verienv_apb2iic_port port ,logic[127:0] value);
		p_sequencer.set_verienv_port(port ,value);
	endtask
	
	function [127:0] get_port(verienv_apb2iic_port port);
		get_port = p_sequencer.get_verienv_port(port);
	endfunction
	
	task wait_port(verienv_apb2iic_port port ,logic[127:0] value);
		p_sequencer.wait_verienv_port(port ,value);
	endtask
	
	task chk_port(verienv_apb2iic_port port ,logic[127:0] value);
		p_sequencer.chk_verienv_port(port ,value);
	endtask
	
	///////////////////////////////////////////////////////////////////////////
	// ウエイトクロック
	task wait_clk(int count=1);
		p_sequencer.wait_clk(count);
	endtask
	
	///////////////////////////////////////////////////////////////////////////
	// リセット
	task reset();
	        set_port(PORT_PADDR,0);       ///< 
	        set_port(PORT_PWDATA,0);      ///< 
	        set_port(PORT_PWRITE,0);      ///< 
	        set_port(PORT_PSELX,1);       ///< 
	        set_port(PORT_PENABLE,0);     ///< 
		set_port(PORT_PRESETN,0);
		wait_clk(50);
		set_port(PORT_PRESETN,1);
		$display("%sreset done.%s",{`VT100_CYAN},{`VT100_NORMAL});
		wait_clk(1);
	endtask
endclass
