#!/bin/bash

source /root/.bash_profile

# yum update
yum update -y

# selinux stop
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# iptables stop
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# apache php mysql install
cd /tmp/setting
yum install -y httpd httpd-devel mysql php php-mysql expect
yum groupinstall -y "Development Tools"
cp -p apache/wordpress.conf /etc/httpd/conf.d/
cd /tmp/setting/apache/mod_rpaf
/usr/sbin/apxs -i -c -n mod_rpaf-2.0.so mod_rpaf-2.0.c
cp -p mod_rpaf.conf /etc/httpd/conf.d
chkconfig httpd on
