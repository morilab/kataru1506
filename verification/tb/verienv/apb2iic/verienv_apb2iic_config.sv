/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_config.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.2 $
// Last Update   : $Date: 2012/03/26 12:04:16 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
/// ���؊��R���t�B�O���[�V����
/////////////////////////////////////////////////////////////////////////////
localparam string s_test_config_id     = "verienv_apb2iic_config";
localparam string s_no_config_error_id = "NoConfigError";
localparam string s_config_type_error  = "ConfigTypeError";

class verienv_apb2iic_config extends ovm_object;
	`ovm_object_utils(verienv_apb2iic_config)
	
//	hoge_config             m_hoge_config; ///< hoge���f���ݒ�
	virtual verienv_apb2iic_if intf;          ///< ���؊��p�C���^�[�t�F�[�X
	time sys_clk_cycle;                    ///< �V�X�e���N���b�N����
	
	function new(string name = "");
		super.new(name);
	//	m_hoge_config = new;
	endfunction
	
	function virtual interface verienv_apb2iic_if assign_vi;
		return intf;
	endfunction
	
	static function verienv_apb2iic_config get_config(ovm_component c);
		ovm_object o;
		verienv_apb2iic_config t;
		
		if(!c.get_config_object(s_test_config_id ,o ,0))begin
			c.ovm_report_error(
				s_no_config_error_id,
				$psprintf(
					"%sthis component has no config associated with id <%s>%s"
					,{`VT100_RED}
					,s_test_config_id
					,{`VT100_NORMAL}
				)
			);
			return null;
		end
		if(!$cast(t ,o))begin
			c.ovm_report_error(
				s_config_type_error,
				$psprintf(
					"%sthe object associated with id <%s> is of type <%s> which is not the required type <%s>%s"
					,{`VT100_RED}
					,s_test_config_id
					,o.get_type_name()
					,type_name
					,{`VT100_NORMAL}
				)
			);
			return null;
		end
		return t;
	endfunction
endclass
