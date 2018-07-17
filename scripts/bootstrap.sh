#!/usr/bin/env bash

apt-get update -y
apt-get upgrade -y
apt-get -y install awscli
sudo apt-get remove -y docker docker-engine docker.io
sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update -y
sudo apt-get install -y docker-ce
sudo usermod -aG docker ${USER}
sudo usermod -aG docker vagrant
sudo systemctl restart docker
sudo systemctl enable docker

# https://askubuntu.com/questions/792832/how-to-install-virtualbox-guest-additions-for-ubuntu-16-04
#export DEBIAN_FRONTEND=noninteractive
#apt-get -o Dpkg::Options::="--force-confnew" install -y install build-essential module-assistant linux-headers-$(uname -r)
