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
	exit 1
}

if [[ `docker version | grep -c "version"` = '0' ]]; then
	echo
	TIME y "没检测到docker，请先安装docker"
	echo
	exit 1
fi

if [[ `docker ps -a | grep -c "whyour"` -ge '1' ]]; then
	TIME g "检测到已有青龙面板，正在删除中，请稍后..."
	echo
	docker=$(docker ps|grep whyour) && dockerid=$(awk '{print $(1)}' <<<${docker})
	images=$(docker images|grep whyour) && imagesid=$(awk '{print $(3)}' <<<${images})
	docker stop -t=5 $dockerid
	docker rm $dockerid
	docker rmi $imagesid
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
	echo
	TIME g "青龙面板安装完成，请等1分钟左右使用 IP:5700 登录面板设置好KEY，重要，一定要登录页面过！！！"
	read -p " [输入[ N/n ]退出安装，设置好KEY，输入[ Y/y ]回车继续安装脚本]： " MENU
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
