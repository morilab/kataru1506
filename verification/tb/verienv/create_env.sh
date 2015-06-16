#!/bin/csh -f

##############################################################################
# 自動置換対象
##############################################################################
set PJ_NAME         = "-"
set PJ_NUM          = "-"
set CVSREP_OVM      = OVM/ovm-2.0.3
set CVSREP_TEMPLATE = HDL_template/OVM
set RTLDIR1         = "../../.././rtl/apbi2c/trunk/rtl/"
set RTLDIR2         = "../../.././rtl/apbi2c/trunk/rtl/"

##############################################################################
# 必要に応じて変更
##############################################################################
set TB              = ""
set BASE            = ""
set RTLFILE         = ""
set CREATE_DATE     = `date -R`
set SYNTAX          = ${CVSREP_OVM:t}
set TOOL_VERSIONS   = `vsim -version`


# オプションの読み込み #######################################################
@ args = 1
set arg_num = $#argv
while($args <= $arg_num)
    switch ($argv[$args])
    case -tb:
        @ args += 1
        set TB = "$argv[$args]"
        breaksw
    case -top:
        @ args += 1
        set RTLFILE = "$argv[$args]"
        breaksw
    case -base:
        @ args += 1
        set BASE = "$argv[$args]"
        breaksw
    case -rtl:
        @ args += 1
        set RTLDIR2 = "$argv[$args]"
        breaksw
    case -pj_name:
        @ args += 1
        set PJ_NAME = "$argv[$args]"
        breaksw
    case -pj_num:
        @ args += 1
        set PJ_NUM = "$argv[$args]"
        breaksw
    case -h:
    case -help:
    default:
        goto Help
        breaksw
    endsw
    @ args += 1
end

# 引数チェック ################################################################
if(${TB} == "") then
    echo "-tb により、作成したい環境名を指定する必要があります。"
    goto Help
endif
if(${RTLFILE} == "") then
    echo "-top により、モジュールの含まれるファイル名を指定する必要があります。"
    goto Help
endif
if(-f ${RTLDIR2}/${RTLFILE}) then
    echo "ファイル[${RTLDIR2}/${RTLFILE}]から環境を生成します。"
else
    echo "ファイル[${RTLDIR2}/${RTLFILE}]が見つかりません。"
    goto Error
endif

# フォルダの作成 ##############################################################
if(-d ${TB}) then
    echo "フォルダ[./${TB}]は既に存在しています。処理を中断しました。"
#   goto Error
else
    mkdir ${TB}
endif

# 検証環境のコピー #############################################################
if(${BASE} == "") then
    cvs -q export -D tomorrow -d ${TB} ${CVSREP_TEMPLATE}/tb/verienv/xxxx
    set filepath = ${TB}
    foreach oldfile ( `find ${filepath}` )
        if(-f ${oldfile}) then
            set newfile = `echo ${oldfile} | sed "s/xxxx/${TB}/"`
            if( ${oldfile} != ${newfile} ) then
                echo "${newfile:t}   \t(create from ${oldfile:t})"
            else
                set oldfile = ${oldfile}_$$
                echo "${newfile:t}"
                mv ${newfile} ${oldfile}
            endif
            sed ${oldfile} \
                -e "s/xxxx/${TB}/g" \
                -e "/^\/\/ Create Date *:/s/:/: ${CREATE_DATE}/" \
                -e "/^\/\/ Project Name *:/s/:/: ${PJ_NAME}/" \
                -e "/^\/\/ Project No. *:/s/:/: ${PJ_NUM}/" \
                -e "/^\/\/ Syntax *:/s/:.*/: ${SYNTAX}/" \
                -e "/^\/\/ Tool versions *:/s/:.*/: ${TOOL_VERSIONS}/" \
                > ${newfile}
            \rm -r -f ${oldfile}
        endif
    end
else
    if(-f ${BASE}/CVS/Repository) then
        set CVSREP_BASE = `tr -d '\n' < ${BASE}/CVS/Repository`
    else
        echo "参照元となる環境[${BASE}]はCVSに登録してある必要があります。"
        goto Error
    endif
    cvs -q export -D tomorrow -d ${TB} ${CVSREP_BASE}
    set filepath = ${TB}
    foreach oldfile ( `find ${filepath}` )
        if(-f ${oldfile}) then
            set newfile = `echo ${oldfile} | sed "s/verienv_${BASE}/verienv_${TB}/"`
            if( ${oldfile} != ${newfile} ) then
                echo "${newfile:t}   \t(create from ${oldfile:t})"
            else
                set oldfile = ${oldfile}_$$
                echo "${newfile:t}"
                mv ${newfile} ${oldfile}
            endif
            sed ${oldfile} \
                -e "s/verienv_${BASE}/verienv_${TB}/g" \
                -e "/\/\/.*${BASE}/s/{BASE}/${TB}/g" \
                -e "/^\/\/ Create Date *:/s/:/: ${CREATE_DATE}/" \
                > ${newfile}
            \rm -r -f ${oldfile}
        endif
    end
endif

# 端子の自動追加
echo "トップモジュールの端子を反映中"
ruby create_if.rb --verienv ${TB} --rtl_dir ${RTLDIR2}/ --rtl_file ${RTLFILE}
echo "   ../tb/verienv/${RTLDIR2}/${RTLFILE}" >  ${TB}/design.f
echo "-y ../tb/verienv/${RTLDIR2}"            >> ${TB}/design.f
#if(${RTLDIR1} <> ${RTLDIR2}) then
#    echo "-y ../tb/verienv/${RTLDIR1}"        >> ${TB}/design.f
#endif
# 正常終了 ###################################################################
echo "環境構築が正常に終了しました。"
exit 0

# ヘルプ #####################################################################
Help:
set REV    = `echo '$Revision: 1.8 $'             | cut -d " " -f 2`
set UPDATE = `echo '$Date: 2012/12/06 08:58:45 $' | cut -d " " -f 2-3`

echo "OVM検証環境複製スクリプト rev${REV} (LastUpdate ${UPDATE})"
echo "<OPTIONS>"
echo "    -tb  {検証環境名}   : 作成するテスト環境名"
echo "    -top {モジュール}   : TOPモジュールファイル名"
echo "   [-rtl {フォルダ}    ]: 検証対象RTLを格納するフォルダ名(デフォルト:[${RTLDIR1}])"
echo "   [-base {検証環境名} ]: ベースとするテスト環境名(デフォルト:[テンプレートリポジトリxxxx])"
echo "   [-pj_name {名前}    ]: ヘッダに記載するプロジェクト名(※半角推奨)"
echo "   [-pj_num  {番号}    ]: ヘッダに記載するプロジェクト番号(※半角推奨)"
exit 1

# 異常終了 ###################################################################
Error:
echo "       #######"
echo "       #"
echo "       #"
echo "       #         # ###   # ###   ###     # ###"
echo "       ######    ##      ##     #   #    ##"
echo "       #         #       #     #     #   #"
echo "       #         #       #     #     #   #"
echo "       #         #       #      #   #    #"
echo "       #######   #       #       ###     #"
echo ""
echo "環境構築に失敗しました。"
exit 1
