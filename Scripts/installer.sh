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