#!/bin/bash

echo 'Installing MySQL / MariaDB Server'
# lets check if mariadb-server exists
SQL_SERVER=mariadb-server
if ! apt-cache show mariadb-server &> /dev/null ; then SQL_SERVER=mysql-server ; fi

DEBIAN_FRONTEND=noninteractive apt install ${SQL_SERVER} -y


