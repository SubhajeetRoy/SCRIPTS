#!/usr/bin/env bash

# This is an installer script for Maverick on Linux. 
echo "--------------------------Maverick INSTALL START-------------------------------------------"


# Determine which Pi is running.
LINUX_VERSION=$(uname -m) 
# Check the Linux version.

echo -e "\e[91m INTALLING Maverick on ." $LINUX_VERSION $HOME


# Update before first apt-get
echo -e "\e[96mUpdating packages ...\e[90m"
sudo apt-get update || echo -e "\e[91mUpdate failed, carrying on installation ...\e[90m"

# Installing helper tools
echo -e "\e[96mInstalling helper tools ...\e[90m"
sudo apt-get install curl wget git build-essential unzip || exit


	
sudo apt-get install -y libncurses5-dev libncursesw5-dev
sudo apt-get install -y  libcurl4-gnutls-dev
sudo apt-get install -y libjson0 libjson0-dev libjson-c-dev
sudo apt-get install -y libbluetooth-dev
sudo apt-get install -y cmake
sudo apt-get install -y git-core build-essential libssl-dev libncurses5-dev unzip gawk zlib1g-dev
sudo apt-get install -y subversion mercurial
sudo apt-get install -y build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext libssl-dev unzip

echo -e "\e[92m installation Done!\e[0m"


# Install Maverick
#cd ~
if [ -d "$PWD/Maverick" ] ; then
	echo -e "\e[93mIt seems like Maverick  is already installed."
	echo -e "To prevent overwriting, the installer will be aborted."
	echo -e "Please rename the \e[1m ./Maverick \e[0m\e[93m folder and try again.\e[0m"
	echo ""
	echo -e "If you want to upgrade your installation run \e[1m\e[97mgit pull\e[0m from the ./Maverick directory."
	echo ""
	exit;
fi

mkdir $PWD/Maverick
cd $PWD/Maverick
echo -e "\e[96mCloning Maverick ...\e[90m"
if git clone  https://github.com/SubhajeetRoy/Mav_Platform.git; then #
	echo -e "\e[92mCloning Maverick Done!\e[0m"
else
	echo -e "\e[91mUnable to clone Maverick."
	exit;
fi

cd  ./Mav_Platform/  || exit
echo PATH= $PWD
echo -e "\e[96mInstalling  ...\e[90m"
if ./prepare Maverick 8; then 
	echo -e "\e[92mDependencies installation Done!\e[0m"
else
	echo -e "\e[91mUnable to install dependencies!"
	exit;
fi

cd  ./Maverick  || exit
echo PATH=$PWD
cmake CMakeLists.txt
make
cd ..
echo PATH=$PWD
sudo ./warpinstall_ubuntu


echo -e "\e[92mWe're ready! Run "


