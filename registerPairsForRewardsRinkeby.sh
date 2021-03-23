#!/usr/bin/env bash
export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export SETH_CHAIN=rinkeby
export ETH_FROM=0xaaCE3a65C179667f53B01fB3F28Db10a0dce9629
export ETH_PASSWORD=password
export ETH_KEYSTORE=keys/keystore

export ETH_RPC_URL=https://rinkeby.infura.io/v3/6cf197c96ea54310860815644865edbe

echo $ETH_FROM


. "$LIB_DIR/common.sh"

loadAddresses


FL_UNI_GOV_USD=0x3F3cd37F0B327117643cE99fD03cd028cC0b3587
FL_UNI_STABLE_USDC=0x7820085f390995f33cFA7e3D39F6fA378DeEcfEe  #USDFL/USDC
FL_UNI_STABLE_USDT=0x35D68bAf94C34737A41F69E6a7f3A05B46372c79  #USDFL/USDT
FL_UNI_STABLE_DAI=0xe2051ff137D74913595FB3A4BDE826A76b4d6b8B  #USDFL/DAI
FL_UNI_STABLE_USDN=0x55DF2f9a8d1bA39FD8DEec667bFce7F45d43E62B  #USDFL/USDN








test -z "$MCD_GOV" && echo "There is no MCD_GOV configured" && exit 1
test -z "$FL_UNI_GOV_USD" && echo "There is no FL_UNI_GOV_USD configured" && exit 1
test -z "$FL_UNI_ADAPTER_ONE_STABLE" && echo "There is no FL_UNI_ADAPTER_ONE_STABLE configured" && exit 1

echo "----"
seth call "$FL_REWARDER_GOV_USD" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_FL")")" 0x6ca0b8d3752d3dbacbc056d86c9a118beebda2a3

sethSend "$FL_REWARDER_GOV_USD" "registerPairDesc(address,address,uint,bytes32)" "${FL_UNI_GOV_USD}" "${FL_UNI_ADAPTER_ONE_STABLE}" 1 "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_FL")")"


sethSend "$FL_REWARDER_STABLES" "registerPairDesc(address,address,uint,bytes32)" "${FL_UNI_STABLE_USDT}" "${FL_UNI_ADAPTER_STABLES}" 1 "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_USDT")")"
sethSend "$FL_REWARDER_STABLES" "registerPairDesc(address,address,uint,bytes32)" "${FL_UNI_STABLE_USDC}" "${FL_UNI_ADAPTER_STABLES}" 1 "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_USDC")")"
sethSend "$FL_REWARDER_STABLES" "registerPairDesc(address,address,uint,bytes32)" "${FL_UNI_STABLE_USDN}" "${FL_UNI_ADAPTER_STABLES}" 1 "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_USDN")")"
sethSend "$FL_REWARDER_STABLES" "registerPairDesc(address,address,uint,bytes32)" "${FL_UNI_STABLE_DAI}" "${FL_UNI_ADAPTER_STABLES}" 1 "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_DAI")")"



ACCOUNT=0xFac6a0E831B2f4d42Ec23dDD1Ec37874353694d2

echo ""
echo "USDFL_FL"
seth call "$FL_REWARDER_GOV_USD" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_FL")")" "${ACCOUNT}"

echo ""
echo "USDFL_USDT"
seth call "$FL_REWARDER_STABLES" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_USDT")")" "${ACCOUNT}"
echo ""
echo "USDFL_USDC"
seth call "$FL_REWARDER_STABLES" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_USDC")")" "${ACCOUNT}"
echo ""
echo "USDFL_USDN"
seth call "$FL_REWARDER_STABLES" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_USDN")")" "${ACCOUNT}"
# echo ""
# echo "USDFL_DAI"
# seth call "$FL_REWARDER_STABLES" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_DAI")")" "${ACCOUNT}"

sethSend "$FL_REWARDER_STABLES" 'resetDeployer()'
sethSend "$FL_REWARDER_GOV_USD" 'resetDeployer()'
sethSend "$FL_REWARDER" 'resetDeployer()'

