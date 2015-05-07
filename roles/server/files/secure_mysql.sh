#! /usr/bin/env bash

if [ -n "${1}" -a -z "${2}" ]; then
	# Setup root password
	CURRENT_MYSQL_PASSWORD=''
	NEW_MYSQL_PASSWORD="${1}"
elif [ -n "${1}" -a -n "${2}" ]; then
	# Change existens root password
	CURRENT_MYSQL_PASSWORD="${1}"
	NEW_MYSQL_PASSWORD="${2}"
else
	exit 1
fi
 
SECURE_MYSQL=$(expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$CURRENT_MYSQL_PASSWORD\r\"
expect \"root password?\"
send \"y\r\"
expect \"New password:\"
send \"$NEW_MYSQL_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$NEW_MYSQL_PASSWORD\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
 
echo "${SECURE_MYSQL}"
