#!/bin/bash

yum update -y
yum upgrade -y
yum install httpd -y
chkconfig httpd on

cat <<EOF >> /var/www/html/index.html
<html><h1>Hello Testing Guy!</h1></html>
EOF

yum autoremove -y
service httpd start
chkconfig httpd on
exit 0