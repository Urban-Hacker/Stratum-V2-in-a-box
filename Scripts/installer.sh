#!/bin/bash

SCRIPT_DIRECTORY="stratum_in_a_box"
ARCHITECTURE=$(uname -m)

echo "STRATUM V2 [in a box]"
echo "----"
echo "This will install everything required to run a stratum V2 node"
echo "This assume you have the following requirement"
echo "* This computer is using an Intel / AMD 64 bits CPU"
echo "* This computer is running Ubuntu or one of the derivative (Xubuntu, etc)"
echo "* You must have at least 50 GB of free space on your SSD"
echo ""


spin_it(){
    local msg=$1
    shift
    local command=$@
    local hash=$(echo -n "$command" | md5sum | awk '{print $1}')
    local logfile="$TMP_DIRECTORY/$hash.txt"
    "$@" > $logfile 2>&1 &
    chars=("  ⠋ " "  ⠙ " "  ⠹ " "  ⠸ " "  ⠼ " "  ⠴ " "  ⠦ " "  ⠧ " "  ⠇ " "  ⠏ ")
    pid=$!
    while kill -0 $pid 2> /dev/null; do
        for char in "${chars[@]}"; do
            echo -ne "\r$char"
            sleep 0.1
        done
    done
    wait $pid
    local exit_status=$?
    echo -ne "\r\033[K"
    if [ $exit_status -eq 0 ]; then
        p $msg
    else
        p_fatal "$msg [FATAL ERROR]"
        p_fatal "--- BEGIN ERROR DUMP ---"
        awk '{print "  \033[31m  " $0 "\033[0m"}' $logfile
        p_fatal "--- END ERROR DUMP ---"
        exit 1
    fi
    if [ $VERBOSE -eq 1 ]; then
        awk '{print "  ‣ " $0}' $logfile
        echo ""
    fi
}

spin_it "Update cache..." sudo apt update

#cd ~
#HOME_DIRECTORY=`pwd`
#echo "Installation directory will be: $HOME_DIRECTORY/$SCRIPT_DIRECTORY"
#mkdir stratum_in_a_box
#cd stratum_in_a_box

#wget 