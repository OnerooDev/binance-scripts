#!/usr/bin/env bash
export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export SETH_CHAIN=mainnet

export ETH_FROM=0xef6f7bcd86e1b3fa52f80ee079b0ebd4bcea8edb
export ETH_GAS_PRICE=70000000000
export ETH_PASSWORD=passwordm


export ETH_KEYSTORE=keys/keystore

export ETH_RPC_URL=https://mainnet.infura.io/v3/58073b4a32df4105906c702f167b91d2

echo $ETH_FROM


. "$LIB_DIR/common.sh"

loadAddresses


FL_UNI_STABLE_DAI=0xa8216f6eb1f36e1de04d39c3bc7376d2385f3455  #USDFL/DAI
FL_UNI_STABLE_USDN=0x85790c03400b7f6d35895dbb7198c41ecde4a7f7  #USDFL/USDN
FL_UNI_STABLE_USDT=0xedf7a6fb0d750dd807375530096ebf2e756eaee0  #USDFL/USDT
FL_UNI_STABLE_USDC=0x481c830edC1710E06e65c32bd7c05ADd5516985b  #USDFL/USDC


FL_UNI_GOV_USD=0xF03756E7a2B088A8c5D042C764184E8748dFA10d








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



sethSend "$FL_REWARDER_STABLES" 'resetDeployer()'
sethSend "$FL_REWARDER_GOV_USD" 'resetDeployer()'
sethSend "$FL_REWARDER" 'resetDeployer()'

