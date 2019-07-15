#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo 'Installing MySQL / MariaDB Server'
# lets check if mariadb-server exists
sql_server=mariadb-server
if ! apt-cache show mariadb-server &> /dev/null ; then sql_server=mysql-server ; fi

apt-get install ${sql_server} -qq &> /dev/null

systemctl stop mysql
# enable slow log and other tweaks
cp $local_wp_in_a_box_repo/config/mariadb.conf.d/*.cnf /etc/mysql/mariadb.conf.d/
systemctl start mysql

source /root/.envrc

echo 'Setting up MySQL user...'

if [ "$MYSQL_ADMIN_USER" == "" ]; then
    # create MYSQL username automatically
    MYSQL_ADMIN_USER="sqladmin_$(pwgen -A 8 1)"
    MYSQL_ADMIN_PASS=$(pwgen -cnsv 20 1)
    echo "export MYSQL_ADMIN_USER=$MYSQL_ADMIN_USER" >> /root/.envrc
    echo "export MYSQL_ADMIN_PASS=$MYSQL_ADMIN_PASS" >> /root/.envrc
    mysql -e "CREATE USER ${MYSQL_ADMIN_USER}@localhost IDENTIFIED BY '${MYSQL_ADMIN_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO ${MYSQL_ADMIN_USER}@localhost WITH GRANT OPTION"
fi
echo ... done setting up MySQL user.

echo 'Setting up Database for WP ...'
WP_SQL_USER="wp_dbuser_$(pwgen -A 8 1)"
WP_SQL_PASS=$(pwgen -cnsv 20 1)
echo "export Wordpress_Database_USER=$WP_SQL_USER" >> /root/.envrc
echo "export Wordpress_Database_PASS=$WP_SQL_PASS" >> /root/.envrc

mysql -e "CREATE DATABASE wordpress;"
echo ... done creating Wordpress Database.

mysql -e "CREATE USER ${WP_SQL_USER}@localhost IDENTIFIED BY '${WP_SQL_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO ${WP_SQL_USER}@localhost"

echo ... done setting up MySQL user.


mysql -e "FLUSH PRIVILEGES;"


echo ... done installing MySQL / MariaDB server!
