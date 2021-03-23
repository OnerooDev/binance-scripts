export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=$(seth rpc eth_coinbase)
export ETH_PASSWORD=/dev/null
export ETH_KEYSTORE=~/.dapp/testnet/8545/keystore
bin/dss-deploy testchain
