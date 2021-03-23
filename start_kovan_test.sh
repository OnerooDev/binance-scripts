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


$LIBEXEC_DIR/dss/deploy-fab
