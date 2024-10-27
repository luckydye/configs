#!/usr/bin/env bash

# install enrry for windows

set CONFIGS_DIR=~/configs

function explain() {
    echo ""
    echo "#######################################################"
    echo ""
    echo "Installation complete. Open a new Terminal."
    echo ""
    echo "To sync config to the latest commit run: sync"
    echo ""
    echo "#######################################################"
    echo ""
}

git clone https://github.com/luckydye/configs.git ${CONFIGS_DIR} || exit 1

# install task
scoop install task

task -t $CONFIGS_DIR/setup.yml || exit 1

explain
