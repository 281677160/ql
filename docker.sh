#!/usr/bin/env bash

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

if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
	export Aptget="yum"
	export XITONG="cent_os"
	TIME g "centos"
elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
	Aptget="apt-get"
	export XITONG="ubuntu_os"
	export TIME g "ubuntu"
elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
	export Aptget="apt"
	export XITONG="debian_os"
	TIME g "debian"
else
	echo
	TIME y "本一键安装docker脚本只支持（centos、ubuntu和debian）!"
	echo
	exit 1
fi

if [[ `docker --version | grep -c "version"` -ge '1' ]]; then
	echo
	TIME y "检测到docker存在，是否重新安装?"
	echo
	TIME g "重新安装会把您现有的所有容器及镜像全部删除，请慎重!"
	echo
	while :; do
	read -p " [输入[ N/n ]退出安装，输入[ Y/y ]回车继续]： " ANDK
	case $ANDK in
		[Yy])
			TIME g "正在御载老版本docker"
			export CHONGXIN_anzhuang="YES"
			docker stop $(docker ps -a -q)
			docker rm $(docker ps -a -q)
			docker rmi $(docker images -q)
			sudo "${Aptget}" remove -y docker docker-engine docker.io containerd runc
			sudo "${Aptget}" remove -y docker
			sudo "${Aptget}" remove -y docker-ce
			sudo "${Aptget}" remove -y docker-ce-cli
			sudo "${Aptget}" remove -y docker-ce-rootless-extras
			sudo "${Aptget}" remove -y docker-scan-plugin
			sudo "${Aptget}" remove -y --auto-remove docker
			sudo rm -rf /var/lib/docker
			sudo rm -rf /etc/docker
			sudo rm -rf /lib/systemd/system/{docker.service,docker.socket}
			rm /var/lib/dpkg/info/$nomdupaquet* -f
		break
		;;
		[Nn])
			echo
			TIME r "您选择了退出程序!"
			echo
			sleep 3
			exit 1
		break
    		;;
    		*)
			echo
			TIME b "提示：请输入正确的选择!"
			echo
		;;
	esac
	done
fi
echo
TIME y "正在安装docker，请耐心等候..."
"${Aptget}" -y update
"${Aptget}" install -y sudo curl
echo
if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
	TIME y "centos正在安装docker，请耐心等候..."
	sudo yum install -y yum-utils device-mapper-persistent-data lvm2
	sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	sudo yum -y update
	sudo yum install -y docker-ce
	sudo yum install -y docker-ce-cli
	sudo yum install -y containerd.io
	sudo yum install -y docker.io
fi
if [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
	TIME y "ubuntu正在安装docker，请耐心等候..."
	sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
	curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	if [[ $? -ne 0 ]];then
		curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	fi
	sudo apt-key fingerprint 0EBFCD88
	if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
		TIME r "密匙验证出错，或者没下载到密匙了，请检查网络，或者源有问题"
		sleep 5
		exit 1
		sleep 5
	fi
	sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo apt-get install -y docker-ce-cli
	sudo apt-get install -y containerd.io
	sudo apt-get install -y docker.io
if [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
	sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
	curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
	if [[ $? -ne 0 ]];then
		curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
	fi
	sudo apt-key fingerprint 0EBFCD88
	if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
		TIME r "密匙验证出错，或者没下载到密匙了，请检查网络，或者上游有问题"
		sleep 5
		exit 1
		sleep 5
	fi
	sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo apt-get install -y docker-ce-cli
	sudo apt-get install -y containerd.io
	sudo apt-get install -y docker.io
fi
exit 0
