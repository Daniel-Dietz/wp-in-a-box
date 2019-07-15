#!/bin/bash

# post-install script for Debian

printf '%-72s' "Installing Certbot..."
apt-get -qq install certbot &> /dev/null
echo done.



mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/default_from_conf_d_folder.conf



#--- Download and setup some helper tools ---#
if [ ! -s /root/ps_mem.py ]; then
    printf '%-72s' "Downloading ps_mem.py script..."
    script_url=http://www.pixelbeat.org/scripts/ps_mem.py
    wget -q -O /root/ps_mem.py $script_url
    check_result $? 'ps_mem.py: error downloading the script.'
    chmod +x /root/ps_mem.py
    echo done.
fi

if [ ! -s /root/scripts/mysqltuner.pl ]; then
    printf '%-72s' "Downloading mysqlturner script..."
    script_url=https://raw.github.com/major/MySQltuner-perl/master/mysqltuner.pl
    wget -q -O /root/scripts/mysqltuner.pl $script_url
    check_result $? 'mysqltuner: error downloading the script.'
    chmod +x /root/scripts/mysqltuner.pl
    echo done.
fi

if [ ! -s /root/scripts/tuning-primer.sh ]; then
    printf '%-72s' "Downloading tuning-primer script..."
    script_url=https://launchpad.net/mysql-tuning-primer/trunk/1.6-r1/+download/tuning-primer.sh
    wget -q -O /root/scripts/tuning-primer.sh $script_url
    check_result $? 'tuning-primer: error downloading the script.'
    chmod +x /root/scripts/tuning-primer.sh
    sed -i 's/\bjoin_buffer\b/&_size/' /root/scripts/tuning-primer.sh
    echo done.
fi



