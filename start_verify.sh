#!/bin/bash

export BIN_DIR='bin'
export LIB_DIR='lib'
export VERIFY_DIR=`pwd`/'verify'
export LIBEXEC_DIR=`pwd`/'libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=0xaaCE3a65C179667f53B01fB3F28Db10a0dce9629
export ETH_GAS_PRICE=1000000000
export ETH_PASSWORD=password
export ETH_KEYSTORE=keys/keystore
export SETH_CHAIN=kovan
export ETH_RPC_URL=https://kovan.infura.io/v3/6cf197c96ea54310860815644865edbe
# export ETHERSCAN_API_KEY=ZVQWRYYTMWGCRBQFAGNFJJKN6HV7JG51Y9
export ETHERSCAN_API_KEY=IS4TM27GV28E2MKQFXVUUC7IHDIM95SQF7

. "$LIB_DIR/common.sh"

export SCHEMA_FILE="${VERIFY_DIR}/schema.json"

loadAddresses

export CHAIN_ID=$(seth rpc net_version)
export MCD_ESM_PIT=0x0000000000000000000000000000000000000000

MCD_ESM_MIN="$(seth --to-uint256 "$(seth --to-wei "$(jq -r ".esm_min | values" "$CONFIG_FILE")" "eth")")"
export MCD_ESM_MIN

echo $MCD_ESM_MIN



PROXY_CACHE=$(seth --to-checksum-address $(seth call $PROXY_FACTORY "cache()(address)"))
echo PROXY_CACHE:$PROXY_CACHE



contractNames=$(jq -r ".contracts | keys_unsorted[]" "$SCHEMA_FILE")

for name in $contractNames; do
    contract=$(jq -r ".contracts.${name} | .contract | values" "$SCHEMA_FILE")
    gen=$(jq -r ".contracts.${name} | .gen | values" "$SCHEMA_FILE")
    prj=$(jq -r ".contracts.${name} | .prj | values" "$SCHEMA_FILE")
    sign=$(jq -r ".contracts.${name} | .sign | values" "$SCHEMA_FILE")
    args=$(jq -r ".contracts.${name} | .args | values" "$SCHEMA_FILE")
    path=$(jq -r ".contracts.${name} | .path | values" "$SCHEMA_FILE")


    if [[ "$prj" == "" ]]; then
        continue
    fi

    if [[ "$path" == "" ]]; then
        echo "ERROR EMPTY PATH" $name
        continue
    fi

    address=$(eval echo \$$name)

    if [[ "$address" == "" ]]; then
        echo "ERROR WRONG ADDRESS" $name $address $path, $prj $sign $rargs
        continue
    fi



    pushd $DAPP_LIB/$prj > /dev/null
    echo "cd $DAPP_LIB/$prj"

    export source=

    if [[ "$contract" != "" ]]; then
        srcfile="${VERIFY_DIR}/${contract}"
        echo srcfile:$srcfile
        export source=$(cat $srcfile)
    fi

    if [[ "$gen" != "" ]]; then
        echo gen:"$gen"
        export source=$(eval "$gen")
    fi

    if [[ "$source" != "" ]]; then
        rargs=$(eval echo $args)


        echo $name $address $path, $prj $sign $rargs

        # echo "$source"

        export DAPP_JSON=$(mktemp)
        sed 's/\u0000/u001A/g' "out/dapp.sol.json" > "$DAPP_JSON"
        if [[ "$sign" != "" ]]; then
            $LIBEXEC_DIR/dapp-verify-contract-ex "$path" "$address" "$sign" $rargs || true
        else
            $LIBEXEC_DIR/dapp-verify-contract-ex "$path" "$address" || true
        fi
    fi

    popd > /dev/null
done
