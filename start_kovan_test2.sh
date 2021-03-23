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


# export VAT_FAB=0x689843d14b16036fdd2cc15c888bffd94667637f
# export JUG_FAB=0x022641e48d4e2c59fbcb97f628b89cb8292720c7
# export VOW_FAB=0x16379be9e7a1016c30e5bca2414011a7c2431827
# export CAT_FAB=0x45d90cd220981fd1dd2832e7dea2bac4292d3330
# export DAI_FAB=0xf295c7540cc3612b3c98cc3ddccc1de45ea6117b
# export MCD_JOIN_FAB=0x8089632b94889c37d942bc54f9fa7b20ec7a26aa
# export FLAP_FAB=0x1ee8cd6b6e2558ec8463ab3e031c013eba8bc86a
# export FLOP_FAB=0xb11f0a888960d9886f7db9123eaa295872983dfa
# export FLIP_FAB=0x73dec1d8Baa9D20759A6FB5B7427Ec8f6C5C6482
# export SPOT_FAB=0x72d1159a6dce08708912870bec0e53a6d72c7eab
# export POT_FAB=0xde0f4a5035617b89f3353da738877608f3e7cefa
# export END_FAB=0x822ff312356a03bce209ca03c051d3ad934db016
# export ESM_FAB=0x03d43c0287eab950cf92e652630c774005a6ff25
# export PAUSE_FAB=0x689843d14b16036fdd2cc15c888bffd94667637f

. "$LIB_DIR/common.sh"



. $LIBEXEC_DIR/dss/deploy-fab

MCD_DEPLOY=$(dappCreate dss-deploy-optimized DssDeploy "$VAT_FAB" "$JUG_FAB" "$VOW_FAB" "$CAT_FAB" "$DAI_FAB" "$MCD_JOIN_FAB" "$FLAP_FAB" "$FLOP_FAB" "$FLIP_FAB" "$SPOT_FAB" "$POT_FAB" "$END_FAB" "$ESM_FAB" "$PAUSE_FAB")
# export MCD_DEPLOY=0xaf72104b20eC1109fE97F4EAdA1cF040Fe25EBDd
log "MCD_DEPLOY=$MCD_DEPLOY"


MCD_GOV=$(dappCreate ds-token DSToken "$(seth --to-bytes32 "$(seth --from-ascii "FL")")")

# Deploy VAT
sethSend "$MCD_DEPLOY" "deployVat()"

# Deploy MCD
sethSend "$MCD_DEPLOY" "deployDai(uint256)" "$(seth rpc net_version)"

# Deploy Taxation
sethSend "$MCD_DEPLOY" "deployTaxation()"

# Deploy Auctions
sethSend "$MCD_DEPLOY" "deployAuctions(address)" "$MCD_GOV"

# Deploy Liquidation
sethSend "$MCD_DEPLOY" "deployLiquidator()"

export MCD_VAT=$(seth call "$MCD_DEPLOY" "vat()(address)")
log "MCD_VAT=$MCD_VAT"
export MCD_JUG=$(seth call "$MCD_DEPLOY" "jug()(address)")
log "MCD_JUG=$MCD_JUG"
export MCD_VOW=$(seth call "$MCD_DEPLOY" "vow()(address)")
log "MCD_VOW=$MCD_VOW"
export MCD_CAT=$(seth call "$MCD_DEPLOY" "cat()(address)")
log "MCD_CAT=$MCD_CAT"

sethSend "$FLIP_FAB" "setCat(address)" "$MCD_CAT"


# export MCD_JOIN_DAI=$(seth call "$MCD_DEPLOY" "daiJoin()(address)")
# log "MCD_JOIN_DAI=$MCD_JOIN_DAI"

# export MCD_FLAP=$(seth call "$MCD_DEPLOY" "flap()(address)")
# log "MCD_FLAP=$MCD_FLAP"

# export MCD_FLOP=$(seth call "$MCD_DEPLOY" "flop()(address)")
# log "MCD_FLOP=$MCD_FLOP"


# export MCD_SPOT=$(seth call "$MCD_DEPLOY" "spotter()(address)")
# log "MCD_SPOT=$MCD_SPOT"

# export MCD_POT=$(seth call "$MCD_DEPLOY" "pot()(address)")
# log "MCD_POT=$MCD_POT"

# export MCD_END=$(seth call "$MCD_DEPLOY" "end()(address)")
# log "MCD_END=$MCD_END"

# log "MCD_ESM=$MCD_ESM"
# export MCD_ESM=$(seth call "$MCD_DEPLOY" "esm()(address)")

# log "MCD_PAUSE=$MCD_PAUSE"
# export MCD_PAUSE=$(seth call "$MCD_DEPLOY" "pause()(address)")

# log "MCD_PAUSE_PROXY=$MCD_PAUSE_PROXY"
# export MCD_PAUSE_PROXY=$(seth call "$(seth call "$MCD_DEPLOY" "pause()(address)")" "proxy()(address)")

export MCD_DAI=$(seth call "$MCD_DEPLOY" "dai()(address)")
log "MCD_DAI=$MCD_DAI"

# verify USDFL freeliquid-ct $MCD_DAI
