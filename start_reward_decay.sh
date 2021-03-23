#!/usr/bin/env bash
export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=$(seth rpc eth_coinbase)
export ETH_PASSWORD=/dev/null
export ETH_KEYSTORE=~/.dapp/testnet/8545/keystore

echo $ETH_FROM

. "$LIB_DIR/common.sh"



MCD_GOV=$(dappCreate ds-token DSToken "$(seth --to-bytes32 "$(seth --from-ascii "FL")")")
log "MCD_GOV=$MCD_GOV"

. "$LIBEXEC_DIR/dss/deploy-rewarder"

echo "------------------------------"
echo "$FL_REWARDER_GOV_USD_HOLDER"
echo "$FL_REWARDER_STABLES_HOLDER"


