#!/bin/bash

TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;1m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}

[[ ! "$USER" == "root" ]] && {
	clear
	echo
	TIME y "警告：请使用root用户操作!~~"
	echo
	exit 1
}

apt -qq install sudo

sudo -E apt-get -qq remove -y docker docker-engine docker.io containerd runc
sudo -E apt-get -qq remove -y docker  
sudo -E apt-get -qq remove -y --auto-remove docker
sudo -E apt-get -qq remove -y docker-ce
sudo -E apt-get -qq remove -y docker-ce-cli
sudo -E apt-get -qq remove -y docker-ce-rootless-extras
sudo -E apt-get -qq remove -y docker-scan-plugin

sudo -E apt-get -qq update
sudo -E apt-get -qq install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
sudo -E apt-get -qq update
sudo -E apt-get -qq install -y docker-ce docker-ce-cli containerd.io


if [[ `dpkg -l | grep -c "docker"` -ge '1' ]]; then
	echo
	
	TIME g "docker安装成功"
	echo
else
	sudo -E apt-get -qq remove -y docker docker-engine docker.io containerd runc
	sudo -E apt-get -qq remove -y docker  
	sudo -E apt-get -qq remove -y --auto-remove docker
	sudo -E apt-get -qq remove -y docker-ce
	sudo -E apt-get -qq remove -y docker-ce-cli
	sudo -E apt-get -qq remove -y docker-ce-rootless-extras
	sudo -E apt-get -qq remove -y docker-scan-plugin
	echo
	TIME y "docker安装失败，请再次尝试!"
	echo
fi
exit 0
