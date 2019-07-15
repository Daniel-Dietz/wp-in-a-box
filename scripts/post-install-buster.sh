#!/bin/bash

# post-install script for Debian

printf '%-72s' "Installing Certbot..."
apt-get -qq install certbot &> /dev/null
echo done.
