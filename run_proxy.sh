#!/bin/bash
source ./Scripts/global.sh
source ./Scripts/utils.sh

if [ $SESSION_BITCOIN_COUNT -eq 0 ]; then
    p_err "Bitcoin deamon must run in order to start the proxy"
    p_fatal "run ./run_bitcoin_node.sh start to launch it"
fi

./Bin/demand_all_in_one_sv2-x86_64-linux-gnu -a $1