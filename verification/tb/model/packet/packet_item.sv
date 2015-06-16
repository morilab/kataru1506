/////////////////////////////////////////////////////////////////////////////
// Engineer      : $Author: MoriLab. $
// Create Date   : 2013/03/30 12:00:00
// Design Name   : $RCSfile: packet_item.sv,v $
// Project Name  : Packet
// Project No.   : 
// Syntax        : OVM2.0.3
// Tool versions : ModelSim10.1
// Revision      : $Revision: 1.1 $
// Last Update   : $Date: 2013/04/11 00:35:12 $ + 09:00:00
//<Additional Comments>//////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////////////////////////////
class packet_item extends ovm_sequence_item;
	bit[7:0] data[];

	function new (string name = "packet_item");
		super.new(name);
	endfunction
	
	`ovm_object_utils_begin(packet_item)
		`ovm_field_array_int(data ,OVM_ALL_ON)
	`ovm_object_utils_end

	/// オブジェクト情報
	function string convert2string();
		string msg = "PacketItem =";
		foreach(data[n]) msg = $psprintf("%s 0x%02x",msg ,data[n]);
		msg = $psprintf("%s;",msg);
		return msg;
	endfunction
endclass
