date
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
export ETH_RPC_URL=127.0.0.1:7545
#seth ls
bin/dss-deploy kovan
date