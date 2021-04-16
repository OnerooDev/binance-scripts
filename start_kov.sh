#!/usr/bin/env bash
export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=0x701123a676E9A765191276C1587c01b009646EF6
export ETH_GAS_PRICE=10000000000
export ETH_PASSWORD=password
export ETH_KEYSTORE=keys/keystore
export SETH_CHAIN=kovan
export ETH_RPC_URL=https://kovan.infura.io/v3/4b7137f3af3f4c18873a5837bbd7c0ba 
export ETHERSCAN_API_KEY=DUJ2SA4AXYMAIUM4AQCD74I85FP7CXFA3R

# seth ls
bin/dss-deploy kovan

