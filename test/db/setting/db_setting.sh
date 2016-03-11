#!/bin/bash

source /root/.bash_profile

# selinux stop
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux

# iptables stop
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# mysql install
yum install -y mysql mysql-server
/etc/init.d/mysqld start
chkconfig mysqld on
/usr/bin/mysqladmin -u root password 'wordpress'
expect -c "
spawn mysql_secure_installation
expect \"(enter for none):\" ; send \"wordpress\n\"
expect \"Y/n\" ; send \"n\n\"
expect \"Y/n\" ; send \"y\n\"
expect \"Y/n\" ; send \"y\n\"
expect \"Y/n\" ; send \"y\n\"
expect \"Y/n\" ; send \"y\n\"
expect eof
exit
"
expect -c "
spawn mysql -u root -pwordpress
expect \"mysql>\" ; send \"create database wordpress;\n\"
expect \"mysql>\" ; send \"grant all on wordpress.* to 'wordpress'@'10.0.0.%' identified by 'wordpress';\n\"
expect \"mysql>\" ; send \"flush privileges;\n\"
expect \"mysql>\" ; send \"exit\n\"
expect eof
exit
"
