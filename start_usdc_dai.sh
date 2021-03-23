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

#rm -f $OUT_DIR/load-fabs-addr-temp
#. $LIBEXEC_DIR/dss/deploy-fab
. $OUT_DIR/load-fabs-addr-temp

#rm -f $OUT_DIR/load-core-addr-temp
#. $LIBEXEC_DIR/dss/deploy-core
. $OUT_DIR/load-core-addr-temp


echo "deploy-core"
echo $?
echo "-----------"


token="USDCDAI"

oracle=$(dappCreate freeliquid-ct UniswapAdapterPriceOracle_Buck_Buck)
eval "export VAL_${token}=${oracle}"
log "VAL_${token}=$(eval "echo ${oracle}")"
eval "export PIP_${token}=\$VAL_${token}"


. $LIBEXEC_DIR/dss/deploy-rewarder
. $LIBEXEC_DIR/dss/deploy-ilk-usdcdai
. $LIBEXEC_DIR/setters/set-ilks-price
. $LIBEXEC_DIR/setters/set-ilks-pip-whitelist