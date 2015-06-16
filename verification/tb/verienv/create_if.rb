#!/usr/bin/ruby

require "kconv"
require "optparse"
require "stringio"

verienv  = "apb2iic"
rtl_dir  = "../../../rtl/apbi2c/trunk/rtl/"
rtl_file = "i2c.v"

#変数
TB              = ""
BASE            = ""
CVSREP_TEMPLATE = "HDL_template/OVM"

pin_list        = Array.new
param_list      = Hash.new
top_module      = "xxxx"

#コマンド引数解析
opt = OptionParser.new
opt.on("--tb name"          ){|v| TB              = v}
opt.on("--cvs_template name"){|v| CVSREP_TEMPLATE = v}
opt.on("--rtl_dir name"     ){|v| rtl_dir         = v}
opt.on("--rtl_file name"    ){|v| rtl_file        = v}
opt.on("--verienv name"     ){|v| verienv         = v}

opt.parse(ARGV)

# RTLから端子情報を抜き出す
printf "[%s%s]" ,rtl_dir,rtl_file
rtl = open(rtl_dir+rtl_file)
rtl.each {|line|
	l    = line.toeuc.gsub(/^\s+/,"").gsub(/\s+$/,"")
	if l=~/^\s*module\s+(\w+)/ then
		top_module = $1
	end
	if l=~/^[^\/]*\)\s*;/ then
		break; # bug ari 2013/8/5  block comment,div(/) etc.
	end
	
	if l=~/^(input|output|inout)/ then
		#変数初期化
		l = l.gsub(/(input|output|inout)\s+(wire|reg)/,$1)
		pin  = Hash.new
		pin["attr"] = ""
		pin["msb" ] = 0
		pin["lsb" ] = 0
		pin["name"] = ""
		
		#方向のチェック
		pin["attr"]="in"  if l=~/^input/
		pin["attr"]="out" if l=~/^output/
		pin["attr"]="io"  if l=~/^inout/
		
		#名前、ビット幅、コメントの抽出
		if l=~/^(input|output|inout)[^\[]*\[([^:]+):([^\]]+)\]\s*(\w+)[^\/]*(\/\/.+){0,1}/ then
			pin["msb" ] = $2
			pin["lsb" ] = $3
			pin["name"] = $4
			pin["comm"] = $5.nil? ? "" : $5
		elsif l=~/^(input|output|inout)\s+(\w+)[^\/]*(\/\/.+){0,1}/ then
			pin["msb" ] = 0
			pin["lsb" ] = 0
			pin["name"] = $2
			pin["comm"] = $3.nil? ? "" : $3
		end
		
		#格納
		pin_list.push(pin)
	end
	
	#パラメータの抽出
	if l=~/^parameter\s+([^\s=]+)\s*=\s*([^\s;]+)/ then
		param_list[$1] = $2
	end
}

if param_list.size>0 then
	print "\n"
	print "---------------------------------+-----------------\n"
	print " Parameter                       |Value\n"
	print "---------------------------------+-----------------\n"
	param_list.each_pair { |key,val|
		printf " %-32s|%s",key ,val
		val.sub!(/[\d]+'h/,"0x")
		val.sub!(/[\d]+'d/,"")
		val.sub!(/[\d]+'b/,"0b")
		if val=~/^0[xb]/ then
			printf " (%0d)\n",val
		else
			printf "\n"
		end
	}
	print "---------------------------------+-----------------\n"
end
print "\n"
print "--------+-----------------------------\n"
print "Dir\t|Port\n"
print "--------+-----------------------------\n"
pin_list.each { |pin|
	param_list.each_pair { |key,val|
		pin["msb"].to_s.sub!(key,val)
		pin["lsb"].to_s.sub!(key,val)
	}
	pin["msb"] = eval(pin["msb"].to_s)
	pin["lsb"] = eval(pin["lsb"].to_s)
	if pin["msb"].to_i>0 then
		printf "%s\t|%s[%s:%s]\n",pin["attr"] ,pin["name"].upcase ,pin["msb"] ,pin["lsb"]
	else
		printf "%s\t|%s\n"       ,pin["attr"] ,pin["name"].upcase
	end
}
print "--------+-----------------------------\n"

#ファイルの書き換え
flag      = 0
node      = ""

#interface記述の修正
str_buff  = String.new
sv_if_in  = open(sprintf("./%s/verienv_%s_if.sv",verienv,verienv) ,'r')
sv_if_out = StringIO.new(str_buff)
$stdout   = sv_if_out

sv_if_in.each {|line|
	l = line.tosjis
	
	print l if flag==0
	
	# 編集領域開始
	if l=~/\/\/.*<(\w+)>/ then
		flag = 1
		node = $1
	end
	
	# 編集領域終了
	if l=~/\/\/.*<\/>/ then
		# コード生成
		case node
		when "CNCT"
			# 接続用
			pin_list.each { |pin|
				name = pin["name"].downcase
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				type = "logic"
				type = "wire " if attr=="io"
				comm = "///< " if comm==""
				next if name==""
				if msb==lsb then
					printf "\t%s       %-16s%s\n",type,name+";",comm
				else
					printf "\t%s[%2d:%0d] %-16s%s\n",type,msb-lsb,0,name+";",comm
				end
			}
			print "\t\n"
			
			# 出力用レジスタ
			pin_list.each { |pin|
				name = pin["name"].downcase
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				next if attr=="out"
				if msb==lsb then
					printf "\treg         %s\n","r_"+name+";"
				else
					printf "\treg  [%2d:%0d] %s\n",msb-lsb,0,"r_"+name+";"
				end
			}
			# アサイン
			pin_list.each { |pin|
				name = pin["name"].downcase
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				next if attr=="out"
				printf "\tassign %-16s = %s\n",name,"r_"+name+";"
			}
		end
		flag = 0
		node = ""
		print l
	end
}
sv_if_in.close
$stdout   = STDOUT

open(sprintf("./%s/verienv_%s_if.sv",verienv,verienv) ,'w') {|f|
	f.puts(str_buff)
}
printf "verienv_%s_if.sv ... Done.\n",verienv

#端子enum記述(share)の修正
str_buff     = String.new
sv_share_in  = open(sprintf("./%s/verienv_%s_share.sv",verienv,verienv) ,'r')
sv_share_out = StringIO.new(str_buff)
$stdout      = sv_share_out

sv_share_in.each {|line|
	l = line.tosjis
	
	print l if flag==0
	
	# 編集領域開始
	if l=~/\/\/.*<(\w+)>/ then
		flag = 1
		node = $1
	end
	
	# 編集領域終了
	if l=~/\/\/.*<\/>/ then
		# コード生成
		case node
		when "ENUM"
			# モジュールトップ端子
			print "typedef enum {\n"
			max_size = 0
			size     = 0
			pin_list.each { |pin|
				next if pin["name"]==""
				max_size+=1
			}
			pin_list.each { |pin|
				name = pin["name"].upcase
				comm = pin["comm"].tosjis
				next if name==""
				size+=1
				printf "\t%-24s%s %s\n","PORT_"+name,size==max_size ? " ":"," ,comm
			}
			printf "} verienv_%s_port;\n" ,verienv
		end
		flag = 0
		node = ""
		print l
	end
}
sv_share_in.close
$stdout   = STDOUT

open(sprintf("./%s/verienv_%s_share.sv",verienv,verienv) ,'w') {|f|
	f.puts(str_buff)
}
printf "verienv_%s_share.sv ... Done.\n",verienv

#端子アクセス記述(v_sequencer)の修正
str_buff    = String.new
sv_vseq_in  = open(sprintf("./%s/verienv_%s_v_sequencer.sv",verienv,verienv) ,'r')
sv_vseq_out = StringIO.new(str_buff)
$stdout     = sv_vseq_out

sv_vseq_in.each {|line|
	l = line.tosjis
	
	print l if flag==0
	
	# 編集領域開始
	if l=~/\/\/.*<(\w+)>/ then
		flag = 1
		node = $1
	end
	
	# 編集領域終了
	if l=~/\/\/.*<\/>/ then
		# コード生成
		case node
		when "SET_PORT"
			# set_verienv_port
			pin_list.each { |pin|
				name = pin["name"]
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				next if attr=="out"
				printf "\t\t%-16s: intf.%-16s =","PORT_"+name.upcase ,"r_"+name.downcase
				if msb==lsb then
					printf " value[0];    %s\n",comm
				else
					printf " value[%2d:%0d]; %s\n",msb-lsb,0,comm
				end
			}
		when "GET_PORT"
			# get_verienv_port
			pin_list.each { |pin|
				name = pin["name"].downcase
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				printf "\t\t%-16s: get_verienv_port","PORT_"+name.upcase
				if msb==lsb then
					printf "[0]    = intf.%-16s %s\n",name+";" ,comm
				else
					printf "[%2d:%0d] = intf.%-16s %s\n",msb-lsb,0,name+";" ,comm
				end
			}
		when "WAIT_PORT"
			# wait_verienv_port
			pin_list.each { |pin|
				name = pin["name"].downcase
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				printf "\t\t%-16s: ","PORT_"+name.upcase
				if msb==lsb then
					printf "@(intf.%-16s === value[0]);    %s\n",name ,comm
				else
					printf "@(intf.%-16s === value[%2d:%0d]); %s\n",name ,msb-lsb,0,comm
				end
			}
		when "CHK_PORT"
			# chk_verienv_port
			pin_list.each { |pin|
				name = pin["name"].downcase
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				printf "\t\t%-16s: value","PORT_"+name.upcase
				if msb==lsb then
					printf "[0]    = intf.%-16s %s\n",name+";" ,comm
				else
					printf "[%2d:%0d] = intf.%-16s %s\n",msb-lsb,0,name+";" ,comm
				end
			}
		end
		flag = 0
		node = ""
		print l
	end
}
sv_vseq_in.close
$stdout = STDOUT

open(sprintf("./%s/verienv_%s_v_sequencer.sv",verienv,verienv) ,'w') {|f|
	f.puts(str_buff)
}
printf "verienv_%s_v_sequencer.sv ... Done.\n",verienv

#DUV配置(DUV.v)の修正
str_buff   = String.new
sv_duv_in  = open(sprintf("./%s/DUV.v",verienv) ,'r')
sv_duv_out = StringIO.new(str_buff)
$stdout    = sv_duv_out

sv_duv_in.each {|line|
	l = line.tosjis
	
	print l if flag==0
	
	# 編集領域開始
	if l=~/\/\/.*<(\w+)>/ then
		flag = 1
		node = $1
	end
	
	# 編集領域終了
	if l=~/\/\/.*<\/>/ then
		# コード生成
		case node
		when "DUV"
			# トップモジュールのインスタンス
			printf "\t%s %s (\n" ,top_module ,"u_"+top_module.downcase
			max_size = 0
			size     = 0
			pin_list.each { |pin|
				next if pin["name"]==""
				max_size+=1
			}
			pin_list.each { |pin|
				name = pin["name"]
				attr = pin["attr"]
				msb  = pin["msb"]
				lsb  = pin["lsb"]
				comm = pin["comm"].tosjis
				next if name==""
				size+=1
				printf "\t\t.%-16s (port_if.%-16s ) %s // ",name ,name.downcase ,size==max_size ? " " : ","
				if msb==lsb then
					printf "%s\n",attr
				else
					printf "%s[%0d:%0d]\n",attr ,msb ,lsb
				end
			}
		end
		flag = 0
		node = ""
		print l
	end
}
sv_duv_in.close
$stdout = STDOUT

open(sprintf("./%s/DUV.v",verienv) ,'w') {|f|
	f.puts(str_buff)
}
print "DUV.v ... Done.\n"
