#!/bin/bash

yum update -y
yum upgrade -y
yum install httpd -y

set -e

cat <<EOF >> /var/www/html/index.html
    <html><h1>Hello Testing Guy!</h1></html>
    EOF

yum autoremove -y
exit 0