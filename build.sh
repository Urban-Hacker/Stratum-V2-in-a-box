#!/bin/bash

build_installer(){
    # Header
    INSTALLER="./install.sh"
    echo "#!/bin/bash" > $INSTALLER
    echo "# File generated automatically by build.sh. Do not modify" >> $INSTALLER
    echo "# DO NOT MODIFY" >> $INSTALLER
    echo "" >> $INSTALLER

    cat Scripts/global.sh >> $INSTALLER
    echo -e "\n\n" >> $INSTALLER
    cat Scripts/utils.sh >> $INSTALLER
    echo -e "\n\n" >> $INSTALLER
    cat Scripts/installer.sh >> $INSTALLER
    chmod +x $INSTALLER
}

#echo -e "Script to build Stratum V2 in a box!"
build_installer
#echo "Finished"