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
if [[ `lsb_release -a | grep -c "buntu"` -ge '1' ]]; then
	export Ubuntu="ubuntu"
elif [[ `lsb_release -a | grep -c "ebian"` -ge '1' ]]; then
	export Debian="debian"
fi
if [[ -z "${Ubuntu}" ]] && [[ -z "${Debian}" ]]; then
	echo
	TIME r "本脚本只适用于Ubuntu和Debian安装docker"
	echo
	exit 1
fi
apt install -y sudo curl wget
if [[ `docker --version | grep -c "version"` -ge '1' ]]; then
	echo
	TIME y "检测到docker存在，是否重新安装?"
	echo
	TIME g "重新安装会把您现有的所以容器及镜像全部删除"
	echo
	while :; do
	read -p " [输入[ N/n ]退出安装，输入[ Y/y ]回车继续]： " ANDK
	case $ANDK in
		[Yy])
			TIME g "正在御载老版本docker"
			docker stop $(docker ps -a -q)
			docker rm $(docker ps -a -q)
			docker rmi $(docker images -q)
			sudo -E apt-get -qq remove -y docker docker-engine docker.io containerd runc
			sudo -E apt-get -qq remove -y docker
			sudo -E apt-get -qq remove -y docker-ce
			sudo -E apt-get -qq remove -y docker-ce-cli
			sudo -E apt-get -qq remove -y docker-ce-rootless-extras
			sudo -E apt-get -qq remove -y docker-scan-plugin
			sudo -E apt-get -qq remove -y --auto-remove docker
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
echo
sudo -E apt-get -qq update
sudo -E apt-get -qq install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
if [[ "${Ubuntu}" == "ubuntu" ]]; then
	curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	if [[ $? -ne 0 ]];then
		curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	fi
else
	curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
	if [[ $? -ne 0 ]];then
		curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
	fi
fi
sudo apt-key fingerprint 0EBFCD88
if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
	TIME r "密匙验证出错"
	sleep 2
	exit 1
fi
if [[ "${Ubuntu}" == "ubuntu" ]]; then
	sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
else
	sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
fi
sudo -E apt-get -qq update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io |tee build.log
if [[ `grep -c "dockerd -H fd://" build.log` -ge '1' ]]; then
	TIME g "检测到文件有错误，尝试修复"
	sudo rm -fr /etc/systemd/system/docker.service.d
	sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
	sudo systemctl daemon-reload
fi
sudo rm -fr build.log
sudo rm -fr docker.sh
if [[ `docker --version | grep -c "version"` = '0' ]]; then
	TIME y "docker安装失败"
	sleep 2
	exit 1
else
	TIME y ""
	TIME g "docker安装成功，正在重启docker，请稍后..."
	sudo systemctl restart docker
	sleep 12
	TIME y ""
	TIME g "测试docker拉取镜像是否成功"
	TIME y ""
	sudo docker run hello-world |tee build.log
	if [[ `docker ps -a | grep -c "hello-world"` -ge '1' ]] && [[ `grep -c "docs.docker" build.log` -ge '1' ]]; then
		echo
		TIME g "测试镜像拉取成功，正在删除测试镜像..."
		echo
		docker stop $(docker ps -a -q)
		docker rm $(docker ps -a -q)
		docker rmi $(docker images -q)
		echo
		TIME y "测试镜像删除完毕，docker安装成功!"
		echo
	else
		echo
		TIME y "docker安装成功虽然安装成功但是拉取镜像失败，这个原因很多是因为以前的docker没御载完全造成的，或者容器网络问题"
		echo
		TIME y "重启服务器后，用 sudo docker run hello-world 命令测试吧，能拉取成功就成了"
		echo
		sleep 2
		exit 1
	fi
fi
exit 0
