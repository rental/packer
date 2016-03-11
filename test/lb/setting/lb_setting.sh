#!/bin/bash

source /root/.bash_profile

# selinux stop
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# iptables stop
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# nginx install
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum install -y nginx
yum groupinstall -y "Development Tools"
cd /etc/nginx/conf.d
mv default.conf{,.org}
mv example_ssl.conf{,.org}
mv /tmp/setting/vhost.conf /etc/nginx/conf.d/vhost.conf
chown root:root /etc/nginx/conf.d/vhost.conf
/etc/init.d/nginx start
chkconfig nginx on
