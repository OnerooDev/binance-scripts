#!/usr/bin/env bash
export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=0xF46bb3243453a36Edd84EE7b19E801c0437bE773
export ETH_GAS_PRICE=10000000000
export ETH_PASSWORD=password
export ETH_KEYSTORE=keys/keystore
export SETH_CHAIN=bsctest
export ETH_RPC_URL=https://data-seed-prebsc-1-s3.binance.org:8545
export ETHERSCAN_API_KEY=DUJ2SA4AXYMAIUM4AQCD74I85FP7CXFA3R

# seth ls
bin/dss-deploy bsctest

