#!/bin/bash
# File generated automatically by build.sh. Do not modify
# DO NOT MODIFY

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

rm -fr $TMP_DIRECTORY 2>&1
mkdir $TMP_DIRECTORY 2>&1

GIT_URL=https://github.com/Urban-Hacker/Stratum-V2-in-a-box

#if command -v screen >/dev/null 2>&1; then
#    SESSION_COUNT=$(screen -ls | grep -c "\.shurikenpi.io")
#else
#    SESSION_COUNT=0
#fi


#!/bin/bash

r(){
    p $1
    while read -t 0; do :; done
    read -p "  › " $2
}

p() {
    echo -e "  » $1"
    sleep 0.1
}

p_user() {
    echo -e "  \e[35m› $1\033[0m"
    sleep 0.1
}

p_err(){
    echo -e "  \033[31m»\033[0m $1"
    sleep 0.1
}

p_fatal(){
    echo -e "  \033[31m» $1\033[0m"
    sleep 0.1
}

p_ok(){
    echo -e "  \033[32m»\033[0m $1"
    sleep 0.1
}

p_warn(){
    echo -e "  \033[33m!\033[0m $1"
    sleep 0.1
}

msg() {
    echo ""
    sleep 0.1
    while IFS= read -r line
    do
        echo -e "$line"
        sleep 0.1
    done < "../Messages/$1"
    echo "$line"
    sleep 0.1
    echo ""
    sleep 0.1
}

ask_yes_or_no(){
    echo -e "  \033[33m?\033[0m $1"
    local result=$(gum choose --cursor=  ›   Yes No)
    if [[ $result == "Yes" ]]; then
        p_user "Yes"
        return 0
    fi
    p_user "No"
    return 1
}

user_pause(){
    local result=$(gum choose --cursor=" › " "Continue")
    p_user "Continue"
}

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



check_if_root(){
    echo ""
    p "Root user check..."

    if [[ $EUID -ne 0 ]]; then
        echo ""
        echo -e "    Stratum V2 [in a box] called with non-root priviledeges \033[31m:(\033[0m"
        echo -e "    Elevated priviledeges are required to install and run Stratum V2 [in a box]"
        echo -e "    Please check the installer for any concerns about this requirement"
        echo -e "    Make sure you downloaded this script from a trusted source"
        echo ""
        if sudo true; then
            p "Correct password."
        else
            p_err "Wrong password. Exiting."
            exit 1
        fi
    fi
    p_ok "We are root :)"
}

install_prerequisites(){
    p "Installing pre-requisites..."
    spin_it "Update cache..." sudo apt update
    spin_it "apt install curl                                                          \033[32m✓\033[0m" sudo apt-get install -y curl
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null

    spin_it "Refresh cache..." sudo apt update
    spin_it "apt install gum                                                           \033[32m✓\033[0m" sudo apt-get install -y gum
    spin_it "apt install git                                                           \033[32m✓\033[0m" sudo apt-get install -y git
    spin_it "apt install tor                                                           \033[32m✓\033[0m" sudo apt-get install -y tor
    spin_it "apt install curl                                                          \033[32m✓\033[0m" sudo apt-get install -y curl
    spin_it "apt install screen                                                        \033[32m✓\033[0m" sudo apt-get install -y screen
}


# Entry point
echo ""
p "Installing Stratum V2 [in a box]!"
check_if_root
if [[ "$ARCHITECTURE" == "aarch64" ]]; then
    p_err "You are trying to install on incompatible hardware."
    p_fatal "Please install it on X86 Intel or AMD architecture."
fi
p_ok "Your device is using $ARCHITECTURE"

install_prerequisites