#!/bin/bash

# post-install script for Debian

printf '%-72s' "Installing Certbot..."
apt-get -qq install certbot &> /dev/null
echo done.



 mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/default_from_conf_d_folder.conf
