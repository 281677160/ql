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

rm -fr dkql
sleep 3
   
TIME g "青龙面板安装完成，请过2分钟左右试用您宿主机 IP:5700 登录面板设置好KEY"
read -p " [设置好KEY后，输入[ Y/y ]回车继续]： " MENU
case $MENU in
	[Yy])
		docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"
	;;
esac
exit 0
