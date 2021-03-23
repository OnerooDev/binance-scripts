#!/bin/bash

export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=0xef6f7bcd86e1b3fa52f80ee079b0ebd4bcea8edb
export ETH_GAS_PRICE=125000000000
export ETH_PASSWORD=passwordm
export ETH_KEYSTORE=keys/keystore
export SETH_CHAIN=mainnet
export ETH_RPC_URL=https://mainnet.infura.io/v3/6cf197c96ea54310860815644865edbe
export ETHERSCAN_API_KEY=ZVQWRYYTMWGCRBQFAGNFJJKN6HV7JG51Y9

. "$LIB_DIR/common.sh"

loadAddresses

STAT=$(dappCreate freeliquid-ct-optimized CollateralStat)
echo $STAT

seth send $STAT "setup(address,address,address)" $ILK_REGISTRY $FL_REWARDER_GOV_USD $FL_REWARDER_STABLES

