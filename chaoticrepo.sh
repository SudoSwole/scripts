#!/bin/bash
#set -e

#  Script to Add Chaotic Repo
#  pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
#  pacman-key --lsign-key FBA220DFC880C036
#  pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
# Append (adding to the end of the file) to /etc/pacman.conf:
# [chaotic-aur]
# Include = /etc/pacman.d/chaotic-mirrorlist
# To run it, type  ./chaoticrepo.sh 

# WRITTEN BY SudoSwole

#HERE WE SET OUR REPO VARIABLES FOR THE SCRIPT

#Repo Key Variable
REPOKEY='FBA220DFC880C036'

#Key Server
KEYSERVER='keyserver.ubuntu.com'

#Mirrorlist
MIRRORLIST='https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

#Check if the key is already installed
KEYCHECK=$(sudo pacman-key --list-keys)

#Add Repo to pacman conf file
APPEND='
[chaotic-aur]
\nInclude = /etc/pacman.d/chaotic-mirrorlist'

function print_status() {
    tput setaf 4
    echo
    echo $1
    echo
    tput sgr0    
}

if grep -q "$REPOKEY" <<< "$KEYCHECK" ; then

    print_status ">>... The Repo Key Already Exists!! Exiting Script."

else 

    print_status ">>... Receiving the key $REPOKEY ...."

sudo pacman-key --recv-key $REPOKEY  --keyserver $KEYSERVER 

sleep 1

    print_status ">>... Signing the key $REPOKEY ...."

sudo pacman-key --lsign-key $REPOKEY 

sleep 1

    print_status ">>.. Downloading Mirrorlist $MIRRORLIST ...."

sudo pacman -U --noconfirm --needed $MIRRORLIST ;

    print_status ">>.. Adding Repo to pacman.conf"

sleep 5
    echo -e $APPEND | sudo tee --append /etc/pacman.conf

sleep 1
 
    print_status ">>.. Repo Successfully Added"

fi
