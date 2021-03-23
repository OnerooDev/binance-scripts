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

ilkascii="TUSDUSDC-A"
luid=1
cdpi=14
daiStake=2000

export FLIP=0x76AE958f27aB4759De710854F529b8C67709d598
export JOIN=0x005ad6A86bD169C6E06c1B1BDec4992B5e69ddfB


ilk="$(seth --to-bytes32 "$(seth --from-ascii "${ilkascii}")")"

echo ilk:$ilk cdpi:$cdpi luid:$luid


wad=$(seth --to-uint256 "$(seth --to-wei "$daiStake" eth)")

urn=$(seth call $CDP_MANAGER "urns(uint)(address)" $cdpi)

seth send $MCD_CAT "bite(bytes32,address)" $ilk $urn


seth send $MCD_DAI "approve(address,uint256)" $MCD_JOIN_DAI $wad
seth send $MCD_JOIN_DAI "join(address,uint)" $ETH_FROM $wad
seth send $MCD_VAT "hope(address)" $FLIP
seth send $MCD_VAT "hope(address)" $FLIP
seth send $FLIP "tend(uint256,uint256,uint256)" $luid 200000000000000 300580015388306257905221550882945554421029044326
seth send $FLIP "deal(uint)" $luid

toexit=$(seth call $MCD_VAT "gem(bytes32,address)(uint)" $ilk $ETH_FROM)
echo toexit:$toexit
seth send $JOIN "exit(address,uint)" $ETH_FROM $toexit
