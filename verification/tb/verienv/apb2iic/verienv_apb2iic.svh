/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic.svh,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2012/03/26 06:00:20 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// ���؊�
/////////////////////////////////////////////////////////////////////////////
package verienv_apb2iic_pkg;
	`include "vt100.svh"
	`include "ovm_macros.svh"
	import ovm_pkg::*;
	import ovm_container_pkg::*;
	import ovm_ScoreBoard_pkg::*; ///< OVM�X�R�A�{�[�h
	/* �K�v�ȃ��f��������ꍇ�͂����ŃC���|�[�g���� */
	
	`include "verienv_apb2iic_share.sv"       // ���ʕϐ�
	`include "verienv_apb2iic_config.sv"      // �R���t�B�O
	`include "verienv_apb2iic_v_sequencer.sv" // �S�̐���V�[�P���T
	`include "verienv_apb2iic_seq_lib.sv"     // �V�[�P���X���C�u����
	`include "verienv_apb2iic_base_test.sv"   // �e�X�g��{�ݒ�
	`include "verienv_apb2iic_test_list.sv"   // �������ڈꗗ
endpackage
