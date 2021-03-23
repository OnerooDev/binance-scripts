#!/bin/bash

export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=0xaaCE3a65C179667f53B01fB3F28Db10a0dce9629
export ETH_GAS_PRICE=1000000000
export ETH_PASSWORD=password
export ETH_KEYSTORE=keys/keystore
export SETH_CHAIN=kovan
export ETH_RPC_URL=https://kovan.infura.io/v3/6cf197c96ea54310860815644865edbe
export ETHERSCAN_API_KEY=ZVQWRYYTMWGCRBQFAGNFJJKN6HV7JG51Y9

. "$LIB_DIR/common.sh"

loadAddresses


export ILK_REGISTRY=0x2F7E791ac4460F13D95D32f40b609B71eA34b9FC
export FL_REWARDER_GOV_USD=0x31902B4010A078712e3C1e470C33545Ba4DC5E52
export FL_REWARDER_STABLES=0x262A834838D51707A900e83c4e82FF3eA06D06CE


STAT=$(dappCreate freeliquid-ct-optimized CollateralStat)
echo $STAT

seth send $STAT "setup(address,address,address)" $ILK_REGISTRY $FL_REWARDER_GOV_USD $FL_REWARDER_STABLES

