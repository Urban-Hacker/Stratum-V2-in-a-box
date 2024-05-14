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
    spin_it "apt install gum                                                           $UI_CHECK" sudo apt-get install -y gum
    spin_it "apt install git                                                           $UI_CHECK" sudo apt-get install -y git
    spin_it "apt install tor                                                           $UI_CHECK" sudo apt-get install -y tor
    spin_it "apt install curl                                                          $UI_CHECK" sudo apt-get install -y curl
    spin_it "apt install screen                                                        $UI_CHECK" sudo apt-get install -y screen
}

check_if_upgrade(){

    UPGRADABLE_COUNT=$(apt list --upgradable 2>$LOGS| grep -c ^)
    if (( UPGRADABLE_COUNT > 0 )); then
        p_warn "There are $UPGRADABLE_COUNT packages that can be upgraded."
        p_warn "It is recommended to run 'sudo apt upgrade' afterwards."
    else
        p "All packages are up to date."
    fi
}

go_to_install_directory(){
    echo ""
    p "Install directory will be: $INSTALLATION_FOLDER"
    if [ -d $INSTALLATION_FOLDER ]; then
        echo ""
        p_warn "An existing installation was detected!"
        p_warn "Would you like to re-install Stratum V2 [in a box]?"
        ask_yes_or_no "This will wipe the existing installation!"
        local result=$?
        if [ $result == 0 ]; then
            rm -fr $INSTALLATION_FOLDER
        else
            p_err "Fatal: Aborting the installation script now"
            exit 1
        fi
    fi
    mkdir $INSTALLATION_FOLDER
    cd $INSTALLATION_FOLDER
}

clone_repository(){
    spin_it "Downloading Stratum V2 [in a box], please wait...                         $UI_CHECK" git clone $GIT_URL
}

extract_embedded_bitcoin_node(){
    cd $GIT_FOLDER/Bin
    spin_it "Extract embedded bitcoin node                                             $UI_CHECK" tar -xf $EMBEDDED_BITCOIN_NODE_ARCHIVE
    spin_it "Extract embedded SV2 proxy                                                $UI_CHECK" tar -xf $EMBEDDED_SV2_PROXY
}

install_lib_ssl_for_compatibility(){
    cd $GIT_FOLDER/Bin
    spin_it "Install SSL library                                                       $UI_CHECK" sudo dpkg -i $EMBEDDED_SSL_LIB
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
check_if_upgrade
go_to_install_directory
clone_repository
extract_embedded_bitcoin_node
install_lib_ssl_for_compatibility
echo ""
p_ok "Installation finished!"