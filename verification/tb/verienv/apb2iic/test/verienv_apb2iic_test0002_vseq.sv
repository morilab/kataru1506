/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_test0002_vseq.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.3 $
// Last Update   : $Date: 2012/03/26 12:24:01 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// 検証シナリオ
/////////////////////////////////////////////////////////////////////////////
class verienv_apb2iic_test0002_vseq extends verienv_apb2iic_base_vseq;
	`ovm_sequence_utils(verienv_apb2iic_test0002_vseq, verienv_apb2iic_v_sequencer)
	function new(string name="");
		super.new(name);
	endfunction
	
	virtual task body();
		// リセット
		reset;
		
		// 検証内容
		$display("%s<<<<<<< apb2iic_test0002 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%s",{`VT100_CYAN},{`VT100_NORMAL});
                set_port(PORT_PENABLE,1);
                set_port(PORT_PADDR  ,$random());
                set_port(PORT_PWRITE ,0);
                wait_clk(10);
                set_port(PORT_PENABLE,0);

		
		// 終了処理
		wait_clk(100);
		global_stop_request();
	endtask
endclass
