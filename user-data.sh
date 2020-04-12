#!/bin/bash
yum -y update
yum -y install httpd
myip=` curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script !" > /var/www/html/index.html
echo "<br><font color="blue">Hello World !" >> /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
yum -y install zabbix-agent
cd /etc/zabbix/
sed -i s/Server=127.0.0.1/Server=192.168.1.204/g zabbix_agentd.conf
systemctl enable zabbix-agent
systemctl start zabbix-agent
