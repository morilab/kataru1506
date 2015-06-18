// インターフェース用実装パッケージ
package message_pkg;
	class msg_if;
		event  ev_info;
		event  ev_warning;
		event  ev_error;
		event  ev_fatal;
		string msg_info[$];
		string msg_warning[$];
		string msg_error[$];
		string msg_fatal[$];
		
		function void info(string str);
			msg_info.push_back(str);
			->ev_info;
		endfunction
		
		function void warning(string str);
			msg_warning.push_back(str);
			->ev_warning;
		endfunction
		
		function void error(string str);
			msg_error.push_back(str);
			->ev_error;
		endfunction
		
		function void fatal(string str);
			msg_fatal.push_back(str);
			->ev_fatal;
		endfunction
	endclass
endpackage
