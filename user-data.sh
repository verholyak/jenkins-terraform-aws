#!/bin/bash
yum -y update
yum -y install httpd
myip=` curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script !" > /var/www/html/index.html
echo "<br><font color="blue">Hello World !" >> /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/6/x86_64/zabbix-release-4.0-2.el6.noarch.rpm
yum -y install zabbix zabbix-agent
cd /etc/zabbix/
sed -i s/Server=127.0.0.1/Server=192.168.1.204/g zabbix_agentd.conf
iptables -A INPUT -p tcp -s 192.168.1.204 --dport 10050 -m state --state NEW,ESTABLISHED -j ACCEPT
service zabbix-agent start
chkconfig zabbix-agent on
