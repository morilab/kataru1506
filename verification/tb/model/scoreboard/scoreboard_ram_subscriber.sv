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
///@brief   ���������f����r��
///@details �g�����U�N�V�����A�C�e�����A�h���X�ƃf�[�^�i�̔z��j�����ꍇ�A���
///         �̃�������Ԃɑ΂��ă��������[�h�E���C�g������G�~�����[�g���܂��B
///         ���C�g����ł̓�������Ԃɒl��ۑ����A���[�h����ł̓�������Ԃ̒l��
///         ���Ғl�A�g�����U�N�V�����A�C�e�������f�[�^���ϑ��l�Ƃ��Ĕ�r���܂��B
////////////////////////////////////////////////////////////////////////////////
class scoreboard_ram_subscriber #(type T=ovm_sequence_item ,int WORD_WIDTH=8) extends scoreboard_subscriber #(T);
	/*  �����I�z��̂ق������������A�Ή��A�h���X��Ԃ��L���ꍇ�͘A�z�z��̂ق����������g�p�ʂ��}������B
	**	set_config_enum�őI���ł���悤�ɂ��������A���̏ꍇ�̓���������(ram)���N���X�����A�A�N�Z�X���\�b�h��
	**	�p�ӂ��ăI�u�W�F�N�g������K�v������B
	*/
	string              title;          ///< �^�C�g��
	bit[WORD_WIDTH-1:0] ram[bit[31:0]]; ///< �A�z�z��
//	bit[WORD_WIDTH-1:0] ram[];          ///< ���I�z��
	bit[31:0]           ram_size;       ///< �������T�C�Y
	bit[31:0]           start_addr;     ///< �J�n�A�h���X
	
	`ovm_component_param_utils_begin(scoreboard_ram_subscriber#(T,WORD_WIDTH))
		`ovm_field_int(start_addr ,OVM_ALL_ON)
		`ovm_field_int(ram_size   ,OVM_ALL_ON)
	`ovm_component_utils_end
	
	///@brief   �X�R�A�{�[�h�̏�����
	///@details �����f�[�^�����ׂď����l�ɖ߂��܂��B
	virtual function void reset;
		super.reset;
		ram.delete;
	endfunction
	
	///@brief   ���Ғl�v���t�B���^
	///@details �������A�N�Z�X�����O�ɁA�g�����U�N�V�����A�C�e�����̂�
	///         �ύX���邱�Ƃ��\�ł��B
	///@return  �g�����U�N�V�����A�C�e���̎Q�Ƃ�Ԃ��܂��Bnull�̏ꍇ�͔j������܂��B
	///@note    �K�v�Ȃ�Ί֐��̃I�[�o�[���C�h���s���Ă��������B
	virtual function T pre_exp_filter(T tr);
		return tr;
	endfunction
	
	///@brief   ���Ғl�|�X�g�t�B���^
	///@details ���Ғl���X�g�֒ǉ�����O�ɁA�g�����U�N�V�����A�C�e�����̂�
	///         �ύX���邱�Ƃ��\�ł��B
	///@return  ���X�g�֒ǉ�����g�����U�N�V�����A�C�e���̎Q�Ƃ�Ԃ��܂��B
	///         null�̏ꍇ�A���X�g�ւ͒ǉ�����܂���B
	///@note    �K�v�Ȃ�Ί֐��̃I�[�o�[���C�h���s���Ă��������B
	virtual function T post_exp_filter(T tr);
		// �߂�l��tr�Ȃ���Ғl�ɂȂ�܂��Bnull�̏ꍇ�͏��O���܂��B
		return tr;
	endfunction
	
	///@brief   �ϑ��l�v���t�B���^
	///@details �������A�N�Z�X�����O�ɁA�g�����U�N�V�����A�C�e�����̂�
	///         �ύX���邱�Ƃ��\�ł��B
	///@return  �g�����U�N�V�����A�C�e���̎Q�Ƃ�Ԃ��܂��Bnull�̏ꍇ�͔j������܂��B
	///@note    �K�v�Ȃ�Ί֐��̃I�[�o�[���C�h���s���Ă��������B
	virtual function T pre_dat_filter(T tr);
		// �߂�l��0�Ȃ烁�����A�N�Z�X�̑ΏۂɂȂ�܂��B1�̏ꍇ�͏��O���܂��B
		return tr;
	endfunction
	
	///@brief   �ϑ��l�|�X�g�t�B���^
	///@details �ϑ��l���X�g�֒ǉ�����O�ɁA�g�����U�N�V�����A�C�e�����̂�
	///         �ύX���邱�Ƃ��\�ł��B
	///@return  ���X�g�֒ǉ�����g�����U�N�V�����A�C�e���̎Q�Ƃ�Ԃ��܂��B
	///         null�̏ꍇ�A���X�g�ւ͒ǉ�����܂���B
	///@note    �K�v�Ȃ�Ί֐��̃I�[�o�[���C�h���s���Ă��������B
	virtual function T post_dat_filter(T tr);
		// �߂�l��tr�Ȃ�ϑ��l�ɂȂ�܂��Bnull�̏ꍇ�͏��O���܂��B
		return tr;
	endfunction

	///@brief   ���C�g�A�N�Z�X����i���Ғl�j
	///@details �g�����U�N�V�����A�C�e�������C�g�A�N�Z�X���ǂ����𔻒肵�܂��B
	///@return  - 0 : ���C�g�ȊO
	///         - 1 : ���C�g
	///@note    �g�����U�N�V�����A�C�e���ɉ����ăI�[�o�[���C�h����K�v������܂��B
	virtual function bit is_exp_write(T tr);
		return 0;
	endfunction
	
	///@brief   ���[�h�A�N�Z�X����i���Ғl�j
	///@details �g�����U�N�V�����A�C�e�������[�h�A�N�Z�X���ǂ����𔻒肵�܂��B
	///@return  - 0 : ���[�h�ȊO
	///         - 1 : ���[�h
	///@note    �g�����U�N�V�����A�C�e���ɉ����ăI�[�o�[���C�h����K�v������܂��B
	virtual function bit is_exp_read(T tr);
		return 0;
	endfunction
	
	///@brief   ���[�h�A�N�Z�X����i�ϑ��l�j
	///@details �g�����U�N�V�����A�C�e�������[�h�A�N�Z�X���ǂ����𔻒肵�܂��B
	///@return  - 0 : ���[�h�ȊO
	///         - 1 : ���[�h
	///@note    �g�����U�N�V�����A�C�e���ɉ����ăI�[�o�[���C�h����K�v������܂��B
	virtual function bit is_dat_read(T tr);
		return 0;
	endfunction
	
	///@brief   �A�h���X���o
	///@details �g�����U�N�V�����A�C�e������A�h���X�𒊏o���ĕԂ��܂��B
	///@note    �g�����U�N�V�����A�C�e���ɉ����ăI�[�o�[���C�h����K�v������܂��B
	virtual function bit[31:0] tr_addr(T tr);
	//	return tr.addr;
		return 32'h0000_0000;
	endfunction
	
	///@brief   �f�[�^���o
	///@details �g�����U�N�V�����A�C�e������f�[�^�𒊏o���ĕԂ��܂��B
	///@note    �g�����U�N�V�����A�C�e���ɉ����ăI�[�o�[���C�h����K�v������܂��B
//	virtual function void tr_data(T tr ,output bit[7:0] data[]);
	virtual function void tr_data(T tr ,output bit[WORD_WIDTH-1:0] data[]);
	//	data = new[tr.data.size](tr.data);
		data = new[0];
	endfunction

	///@brief   ���Ғl�t�B���^
	///@details ���C�g�A�N�Z�X���A�f�[�^���������ɕۑ����܂��B<br>
	///         ���[�h�A�N�Z�X���A�������̃f�[�^�����Ғl�Ƃ��܂��B
	///@note    �v���t�B���^�֐�pre_exp_filter�A�|�X�g�t�B���^�֐�post_exp_filter
	///         ��ǉ����Ă��܂��̂ŁA�t�B���^�������I�[�o�[���C�h����ꍇ��
	///         pre_exp_filter�����post_exp_filter��ΏۂƂ��Ă��������B
	virtual function T exp_filter(T tr);
		T                   tr_exp;
		bit[31:0]           addr;
		bit[WORD_WIDTH-1:0] data[];
		
		// �v���t�B���^���{
		tr = pre_exp_filter(tr);
		if(tr==null) return tr;
		// �A�h���X�A�f�[�^���o
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
			// �|�X�g�t�B���^���{
			return post_exp_filter(tr_exp);
		end
		return null;
	endfunction
	
	///@brief   �ϑ��l�t�B���^
	///@details ���[�h�A�N�Z�X�����o���A���Ғl�Ƃ��܂��B
	///@note    �v���t�B���^�֐�pre_dat_filter�A�|�X�g�t�B���^�֐�post_dat_filter
	///         ��ǉ����Ă��܂��̂ŁA�t�B���^�������I�[�o�[���C�h����ꍇ��
	///         pre_dat_filter�����post_dat_filter��ΏۂƂ��Ă��������B
	virtual function T dat_filter(T tr);
		T tr_dat;
		// �v���t�B���^���{
		tr = pre_dat_filter(tr);
		if(tr==null) return tr;
		// RAM Read
		if(is_dat_read(tr))begin
			$cast(tr_dat ,tr.clone());
			// �|�X�g�t�B���^���{
			return post_dat_filter(tr_dat);
		end
		return null;
	endfunction
	
	///@brief   �������_���v
	///@details �������̓��e�����₷��������ŕԂ��܂��B
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
		//	for(bit[31:0] addr={start_addr[31:4],4'h0}; addr<start_addr+ram_size; addr++)begin // ���I�z��
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
	///@name OVM�t�F�[�Y
	///      OVM�W���̃V�~�����[�V�����t�F�[�Y���\�b�h
	//////////////////////////////////////////////////////////////////////////@{
	/// �R���X�g���N�^
	function new (string name="ScoreBoard" ,ovm_component parent=null);
		super.new(name, parent);
		title = "RAM Model ScoreBoard";
	endfunction : new
	
	///@brief   ���ݒ�
	///@details ���I�z�񃁃����̏��������s���܂��B
	///@warning ���݂̓�������A�z�z��Ŏ������Ă��邽�߁A���������͍s���Ă��܂���B
	virtual function void end_of_elaboration;
		super.end_of_elaboration;
	//	ram = new[ram_size]; // ���I�z��
	endfunction
	
	///@brief   �V�~�����[�V�����J�n������
	///@details ��������̕\�����s���܂��B
	virtual function void start_of_simulation;
		bit[31:0] end_addr;
		
		super.start_of_simulation;
		end_addr = start_addr+ram_size-1;
		$display("/--%s%s",msg_index,{(90-msg_index.len()){"-"}});
		$display("%s(%s)",title ,get_full_name());
		$display("Address      = 0x%04x_%04x - 0x%04x_%04x",start_addr[31:16],start_addr[15:0],end_addr[31:16],end_addr[15:0]);
		$display("%s/",{92{"-"}});
	endfunction
	
	///@brief   �V�~�����[�V�����I��������
	///@details �ʏ�̔�r���ʂɉ����A�������̃_���v�\�����s���܂��B
	///@note    �_���v�\����OVM_MEDIUM���x���ł��B
	virtual function void report;
		string msg;
		
		super.report;
		`ovm_info(msg_index,$psprintf("%s%s%s",{`VT100_BLUE},dump,{`VT100_NORMAL}),OVM_MEDIUM);
	endfunction
	//////////////////////////////////////////////////////////////////////////@}
endclass
