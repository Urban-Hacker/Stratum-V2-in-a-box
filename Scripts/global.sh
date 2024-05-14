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
EMBEDDED_BITCOIN_NODE_ARCHIVE=bitcoin-sv2-tp-0.1.2-x86_64-linux-gnu.tar.gz
EMBEDDED_SV2_PROXY=demand_all_in_one_sv2-x86_64-linux-gnu.tar.gz
EMBEDDED_SSL_LIB="libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb"

UI_CHECK="\033[32m✓\033[0m"

rm -fr $TMP_DIRECTORY 2>&1
mkdir $TMP_DIRECTORY 2>&1

GIT_URL=https://github.com/Urban-Hacker/Stratum-V2-in-a-box

if command -v screen >/dev/null 2>&1; then
    SESSION_BITCOIN_COUNT=$(screen -ls | grep -c "\.stratum_bitcoin_node")
else
    SESSION_BITCOIN_COUNT=0
fi

if command -v screen >/dev/null 2>&1; then
    SESSION_PROXY_COUNT=$(screen -ls | grep -c "\.stratum_proxy_node")
else
    SESSION_PROXY_COUNT=0
fi