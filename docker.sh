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
	echo
	TIME y "警告：请使用root用户操作!~~"
	echo
	exit 1
}
if [[ `lsb_release -a | grep -c "buntu"` -ge '1' ]]; then
	export Ubuntu="ubuntu"
fi
if [[ `lsb_release -a | grep -c "ebian"` -ge '1' ]]; then
	export Debian="debian"
fi
if [[ -z "${Ubuntu}" ]] && [[ -z "${Debian}" ]]; then
	echo
	TIME r "本脚本只适用于Ubuntu和Debian安装docker"
	echo
	exit 1
fi
if [[ `dpkg -l | grep -c "docker"` -ge '1' ]]; then
	echo
	TIME y "检测到docker存在，是否重新安装?"
	echo
	TIME g "重新安装会把您现有的所以容器及镜像全部删除"
	echo
	read -p " [输入[ N/n ]退出安装，输入[ Y/y ]回车继续]： " ANDK
	case $ANDK in
		[Yy])
			apt -qq install -y sudo
			docker stop $(docker ps -a -q)
			docker rm $(docker ps -a -q)
			docker rmi $(docker images -q)
			sudo -E apt-get -qq remove -y docker docker-engine docker.io containerd runc
			sudo -E apt-get -qq autoremove
			sudo -E apt-get -qq remove -y docker  
			sudo -E apt-get -qq remove -y --auto-remove docker
			sudo -E apt-get -qq remove -y docker-ce
			sudo -E apt-get -qq remove -y docker-ce-cli
			sudo -E apt-get -qq remove -y docker-ce-rootless-extras
			sudo -E apt-get -qq remove -y docker-scan-plugin
			sudo -E apt-get -qq purge -y docker-ce
			sudo rm -rf /var/lib/docker
			sudo rm -rf /etc/docker
			cd /var/lib/dpkg
			sudo mv info info.baksudo
			sudo rm -fr info
			sudo mkdir info
			cd ../../../
			sudo apt-get clean

			sudo -E apt-get -qq update
			sudo -E apt-get -qq upgrade
			sudo -E apt-get -qq full-upfrade
			sudo -E apt-get -qq install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
			if [[ "${Ubuntu}" == "ubuntu" ]]; then
				curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
			else
				curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
			fi
			sudo apt-key fingerprint 0EBFCD88
			if [[ "${Ubuntu}" == "ubuntu" ]]; then
				sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
			else
				sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
			fi
			sudo -E apt-get -qq update
			sudo -E apt-get -qq install -y docker-ce
			sudo -E apt-get -qq install -y docker-ce-cli
			sudo -E apt-get -qq install -y containerd.io
		;;
		[Nn])
			TIME r "退出安装程序!"
			sleep 2
			exit 1
		;;
	esac
fi
rm -fr docker.sh
if [[ `dpkg -l | grep -c "docker"` -ge '1' ]]; then
	echo
	sudo service docker start
	sleep 10
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
	sudo -E apt-get -qq purge -y docker-ce
	sudo rm -rf /var/lib/docker
	rm /var/lib/dpkg/info/$nomdupaquet* -f
	echo
	TIME y "docker安装失败，请再次尝试!"
	echo
	sleep 2
	exit 1
fi
TIME g "检测docker拉取镜像是否成功"
sudo docker run hello-world
if [[ `docker ps -a | grep -c "hello-world"` -ge '1' ]]; then
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)
	echo
	TIME g "docker拉取镜像成功"
	echo
else
	echo
	TIME y "docker拉取镜像失败，或许是docker安装有问题，请重新安装试试"
	echo
fi
exit 0
