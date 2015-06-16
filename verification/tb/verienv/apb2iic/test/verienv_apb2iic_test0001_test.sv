/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_test0001_test.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 05:37:09 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// topïîåüèÿ
/////////////////////////////////////////////////////////////////////////////
class verienv_apb2iic_test0001 extends verienv_apb2iic_base_test;
	function new(string name="verienv_apb2iic_test0001" ,ovm_component parent=null);
		super.new(name ,parent);
	endfunction
	`ovm_component_utils(verienv_apb2iic_test0001)
	
	// build
	function void build;
		set_config_int   ("sys_v_sequencer" ,"count"            ,1);
		set_config_string("sys_v_sequencer" ,"default_sequence" ,"verienv_apb2iic_test0001_vseq" );
		super.build;
	endfunction
endclass
