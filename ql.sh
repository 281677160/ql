#!/usr/bin/env bash
# 
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
	sleep 2
	exit 1
}

if [[ -z "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
	sudo -E apt -qq install -y sudo
	sudo -E apt -qq install -y dpkg
fi

if [[ -n "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
	if [[ `opkg list | grep -c "docker"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，请先安装docker"
		echo
		sleep 2
		exit 1
	fi
else
	if [[ `dpkg -l | grep -c "docker1"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，正在安装docker，请稍后..."
		echo
		wget -O docker.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/docker.sh && bash docker.sh
	fi
fi
if [[ -n "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
	if [[ `opkg list | grep -c "docker"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，请先安装docker"
		echo
		sleep 2
		exit 1
	fi
else
	if [[ `dpkg -l | grep -c "docker"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，请先安装docker"
		echo
		sleep 2
		exit 1
	fi
fi
if [[ `docker ps -a | grep -c "whyour"` -ge '1' ]]; then
	echo
	TIME g "检测到已有青龙面板，需要删除面板才能继续..."
	echo
	TIME y "如果要继续的话，请注意备份你的配置文件!"
	echo
	read -p " [输入[ N/n ]退出安装，输入[ Y/y ]回车继续]： " SCQL
	case $SCQL in
		[Yy])
			docker=$(docker ps|grep whyour) && dockerid=$(awk '{print $(1)}' <<<${docker})
			images=$(docker images|grep whyour) && imagesid=$(awk '{print $(3)}' <<<${images})
			docker stop -t=5 "$dockerid"
			docker rm "$dockerid"
			docker rmi "$imagesid"
		;;
		[Nn])
			TIME r "退出安装程序!"
			sleep 2
			exit 1
		;;
	esac
fi

rm -rf /opt/ql
rm -rf /root/ql
sleep 3
echo

if [[ -n "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
TIME g "正在安装青龙面板，请稍后..."
echo
docker run -dit \
  -v $PWD/ql/config:/ql/config \
  -v $PWD/ql/log:/ql/log \
  -v $PWD/ql/db:/ql/db \
  -v $PWD/ql/scripts:/ql/scripts \
  -v $PWD/ql/jbot:/ql/jbot \
  -v $PWD/ql/raw:/ql/raw \
  -v $PWD/ql/repo:/ql/repo \
  --net host \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest
else
TIME g "正在安装青龙面板，请稍后..."
echo
docker run -dit \
   -v /opt/ql/config:/ql/config \
   -v /opt/ql/log:/ql/log \
   -v /opt/ql/db:/ql/db \
   -v /opt/ql/scripts:/ql/scripts \
   -v /opt/ql/jbot:/ql/jbot \
   -v /opt/ql/raw:/ql/raw \
   -v /opt/ql/repo:/ql/repo \
   -p 5700:5700 \
   --name qinglong \
   --hostname qinglong \
   --restart always \
   whyour/qinglong:latest
fi

sleep 3
if [[ `docker ps -a | grep -c "whyour"` -ge '1' ]]; then
	docker restart qinglong
	sleep 10
	echo
	TIME z "青龙面板安装完成"
	echo
	TIME g "请等1-2分钟左右,然后使用 IP:5700 登录面板，然后在环境变量里添加好WSKEY或者PT_KEY"
	echo
	TIME y "重要提示：重要，不设置WSKEY或者PT_KEY都行，但是一定要登录管理面板之后再执行下一步操作！！！"
	echo
	TIME g "输入 N 回车退出程序，或者进入过管理页面后输入 Y 回车继续安装脚本"
	echo
	read -p " [输入[ N/n ]退出程序，登录管理面板之后，输入[ Y/y ]回车继续安装脚本]： " MENU
	case $MENU in
		[Yy])
			echo
			TIME y "开始安装脚本，请耐心等待..."
			echo
			docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"
			rm -fr ql.sh
			exit 0
		;;
		[Nn])
			TIME r "退出安装程序!"
			sleep 2
			exit 1
		;;
	esac
else
	TIME y "青龙面板安装失败，请检测网络再来尝试！"
	sleep 2
	exit 1
fi
exit 0
