#!/bin/bash

apt -qq install sudo
sudo -E apt-get -qq update
sudo -E apt-get -qq install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
sudo -E apt-get -qq update
sudo -E apt-get -qq install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
if [[ `grep -c "hello-world:latest"` -eq '1' ]]; then
	echo "docker安装成功"
else
	sudo -E apt-get -qq remove docker docker-engine docker.io containerd runc
	sudo -E apt-get -qq remove docker  
	sudo -E apt-get -qq remove --auto-remove docker
	sudo -E apt-get -qq remove docker-ce
	sudo -E apt-get -qq remove docker-ce-cli
	sudo -E apt-get -qq remove docker-ce-rootless-extras
	sudo -E apt-get -qq remove docker-scan-plugin
	echo "docker安装失败，请再次尝试!"
fi
exit 0
