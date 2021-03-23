#!/usr/bin/env bash
export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export SETH_CHAIN=kovan
export ETH_RPC_URL=127.0.0.1:7545
# export ETH_FROM=$(seth rpc eth_coinbase)
export ETH_FROM=0xaaCE3a65C179667f53B01fB3F28Db10a0dce9629
export ETH_PASSWORD=password
export ETH_KEYSTORE=keys/keystore

export ETH_RPC_URL=https://kovan.infura.io/v3/6cf197c96ea54310860815644865edbe

echo $ETH_FROM


. "$LIB_DIR/common.sh"

loadAddresses


FL_UNI_GOV_USD=0x567CF82c5Afa663671b33D5cd5A1753e9d78A0d2
FL_UNI_STABLE_USDC=0x26a3fc5301510C80c858d422d10B137d8827f848  #USDFL/USDC
FL_UNI_STABLE_DAI=0x1f0cB6f49815471B753421bc5aC52236653738FA  #USDFL/DAI
FL_UNI_STABLE_USDN=0x6154A520347f323675D2ED6b879B87f7b54b36c0  #USDFL/USDN
FL_UNI_STABLE_USDT=0x37D5B02388A5fF8F7D37B83B84395f9F2D714DfD  #USDFL/USDT




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


ACCOUNT=0x6ca0b8d3752D3dbacbC056d86C9a118BeEBDa2a3

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
echo ""
echo "USDFL_DAI"
seth call "$FL_REWARDER_STABLES" "getPairInfo(bytes32,address)(address,uint,uint,uint)" "$(seth --to-bytes32 "$(seth --from-ascii "USDFL_DAI")")" "${ACCOUNT}"

# sethSend "$FL_REWARDER_STABLES" 'resetDeployer()'
# sethSend "$FL_REWARDER_GOV_USD" 'resetDeployer()'
# sethSend "$FL_REWARDER" 'resetDeployer()'

