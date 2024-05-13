#!/bin/bash

SCRIPT_DIRECTORY="stratum_in_a_box"

echo "STRATUM V2 [in a box]"
echo "----"
echo "This will install everything required to run a stratum V2 node"
echo "This assume you have the following requirement"
echo "* This computer is using an Intel / AMD 64 bits CPU"
echo "* This computer is running Ubuntu or one of the derivative (Xubuntu, etc)"
echo "* You must have at least 50 GB of free space on your SSD"
echo ""

cd ~
HOME_DIRECTORY=`pwd`
echo "Installation directory will be: $HOME_DIRECTORY/$SCRIPT_DIRECTORY"
mkdir stratum_in_a_box
cd stratum_in_a_box

wget 