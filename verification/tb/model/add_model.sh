#!/bin/csh -f
set TB              = "top"
set PJ_NAME         = "-"
set PJ_NUM          = "-"

##############################################################################
# 以下は原則として修正不要
##############################################################################
set CVSREP_OVM      = OVM/ovm-2.0.3
set CVSREP_TEMPLATE = HDL_template/OVM
set CREATE_DATE     = `date -R`
set SYNTAX          = ${CVSREP_OVM:t}
set TOOL_VERSIONS   = `vsim -version`

# オプションの読み込み #######################################################
@ args = 1
set arg_num = $#argv

if($arg_num == 0)then
    goto Help
endif

while($args <= $arg_num)
    switch ($argv[$args])
    case -top:
        @ args += 1
        set RTLFILE = "$argv[$args]"
        breaksw
    case -rtl:
        @ args += 1
        set RTLDIR = "$argv[$args]"
        breaksw
    case -tb:
        @ args += 1
        set TB = "$argv[$args]"
        breaksw
    case -dir:
        @ args += 1
        set VERIDIR = "$argv[$args]"
        breaksw
    case -pj_name:
        @ args += 1
        set PJ_NAME = "$argv[$args]"
        breaksw
    case -pj_num:
        @ args += 1
        set PJ_NUM = "$argv[$args]"
        breaksw
    default:
        set module = "$argv[$args]"
        cvs -q co -p -D tomorrow ${CVSREP_TEMPLATE}/tb/model/${module}/${module}.svh >& /dev/null
        if($status == 0)then
            echo "検証モデルをcheckoutします：${module}"
            cvs co -D tomorrow -d ${module} ${CVSREP_TEMPLATE}/tb/model/{$module}
        else
            echo "検証モデルが見つかりませんでした。:${module}"
        endif
        breaksw
    endsw
    @ args += 1
end

# チェックアウト #############################################################

#     if(-f ${oldfile}) then
#         set newfile = `echo ${oldfile} | sed "s/xxxx/${TB}/"`
#         if( ${oldfile} != ${newfile} ) then
#             echo "${newfile:t}   \t(create from ${oldfile:t})"
#         else
#             set oldfile = ${oldfile}_$$
#             echo "${newfile:t}"
#             mv ${newfile} ${oldfile}
#         endif
#         sed ${oldfile} \
#             -e "s/xxxx/${TB}/g" \
#             -e "/^\/\/ Create Date *:/s/:/: ${CREATE_DATE}/" \
#             -e "/^\/\/ Project Name *:/s/:/: ${PJ_NAME}/" \
#             -e "/^\/\/ Project No. *:/s/:/: ${PJ_NUM}/" \
#             -e "/^\/\/ Syntax *:/s/:.*/: ${SYNTAX}/" \
#             -e "/^\/\/ Tool versions *:/s/:.*/: ${TOOL_VERSIONS}/" \
#             -e "/setenv OVMHOME/s/lib.*/lib\/${CVSREP_OVM:t}/" \
#             > ${newfile}
#         \rm -r -f ${oldfile}
#     endif
# end


# 正常終了 ###################################################################
echo "検証モデルの追加が正常に終了しました。"
exit 0

# ヘルプ #####################################################################
Help:
set REV    = `echo '$Revision: 1.2 $'             | cut -d " " -f 2`
set UPDATE = `echo '$Date: 2012/11/09 08:45:14 $' | cut -d " " -f 2-3`

echo "OVM検証モデル追加スクリプト rev${REV} (LastUpdate ${UPDATE})"
echo "<OPTIONS>"
echo "    {モデル名}          : 追加したい検証モデル名"
echo "    -pj_name {名前}     : ヘッダに記載するプロジェクト名 ※半角推奨"
echo "    -pj_num {番号}      : ヘッダに記載するプロジェクト番号 ※半角推奨"

set filepath = ${CVSROOT}/${CVSREP_TEMPLATE}/tb/model
echo "【検証モデル一覧】"
foreach module ( `ls ${filepath}` )
    set comment = ""
    cvs -q co -p -D tomorrow ${CVSREP_TEMPLATE}/tb/model/${module}/readme.utf8 >& /dev/null
    if($status == 0)then
        set comment = `cvs -q co -p -D tomorrow ${CVSREP_TEMPLATE}/tb/model/${module}/readme.utf8 | head -1`
    endif
    printf "  ・%-20s // %s\n" $module "$comment"
end

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
echo "検証モデルの追加に失敗しました。"
exit 1
