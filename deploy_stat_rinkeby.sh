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
export SETH_CHAIN=rinkeby
export ETH_RPC_URL=https://rinkeby.infura.io/v3/6cf197c96ea54310860815644865edbe
export ETHERSCAN_API_KEY=ZVQWRYYTMWGCRBQFAGNFJJKN6HV7JG51Y9

. "$LIB_DIR/common.sh"

loadAddresses

export ILK_REGISTRY=0xfF1A70d453f441446e33c1d7d1bfB0ca826FD373
export FL_REWARDER_GOV_USD=0xB78b9ddC192484274d842A6d88c6056362f7B50E
export FL_REWARDER_STABLES=0xB43877C6ccCEfEE4c5226B2b5F0AAb9075124db1


STAT=$(dappCreate freeliquid-ct-optimized CollateralStat)
echo $STAT

seth send $STAT "setup(address,address,address)" $ILK_REGISTRY $FL_REWARDER_GOV_USD $FL_REWARDER_STABLES

