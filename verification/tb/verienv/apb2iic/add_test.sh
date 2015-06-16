#!/bin/csh -f
##############################################################################
# 以下は原則として修正不要

set BASE_TEST = test0001

# オプションの読み込み #######################################################
@ args = 1
set arg_num = $#argv
while($args <= $arg_num)
    switch ($argv[$args])
    case -base:
        @ args += 1
        set BASE_TEST = "$argv[$args]"
        breaksw
    case -new:
        @ args += 1
        set MAKE_TEST = "$argv[$args]"
        breaksw
    default:
        goto Help
        breaksw
    endsw
    @ args += 1
end

# テストパタンの追加 #########################################################
if(-f test/verienv_apb2iic_${BASE_TEST}_test.sv) then
    sed "s/apb2iic_${BASE_TEST}/apb2iic_${MAKE_TEST}/g" test/verienv_apb2iic_${BASE_TEST}_test.sv > test/verienv_apb2iic_${MAKE_TEST}_test.sv
else
    echo "[test/verienv_apb2iic_${BASE_TEST}_test.sv]が見つかりませんでした。"
    goto Error
endif
if(-f test/verienv_apb2iic_${BASE_TEST}_vseq.sv) then
    sed "s/apb2iic_${BASE_TEST}/apb2iic_${MAKE_TEST}/g" test/verienv_apb2iic_${BASE_TEST}_vseq.sv  > test/verienv_apb2iic_${MAKE_TEST}_vseq.sv
else
    echo "[test/verienv_apb2iic_${BASE_TEST}_vseq.sv]が見つかりませんでした。"
    goto Error
endif
if(-f verienv_apb2iic_test_list.sv) then
    cp verienv_apb2iic_test_list.sv verienv_apb2iic_test_list.sv_$$
    set ADD_TEST = '`'"include "'"'"test/verienv_apb2iic_${MAKE_TEST}_test.sv"'"'
    set ADD_VSEQ = '`'"include "'"'"test/verienv_apb2iic_${MAKE_TEST}_vseq.sv"'"'
    sed verienv_apb2iic_test_list.sv_$$ \
        -e "/\/\/TEST\/\//i $ADD_TEST" \
        -e "/\/\/VSEQ\/\//i $ADD_VSEQ" \
        > verienv_apb2iic_test_list.sv
    \rm -r -f verienv_apb2iic_test_list.sv_$$
else
    echo "[verienv_apb2iic_test_list.sv]が見つかりませんでした。"
    goto Error
endif

# 正常終了 ###################################################################
echo "テストパタンの追加が正常に終了しました。"
exit 0

# ヘルプ #####################################################################
Help:
set REV    = `echo '$Revision: 1.1 $'             | cut -d " " -f 2`
set UPDATE = `echo '$Date: 2012/03/26 12:20:11 $' | cut -d " " -f 2-3`

echo "OVMテストパタン追加スクリプト rev${REV} (LastUpdate ${UPDATE})"
echo "<OPTIONS>"
echo "   [-base {シナリオ名}] : 参照元シナリオ名(デフォルト:[${BASE_TEST}])"
echo "    -new  {シナリオ名}  : 作成シナリオ名"
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
echo "テストパタンの追加に失敗しました。"
exit 1
