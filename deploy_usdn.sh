export BIN_DIR='bin'
export LIB_DIR='lib'
export LIBEXEC_DIR='libexec'
export CONFIG_DIR='config'
export DAPP_LIB='contracts'
export DAPP_SKIP_BUILD='yes'
export ETH_FROM=0xaaCE3a65C179667f53B01fB3F28Db10a0dce9629
export ETH_GAS_PRICE=1000000000
export ETH_GAS=7000000
export ETH_PASSWORD=`pwd`/password
export ETH_KEYSTORE=`pwd`/keys/keystore
export SETH_CHAIN=kovan
export ETH_RPC_URL=https://kovan.infura.io/v3/6cf197c96ea54310860815644865edbe
export ETHERSCAN_API_KEY=ZVQWRYYTMWGCRBQFAGNFJJKN6HV7JG51Y9
cd ~/git/maker/freeliquid-ct
#dapp create USDN
export DAPP_JSON=/home/magum/git/maker/freeliquid-ct/out/dapp.sol.json
dapp verify-contract src/testHelpers.sol:USDN 0x5f99471D242d04C42a990A33e8233f5B48F89C43