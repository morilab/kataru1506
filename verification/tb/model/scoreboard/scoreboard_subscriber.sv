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
///@brief   �X�R�A�{�[�h�p��r��
///@details �w�胋�[���ɏ]���A2�̃g�����U�N�V�����A�C�e���̔�r���s���܂��B
///         �󂯎�������Ғl�A�ϑ��l�͂��ꂼ��t�B���^�֐��ŕK�v�ɉ����đO������
///         �s���Ă����r���s���A�V�~�����[�V�����I�����ɍŏI���|�[�g���o�͂��܂��B
////////////////////////////////////////////////////////////////////////////////
class scoreboard_subscriber#(type T=ovm_sequence_item) extends ovm_subscriber#(T);
	string       msg_index;     ///< ���b�Z�[�W�C���f�b�N�X
	T            dat[$];        ///< �ϑ��l���X�g
	T            exp[$];        ///< ���Ғl���X�g
	chk_rule     rule;          ///< ��r���@�ݒ�
	int          dat_item_num;  ///< �ϑ��l�̐�
	int          exp_item_num;  ///< ���Ғl�̐�
	int          error_num;     ///< �s��v������
	int          collect_num;   ///< ��v������
	ovm_comparer cmp;           ///< ��r��
	protected    semaphore sem; ///< �Z�}�t�H
	
	`ovm_component_param_utils_begin(scoreboard_subscriber#(T))
		`ovm_field_string(msg_index       ,OVM_ALL_ON)
		`ovm_field_enum  (chk_rule  ,rule ,OVM_ALL_ON)
	`ovm_component_utils_end
	
	///@brief   ���Ғl�t�B���^
	///@details ���Ғl���X�g�֒ǉ�����O�ɁA�g�����U�N�V�����A�C�e�����̂�
	///         �ύX���邱�Ƃ��\�ł��B
	///@return  ���X�g�֒ǉ�����g�����U�N�V�����A�C�e���̎Q�Ƃ�Ԃ��܂��B
	///         null�̏ꍇ�A���X�g�ւ͒ǉ�����܂���B
	///@note    ��ʓI�ɂ͊֐��̃I�[�o�[���C�h���s���A���҂������������悤�ɏC�����܂��B
	virtual function T exp_filter(T tr);
		return tr;
	endfunction
	
	///@brief   �ϑ��l�t�B���^
	///@details �ϑ��l���X�g�֒ǉ�����O�ɁA�g�����U�N�V�����A�C�e�����̂�
	///         �ύX���邱�Ƃ��\�ł��B
	///@return  ���X�g�֒ǉ�����g�����U�N�V�����A�C�e���̎Q�Ƃ�Ԃ��܂��B
	///         null�̏ꍇ�A���X�g�ւ͒ǉ�����܂���B
	///@note    ��ʓI�ɂ͊֐��̃I�[�o�[���C�h���s���A���҂������������悤�ɏC�����܂��B
	virtual function T dat_filter(T tr);
		return tr;
	endfunction
	
	////////////////////////////////////////////////////////////////////////////
	///@name ��r����
	///      ���Ғl�A�ϑ��l�̔�r���s���֐��Q�ł��B
	//////////////////////////////////////////////////////////////////////////@{
	
	///@brief   ��r�����̑I���E���s
	///@details �w�胋�[���ɏ]���A2�̃g�����U�N�V�����A�C�e���̔�r���s���܂��B
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
	
	///@brief   ��r(�A�E�g�I�[�_�[)
	///@details ���Ғl�Ɗϑ��l�̊Ԃň�v����g�����U�N�V�����A�C�e�������邩
	///         �ǂ����𑍓�����Ń`�F�b�N���܂��B
	///         ��v�����ꍇ�́A��v�������Ғl�E�ϑ��l�����X�g����폜���܂��B
	///         �A���S���Y����A�s��v�͔������܂���B
	virtual function void check_item_outorder;
		T tr;
		
		cmp.show_max = 0; // ��r���ʂ�\�������Ȃ�
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
	
	///@brief   ��r(�C���I�[�_�[)
	///@details ���Ғl�Ɗϑ��l�̊Ԃň�v����g�����U�N�V�����A�C�e�������邩
	///         �ǂ��������ԂɃ`�F�b�N���܂��B
	///         ��v�����ꍇ�́A��v�������Ғl�E�ϑ��l�����X�g����폜���܂��B
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
	
	///@brief   ��r(�p�P�b�g���̂�)
	///@details ���Ғl�Ɗϑ��l�̐�����v���邩�ǂ������`�F�b�N���܂��B
	///         �g�����U�N�V�����A�C�e���̒��g�̓`�F�b�N���s���܂���B
	///         �A���S���Y����A�s��v�͔������܂���B
	virtual function void check_item_countonly;
		while(dat.size>0 && exp.size>0)begin
			exp.delete(0);
			dat.delete(0);
		end
	endfunction
	
	///@brief   ��r���Ȃ�
	///@details �`�F�b�N������s���܂���B
	///         ���Ғl�Ɗϑ��l�̐������|�[�g����݂̂ł��B
	virtual function void check_item_nocomp;
		while(exp.size>0)begin
			exp.delete(0);
		end
		while(dat.size>0)begin
			dat.delete(0);
		end
	endfunction
	//////////////////////////////////////////////////////////////////////////@}
	///@name OVM�t�F�[�Y
	///      OVM�W���̃V�~�����[�V�����t�F�[�Y���\�b�h
	//////////////////////////////////////////////////////////////////////////@{
	/// �R���X�g���N�^
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
	/// ���|�[�g
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
	
	/// �X�R�A�{�[�h�̏�����
	virtual function void reset;
		exp = {}; // Queue�̃N���A
		dat = {}; // Queue�̃N���A
		dat_item_num = 0;
		exp_item_num = 0;
		error_num    = 0;
		collect_num  = 0;
	endfunction
	
	/// �ϑ��l�A�i���V�X�G�N�X�|�[�g����
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
