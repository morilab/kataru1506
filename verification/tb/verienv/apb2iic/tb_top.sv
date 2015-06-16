/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: tb_top.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.3 $
// Last Update   : $Date: 2012/10/19 13:13:44 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// ���؊����W���[��
// �S�̌��؊�
/////////////////////////////////////////////////////////////////////////////
// OVM�W�����C�u����
import ovm_pkg::*;            ///< OVM�W�����C�u����
import ovm_container_pkg::*;  ///< OVM�p�R���e�i���C�u����
`include "ovm_macros.svh"

// �C���^�[�t�F�[�X�錾
`include "verienv_apb2iic_if.sv" ///< ���؊��C���^�[�t�F�[�X

// ���b�p�[
`include "DUV.v"

/// ���؃g�b�v���W���[��
module tb_top();
	timeunit      1ps;
	timeprecision 1ps;
	
	// OVM���f�����C�u����
	import verienv_apb2iic_pkg::*;    ///< OVM���؊�
	
	// �^�錾
	typedef virtual verienv_apb2iic_if  verienv_t;
	
	// �C���^�[�t�F�[�X
	verienv_apb2iic_if verienv_port();
	
	// ����RTL�g�b�v
	DUV DUV (                                 // <DUV>
		.port_if          (verienv_port     ) // verienv_apb2iic_if
	);                                        // </>
	
	///< OVM����
	initial begin
	//	$timeformat(-12.0,"[ps]",16); // ModelSim��Ή�
		ovm_container#(verienv_t)::set_value_in_global_config("VERIENV_PORT"  ,verienv_port);
		ovm_container#(time     )::set_value_in_global_config("SYS_CLK_CYCLE" ,10*1000);       // �N���b�N����[ps]
		run_test();
	end
endmodule
