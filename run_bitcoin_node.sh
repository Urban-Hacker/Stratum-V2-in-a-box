#!/bin/bash
source ./Scripts/global.sh
source ./Scripts/utils.sh

command=$1
shift

start_node(){
    if [ $SESSION_BITCOIN_COUNT -eq 0 ]; then
        p "Starting up bitcoin deamon..."
        screen -d -m -c Configurations/screen.screenrc -S "stratum_bitcoin_node" Bin/bitcoin-sv2-tp-0.1.2/bin/bitcoind -sv2 -sv2port=8442 -prune=1092
        status_node
    elif [ $SESSION_BITCOIN_COUNT -eq 1 ]; then
        p "bitcoin deamon is already running"
    else
        echo "hello"
        status_node
    fi
}

status_node(){
    if [ $SESSION_BITCOIN_COUNT -eq 1 ]; then
        p_ok "bitcoin deamon is running"
    elif [ $SESSION_BITCOIN_COUNT -gt 1 ]; then
        p_warn "Only one instance of bitcoin deamon should be running"
        p_warn "bitcoin deamon might have been started multiple time."
        p_warn "Please force restart if this is the case."
    else
        p_err "bitcoin deamon is not running"
    fi
}

stop_node(){
    if [ $SESSION_BITCOIN_COUNT -eq 0 ]; then
        status_node
    elif [ $SESSION_BITCOIN_COUNT -eq 1 ]; then
        p "We will stop the bitcoin deamon..."
        screen -X -S stratum_bitcoin_node quit
        killall bitcoind
    else
        status_node
    fi
}

if [[ $command == "status" ]]; then
    status_node
elif [[ $command == "start" ]]; then
    start_node
elif [[ $command == "stop" ]]; then
    stop_node
else
    echo "  » Unknown command. Not sure what you are trying to do :("
    echo ""
    echo "    Built-in manual:"
    echo ""
    echo "    start         start the bitcoin deamon"
    echo "    stop          stop the bitcoin deamon"
    echo "    status        display the current status of the bitcoin deamon"
    echo ""
fi
