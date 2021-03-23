#!/usr/bin/env bash

PORTAL_PATH=../mcd-cdp-portal

cp out/addresses.json $PORTAL_PATH/src/references/contracts/testnet.json
cp out/addresses.json $PORTAL_PATH/src/libs/dai/contracts/addresses/testnet.json
cp out/addresses.json $PORTAL_PATH/src/libs/dai-plugin-mcd/contracts/addresses/testnet.json
