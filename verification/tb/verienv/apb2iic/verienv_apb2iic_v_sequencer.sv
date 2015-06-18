/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : Wed, 17 Jun 2015 01:47:38 +0900 
// Design Name   : $RCSfile: verienv_apb2iic_v_sequencer.sv,v $
// Project Name  : kataru1506 
// Project No.   : - 
// Syntax        : ovm-2.0.3
// Tool versions : Model Technology ModelSim ALTERA STARTER EDITION vsim 10.1d Simulator 2012.11 Nov 2 2012
// Revision      : $Revision: 1.5 $
// Last Update   : $Date: 2013/07/16 05:33:01 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
// バーチャルシーケンサ
/////////////////////////////////////////////////////////////////////////////
typedef class ovm_sequencer;
class verienv_apb2iic_v_sequencer extends ovm_sequencer#(ovm_sequence_item,ovm_sequence_item);
	`ovm_sequencer_utils(verienv_apb2iic_v_sequencer)
	function new (string name="verienv_apb2iic_v_seqr", ovm_component parent=null);
		super.new(name, parent);
		`ovm_update_sequence_lib
	endfunction : new
	
	verienv_apb2iic_config               m_config;    ///< 検証環境設定値
	protected virtual verienv_apb2iic_if intf;        ///< 検証環境用インターフェース
//	hoge_v_sequencer                 hoge_v_seqr;  ///< hogeモデル制御
	
	function void build();
		m_config = verienv_apb2iic_config::get_config(this);
		intf     = m_config.assign_vi();
	endfunction
	
	task set_verienv_port(verienv_apb2iic_port port ,logic[127:0] value);
		case(port)                                                       // <SET_PORT>
		PORT_PCLK       : intf.r_pclk           = value[0];    
		PORT_PRESETN    : intf.r_presetn        = value[0];    
		PORT_PADDR      : intf.r_paddr          = value[31:0]; 
		PORT_PWDATA     : intf.r_pwdata         = value[31:0]; 
		PORT_PWRITE     : intf.r_pwrite         = value[0];    
		PORT_PSELX      : intf.r_pselx          = value[0];    
		PORT_PENABLE    : intf.r_penable        = value[0];    
		PORT_SDA        : intf.r_sda            = value[0];    
		PORT_SCL        : intf.r_scl            = value[0];    
		default         : `ovm_warning("set_verienv_port",               //</>
			$psprintf("%ssorry ,set_verienv_port %s unsupported.%s",{`VT100_YELLOW} ,port.name ,{`VT100_NORMAL}))
		endcase
	endtask
	
	function [127:0] get_verienv_port(verienv_apb2iic_port port);
		get_verienv_port = 32'h0000_0000;
		case(port)                                                       //<GET_PORT>
		PORT_PCLK       : get_verienv_port[0]    = intf.pclk;            
		PORT_PRESETN    : get_verienv_port[0]    = intf.presetn;         
		PORT_PADDR      : get_verienv_port[31:0] = intf.paddr;           
		PORT_PWDATA     : get_verienv_port[31:0] = intf.pwdata;          
		PORT_PWRITE     : get_verienv_port[0]    = intf.pwrite;          
		PORT_PSELX      : get_verienv_port[0]    = intf.pselx;           
		PORT_PENABLE    : get_verienv_port[0]    = intf.penable;         
		PORT_PREADY     : get_verienv_port[0]    = intf.pready;          
		PORT_PSLVERR    : get_verienv_port[0]    = intf.pslverr;         
		PORT_INT_RX     : get_verienv_port[0]    = intf.int_rx;          
		PORT_INT_TX     : get_verienv_port[0]    = intf.int_tx;          
		PORT_PRDATA     : get_verienv_port[31:0] = intf.prdata;          
		PORT_SDA_ENABLE : get_verienv_port[0]    = intf.sda_enable;      
		PORT_SCL_ENABLE : get_verienv_port[0]    = intf.scl_enable;      
		PORT_SDA        : get_verienv_port[0]    = intf.sda;             
		PORT_SCL        : get_verienv_port[0]    = intf.scl;             
		default         : `ovm_warning("get_verienv_port",               //</>
			$psprintf("%ssorry ,get_verienv_port %s unsupported.%s",{`VT100_YELLOW} ,port.name ,{`VT100_NORMAL}))
		endcase
	endfunction
	
	task wait_verienv_port(verienv_apb2iic_port port ,logic[127:0] value);
		$display("Wait until %s = 0x%1x ",port.name ,value);
		case(port)                                                       //<WAIT_PORT>
		PORT_PCLK       : @(intf.pclk             === value[0]);    
		PORT_PRESETN    : @(intf.presetn          === value[0]);    
		PORT_PADDR      : @(intf.paddr            === value[31:0]); 
		PORT_PWDATA     : @(intf.pwdata           === value[31:0]); 
		PORT_PWRITE     : @(intf.pwrite           === value[0]);    
		PORT_PSELX      : @(intf.pselx            === value[0]);    
		PORT_PENABLE    : @(intf.penable          === value[0]);    
		PORT_PREADY     : @(intf.pready           === value[0]);    
		PORT_PSLVERR    : @(intf.pslverr          === value[0]);    
		PORT_INT_RX     : @(intf.int_rx           === value[0]);    
		PORT_INT_TX     : @(intf.int_tx           === value[0]);    
		PORT_PRDATA     : @(intf.prdata           === value[31:0]); 
		PORT_SDA_ENABLE : @(intf.sda_enable       === value[0]);    
		PORT_SCL_ENABLE : @(intf.scl_enable       === value[0]);    
		PORT_SDA        : @(intf.sda              === value[0]);    
		PORT_SCL        : @(intf.scl              === value[0]);    
		default         : `ovm_warning("wait_verienv_port",              //</>
			$psprintf("%ssorry ,wait_verienv_port %s unsupported.%s",{`VT100_YELLOW} ,port.name ,{`VT100_NORMAL}))
		endcase
		$display("detect.");
	endtask
	
	function void chk_verienv_port(verienv_apb2iic_port port ,logic[127:0] exp);
		logic[127:0] value;
		value = exp;
		case(port)                                                       //<CHK_PORT>
		PORT_PCLK       : value[0]    = intf.pclk;            
		PORT_PRESETN    : value[0]    = intf.presetn;         
		PORT_PADDR      : value[31:0] = intf.paddr;           
		PORT_PWDATA     : value[31:0] = intf.pwdata;          
		PORT_PWRITE     : value[0]    = intf.pwrite;          
		PORT_PSELX      : value[0]    = intf.pselx;           
		PORT_PENABLE    : value[0]    = intf.penable;         
		PORT_PREADY     : value[0]    = intf.pready;          
		PORT_PSLVERR    : value[0]    = intf.pslverr;         
		PORT_INT_RX     : value[0]    = intf.int_rx;          
		PORT_INT_TX     : value[0]    = intf.int_tx;          
		PORT_PRDATA     : value[31:0] = intf.prdata;          
		PORT_SDA_ENABLE : value[0]    = intf.sda_enable;      
		PORT_SCL_ENABLE : value[0]    = intf.scl_enable;      
		PORT_SDA        : value[0]    = intf.sda;             
		PORT_SCL        : value[0]    = intf.scl;             
		default         : `ovm_warning("chk_verienv_port",               //</>
			$psprintf("%ssorry ,chk_verienv_port %s unsupported.%s",{`VT100_YELLOW} ,port.name ,{`VT100_NORMAL}))
		endcase
		if(value!==exp)begin
			`ovm_error("chk_verienv_port",
			$psprintf("%sPORT check NG.(%s=0x%0x ,but exp is 0x%0x.%s",{`VT100_RED} ,port.name ,value ,exp ,{`VT100_NORMAL}))
		end else begin
			`ovm_info("chk_verienv_port",$psprintf("PORT check OK.(%s=0x%0x)",port.name ,value),OVM_LOW)
		end
	endfunction
	
	task wait_clk(int count=1);
		repeat(count)@(posedge intf.pclk);
	endtask
endclass
