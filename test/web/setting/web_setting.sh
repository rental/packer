#!/bin/bash

source /root/.bash_profile

# yum update
yum update -y

# selinux stop
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux

# iptables stop
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# apache php mysql install
cd /tmp/setting
yum install -y httpd mysql php php-mysql expect
cp -p apache/wordpress.conf /etc/httpd/conf.d/

#wordpress install
mv apache/wordpress /var/www/
chown -R apache. /var/www/wordpress
/etc/init.d/httpd start
chkconfig httpd on
