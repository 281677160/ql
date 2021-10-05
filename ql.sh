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
	TIME y "警告：请勿root用户~~"
	echo
	exit 1
}

docker ps -a > dkql
if [[ `grep -c "whyour" dkql` -eq '0' ]]; then
  TIME g "正在安装青龙面板，请稍后..."
  docker run -dit \
    -v $PWD/ql/config:/ql/config \
    -v $PWD/ql/log:/ql/log \
    -v $PWD/ql/db:/ql/db \
    -v $PWD/ql/scripts:/ql/scripts \
    -v $PWD/ql/jbot:/ql/jbot \
    -v $PWD/ql/raw:/ql/raw \
    -v $PWD/ql/repo:/ql/repo \
    -p 5700:5700 \
    --name qinglong \
    --hostname qinglong \
    --restart always \
    whyour/qinglong:latest
else
	rm -fr dkql
fi

sleep 3
if [ -z "$(ls -A "dkql" 2>/dev/null)" ]; then
	TIME g "已经有青龙面板，请登录面板设置好KEY，建议删除现有青龙面板，重新安装，本脚本不支持混装!"
	read -p " [输入[ N/n ]退出安装，设置好KEY，输入[ Y/y ]回车继续]： " QLNU
	case $QLNU in
		[Yy])
			docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"
		;;
		[Nn])
			sleep 2
			TIME r "退出安装程序!"
		;;
	esac
else
	rm -fr dkql
	TIME g "青龙面板安装完成，请过1分钟左右试用您宿主机 IP:5700 登录面板设置好KEY，重要，一定要登录过！！！"
	read -p " [输入[ N/n ]退出安装，设置好KEY，输入[ Y/y ]回车继续]： " MENU
	case $MENU in
		[Yy])
			docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"
			TIME y "开始安装脚本，请耐心等待..."
		;;
		[Nn])
			sleep 2
			TIME r "退出安装程序!"
		;;
	esac
	esac
fi
exit 0
