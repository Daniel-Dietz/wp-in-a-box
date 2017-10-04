#!/bin/bash

# Variables - you may set the following in envrc file
# ICE_USER

echo "Setting up emergency user..."

source /root/.envrc

if [ "$ICE_USER" == "" ]; then
    # create SSH username automatically
    ICE_USER="ice_$(pwgen -A 8 1)"
    echo "export ICE_USER=$ICE_USER" >> /root/.envrc
fi

#--- please do not edit below this file ---#

SSHD_CONFIG='/etc/ssh/sshd_config'

if [ ! -d "/home/${ICE_USER}" ]; then
    useradd -m $ICE_USER

    echo "${ICE_USER} ALL=(ALL) NOPASSWD:ALL"> /etc/sudoers.d/$ICE_USER
    chmod 400 /etc/sudoers.d/$ICE_USER

    ICE_PASS=$(pwgen -cns 12 1)

    echo "$ICE_USER:$ICE_PASS" | chpasswd
else
    echo "Note: The default directory /home/${ICE_USER} already exists!"
    echo "Note: The user '${ICE_USER}' already exists"
fi

echo "Done setting up the emergency user!"
