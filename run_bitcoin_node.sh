#!/bin/bash
source ./Scripts/global.sh
source ./Scripts/utils.sh

if [ $SESSION_BITCOIN_COUNT -eq 0 ]; then
    p "Starting up stratum bitcoin node..."
    screen -d -m -c Configurations/screen.screenrc -S "stratum_bitcoin_node" Bin/bitcoin-sv2-tp-0.1.2/bin/bitcoind -sv2 -sv2port=8442 -prune=1092
    #./status.sh
elif [ $SESSION_BITCOIN_COUNT -eq 1 ]; then
    p "bitcoin node is already running"
else
    echo "hello"
    #./status.sh
fi
