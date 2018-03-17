#!/usr/bin/env bash

# This is an installer script for MagicMirror2. It works well enough
# that it can detect if you have Node installed, run a binary script
# and then download and run MagicMirror2.

echo -e "\e[0m"
echo '$$\      $$\                     $$\           $$\      $$\ $$\                                          $$$$$$\'
echo '$$$\    $$$ |                    \__|          $$$\    $$$ |\__|                                        $$  __$$\'
echo '$$$$\  $$$$ | $$$$$$\   $$$$$$\  $$\  $$$$$$$\ $$$$\  $$$$ |$$\  $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\  \__/  $$ |'
echo '$$\$$\$$ $$ | \____$$\ $$  __$$\ $$ |$$  _____|$$\$$\$$ $$ |$$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\  $$$$$$  |'
echo '$$ \$$$  $$ | $$$$$$$ |$$ /  $$ |$$ |$$ /      $$ \$$$  $$ |$$ |$$ |  \__|$$ |  \__|$$ /  $$ |$$ |  \__|$$  ____/'
echo '$$ |\$  /$$ |$$  __$$ |$$ |  $$ |$$ |$$ |      $$ |\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |$$ |      $$ |'
echo '$$ | \_/ $$ |\$$$$$$$ |\$$$$$$$ |$$ |\$$$$$$$\ $$ | \_/ $$ |$$ |$$ |      $$ |      \$$$$$$  |$$ |      $$$$$$$$\'
echo '\__|     \__| \_______| \____$$ |\__| \_______|\__|     \__|\__|\__|      \__|       \______/ \__|      \________|'
echo '                       $$\   $$ |'
echo '                       \$$$$$$  |'
echo '                        \______/'
echo -e "\e[0m"

# Define the tested version of Node.js.
NODE_TESTED="v5.1.0"

# Determine which Pi is running.
ARM=$(uname -m) 

# Check the Raspberry Pi version.
if [ "$ARM" != "armv7l" ]; then
	echo -e "\e[91mSorry, your Raspberry Pi is not supported."
	echo -e "\e[91mPlease run WARP on a Raspberry Pi 2 or 3."
	echo -e "\e[91mIf this is a Pi Zero, you are in the same boat as the original Raspberry Pi. You must run in server only mode."
	exit;
fi

# Define helper methods.
function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
function command_exists () { type "$1" &> /dev/null ;}

# Update before first apt-get
echo -e "\e[96mUpdating packages ...\e[90m"
sudo apt-get update || echo -e "\e[91mUpdate failed, carrying on installation ...\e[90m"

# Installing helper tools
echo -e "\e[96mInstalling helper tools ...\e[90m"
sudo apt-get install curl wget git build-essential unzip || exit

# Check if we need to install or upgrade Node.js.
echo -e "\e[96mCheck current installation ...\e[0m"	
	echo -e "\e[96mInstalling needed packages ...\e[90m"

	
sudo apt-get install -y libncurses5-dev libncursesw5-dev
sudo apt-get install -y  libcurl4-gnutls-dev
sudo apt-get install -y libjson0 libjson0-dev libjson-c-dev
sudo apt-get install -y libbluetooth-dev
sudo apt-get -y cmake
sudo apt-get install -y git-core build-essential libssl-dev libncurses5-dev unzip gawk zlib1g-dev
sudo apt-get install -y subversion mercurial
sudo apt-get install -y build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext libssl-dev unzip

	echo -e "\e[92m installation Done!\e[0m"


# Install WARP
cd ~
if [ -d "$HOME/WARP" ] ; then
	echo -e "\e[93mIt seems like WARP is already installed."
	echo -e "To prevent overwriting, the installer will be aborted."
	echo -e "Please rename the \e[1m~/WARP\e[0m\e[93m folder and try again.\e[0m"
	echo ""
	echo -e "If you want to upgrade your installation run \e[1m\e[97mgit pull\e[0m from the ~/WARP directory."
	echo ""
	exit;
fi
mkdir ~/WARP
cd ~/WARP
echo -e "\e[96mCloning WARP ...\e[90m"
if git clone -b WIP_PLATFORM https://github.com/SubhajeetRoy/JYL.git; then 
	echo -e "\e[92mCloning WARP Done!\e[0m"
else
	echo -e "\e[91mUnable to clone WARP."
	exit;
fi

cd ~/WARP/JYL/  || exit
echo -e "\e[96mInstalling  ...\e[90m"
if .prepare warp 8; then 
	echo -e "\e[92mDependencies installation Done!\e[0m"
else
	echo -e "\e[91mUnable to install dependencies!"
	exit;
fi
cd WIP
cmake CMakeList.txt
make

sudo ./wipinstall_rpi


echo -e "\e[92mWe're ready! Run "

