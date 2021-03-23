#!/usr/bin/env bash

PORTAL_PATH=../mcd-cdp-portal

cp out/addresses.json $PORTAL_PATH/src/references/contracts/rinkeby.json
cp out/addresses.json $PORTAL_PATH/src/libs/dai/contracts/addresses/rinkeby.json
cp out/addresses.json $PORTAL_PATH/src/libs/dai-plugin-mcd/contracts/addresses/rinkeby.json
