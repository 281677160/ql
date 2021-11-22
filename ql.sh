
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
	echo
	echo
	echo
	TIME z "脚本适用于（ubuntu、debian、centos、openwrt）"
	TIME z "一键安装青龙，包括（docker、任务、依赖安装，一条龙服务），安装路径[opt]"
	TIME z "自动检测docker，有则跳过，无则安装，openwrt则请自行安装docker，如果空间太小请挂载好硬盘"
	TIME z "如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装"
	TIME z "如果您以前青龙文件在root/ql或者/opt/ql，如果您的[帐号密码文件]和[环境变量文件]符合要求，就会继续使用"
	TIME g "如要不能接受的话，请选择 3 回车退出程序!"
	echo
	echo
	echo
	TIME y " 如要继续的话，请选择容器的网络类型!（输入 1、2或3 编码）"
