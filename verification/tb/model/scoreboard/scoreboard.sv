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
///@brief   �X�R�A�{�[�h�N���X
///@details ���Ғl�A�ϑ��l���󂯎��A�i���V�X�G�N�X�|�[�g�������܂��B
///         �����g�����U�N�V�����A�C�e���̌^�̓p�����[�^�Ŏw�肵�܂��B
///         ���Ғl�Ɗϑ��l�̔�r���@��set_config_int�Ŏw�肵�܂��B
////////////////////////////////////////////////////////////////////////////////
class scoreboard #(type T=ovm_sequence_item) extends ovm_scoreboard;
	`ovm_component_param_utils_begin(scoreboard#(T))
		`ovm_field_string(msg_index ,OVM_ALL_ON)
	`ovm_component_utils_end
	
	string                                     msg_index;            ///< ���b�Z�[�W�C���f�b�N�X
	scoreboard_subscriber #(T)                 item_comp;            ///< �ėp��r��
	ovm_analysis_imp      #(T ,scoreboard#(T)) exp_collected_export; ///< ���Ғl�A�i���V�X�G�N�X�|�[�g
	ovm_analysis_export   #(T)                 dat_collected_export; ///< �ϑ��l�A�i���V�X�G�N�X�|�[�g
	
	////////////////////////////////////////////////////////////////////////////
	///@name OVM�t�F�[�Y
	///      OVM�W���̃V�~�����[�V�����t�F�[�Y���\�b�h
	//////////////////////////////////////////////////////////////////////////@{
	/// �R���X�g���N�^
	function new (string name, ovm_component parent);
		super.new(name, parent);
		exp_collected_export = new("exp_port",this);
		dat_collected_export = new("dat_port",this);
	endfunction : new
	/// ���\�z
	virtual function void build();
		super.build;
		item_comp = scoreboard_subscriber#(T)::type_id::create("SB",this);
	endfunction
	
	/// �R���|�[�l���g�Ԑڑ�
	virtual function void connect;
		dat_collected_export.connect(item_comp.analysis_export);
	endfunction
	
	/// ���ݒ�
    virtual function void end_of_elaboration();
		if(msg_index=="")begin
			msg_index = $psprintf("%s",get_full_name());
		end
		item_comp.msg_index = msg_index;
    endfunction
	
	/// ���Ғl�A�i���V�X�G�N�X�|�[�g����
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
	
	/// �X�R�A�{�[�h�̏�����
	virtual function void reset;
		item_comp.reset;
	endfunction
endclass
