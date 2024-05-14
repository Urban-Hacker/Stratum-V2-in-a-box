#!/bin/bash

enum ()
{
    # skip index ???
    shift
    AA=${@##*\{} # get string strip after { 
    AA=${AA%\}*} # get string strip before }
    AA=${AA//,/} # delete commaa  
    ((DEBUG)) && echo $AA
    local I=0
    for A in $AA ; do
        eval "$A=$I"
        ((I++))
    done
}

enum VERSION_TYPE { STABLE, DEV, DEV_DETACHED, NO_GIT };

VERBOSE=0
while getopts ":v" option; do
    case "${option}" in
        v)
            VERBOSE=1
            ;;
        *)
            echo "Usage: $0 [-v]"
            exit 1
            ;;
    esac
done

shift "$((OPTIND-1))"

LOGS=/dev/null
INSTALLATION_FOLDER="$HOME/stratum_v2"
GIT_FOLDER="$HOME/stratum_v2/Stratum-V2-in-a-box"
TMP_DIRECTORY=/tmp/stratum_v2
ARCHITECTURE=$(uname -m)
EMBEDDED_BITCOIN_NODE_ARCHIVE="$GIT_FOLDER/Bin/bitcoin-sv2-tp-0.1.2-x86_64-linux-gnu.tar.gz"

rm -fr $TMP_DIRECTORY 2>&1
mkdir $TMP_DIRECTORY 2>&1

GIT_URL=https://github.com/Urban-Hacker/Stratum-V2-in-a-box

#if command -v screen >/dev/null 2>&1; then
#    SESSION_COUNT=$(screen -ls | grep -c "\.shurikenpi.io")
#else
#    SESSION_COUNT=0
#fi