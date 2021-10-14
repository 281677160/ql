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

if [[ "$USER" == "root" ]]; then
	clear
	echo
	echo
	echo
	TIME z "脚本适用于（ubuntu、debian、openwrt、centos）"
	TIME z "一键安装青龙，包括（docker、任务、依赖安装，一条龙服务），安装路径[opt]"
	TIME z "自动检测docker，有则跳过，无则安装，openwrt则请自行安装docker，如果空间太小请挂载好硬盘"
	TIME z "如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装"
	TIME z "如果您有需要备份的青龙文件，请先备份好文件再来安装，避免造成损失"
	TIME z "建议使用翻墙网络安装，要不然安装依赖的时候你会急死的"
	TIME g "如要不能接受的话，请选择 3 回车退出程序!"
	echo
	echo
	echo
	TIME y " 如要继续的话，请选择容器的网络类型!（输入 1、2或3 编码）"
	echo
	TIME l " 1. bridge [默认类型]"
	echo
	TIME l " 2. host [一般为openwrt旁路由才选择的]"
	echo
	TIME l " 3. 退出安装程序!"
	echo
	while :; do
	read -p " [输入您选择的编码]： " SCQL
	case $SCQL in
		1)
			QL_PORT="5700"
			QING_PORT="YES"
			NETWORK="-p ${QL_PORT}:5700"
		break
		;;
		2)
			NETWORK="--net host"
			QL_PORT="5700"
		break
		;;
		3)
			echo
			TIME r "您选择了退出程序!"
			rm -fr ql.sh
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
echo
[[ "${QING_PORT}" == "YES" ]] && {
	TIME g "请设置端口，默认为端口[5700]，不懂设置的话，直接回车跳过"
	read -p " 请输入端口：" QL_PORT
	QL_PORT=${QL_PORT:-"5700"}
	TIME y "您端口为：${QL_PORT}"
	NETWORK="-p ${QL_PORT}:5700"
}
echo
echo
rm -fr ql.sh
echo
if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
	TIME g "正在安装宿主机所需要的依赖，请稍后..."
	QL_PATH="/opt"
	yum -y update
	yum -y install sudo git
	yum -y install curl
	yum -y install net-tools.x86_64
elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
	TIME g "正在安装宿主机所需要的依赖，请稍后..."
	QL_PATH="/opt"
	apt-get -y update
	apt-get -y install sudo curl git
	apt-get -y install net-tools
elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
	TIME g "正在安装宿主机所需要的依赖，请稍后..."
	QL_PATH="/opt"
	apt -y update
	apt -y install sudo curl git
	apt -y install net-tools
elif [[ "$(. /etc/os-release && echo "$ID")" == "openwrt" ]]; then
	TIME g "正在安装宿主机所需要的依赖，请稍后..."
	QL_PATH="/opt"
	XTong="openwrt"
	opkg update
	opkg install git
	opkg install git-http
fi
IP="$(ifconfig -a|grep inet|grep -v 127|grep -v 172|grep -v inet6|awk '{print $2}'|tr -d "addr:")"
if [[ -z "${IP}" ]]; then
	IP="IP"
fi
if [[ "${XTong}" == "openwrt" ]]; then
	 if [[ -x "$(command -v docker)" ]]; then
	 	echo
	 else
		echo
		TIME r "没检测到docker，openwrt请自行安装docker，如果空间太小请挂载好硬盘"
		echo
		sleep 3
		exit 1
	fi
else
	if [[ `docker --version | grep -c "version"` -eq '0' ]]; then
		echo
		TIME y "没发现有docker，正在安装docker，请稍后..."
		echo
		wget -O docker.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/docker.sh && bash docker.sh
		if [[ $? -ne 0 ]];then
			curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/docker.sh > docker.sh && bash docker.sh
		fi
		
	fi
fi
if [[ "${XTong}" == "openwrt" ]]; then
	 if [[ -x "$(command -v docker)" ]]; then
	 	echo
	 else
		echo
		TIME r "没检测到docker，openwrt请自行安装docker，如果空间太小请挂载好硬盘"
		echo
		sleep 3
		exit 1
	fi
else
	if [[ `docker --version | grep -c "version"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，请先安装docker"
		echo
		sleep 3
		exit 1
	fi
fi
if [[ "$(. /etc/os-release && echo "$ID")" == "openwrt" ]]; then
	Overlay_Available="$(df -h | grep "/opt/docker" | awk '{print $4}' | awk 'NR==1' | sed 's/.$//g')"
		echo
		TIME z "您当前系统可用空间为${Overlay_Available}G"
		echo
	if [[ "${Overlay_Available}" < "2" ]];then
		echo
		TIME r "敬告：可用空间小于[ 2G ]，不支持安装青龙，请挂载好[opt]路径的硬盘"
		sleep 2
		exit 1
		echo
	fi
else
	Ubuntu_kj="$(df -h | grep "/dev/*/" | awk '{print $4}' | awk 'NR==1' | sed 's/.$//g')"
		echo
		TIME z "您当前系统可用空间为${Ubuntu_kj}G"
		echo
	if [[ "${Ubuntu_kj}" -lt "2" ]];then
		echo
		TIME r "敬告：可用空间小于[ 2G ]，不支持安装青龙，请加大磁盘空间"
		sleep 2
		exit 1
		echo
	fi
fi
if [[ `docker ps -a | grep -c "whyour"` -ge '1' ]]; then
	echo
	TIME y "检测到已有青龙面板，正在删除旧的青龙容器和镜像，请稍后..."
	echo
	docker=$(docker ps -a|grep whyour) && dockerid=$(awk '{print $(1)}' <<<${docker})
	images=$(docker images|grep whyour) && imagesid=$(awk '{print $(3)}' <<<${images})
	docker stop -t=5 "${dockerid}"
	docker rm "${dockerid}"
	docker rmi "${imagesid}"
fi
rm -rf /opt/ql
rm -rf /root/ql
if [ -z "$(ls -A "/opt" 2>/dev/null)" ]; then
	mkdir -p /opt
fi
echo
echo
TIME g "正在安装青龙面板，请稍后..."
echo
docker run -dit \
  -v $QL_PATH/ql/config:/ql/config \
  -v $QL_PATH/ql/log:/ql/log \
  -v $QL_PATH/ql/db:/ql/db \
  -v $QL_PATH/ql/scripts:/ql/scripts \
  -v $QL_PATH/ql/jbot:/ql/jbot \
  -v $QL_PATH/ql/raw:/ql/raw \
  -v $QL_PATH/ql/repo:/ql/repo \
  ${NETWORK} \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest

if [[ `docker ps -a | grep -c "whyour"` -ge '1' ]]; then
	docker restart qinglong
	sleep 13
	clear
	echo
	echo
	echo
	TIME z "青龙面板安装完成，下一步进入安装脚本程序"
	echo
	TIME y " "${IP}":"${QL_PORT}"  (IP检测因数太多，不一定准确，仅供参考)"
	echo
	TIME g "请使用 IP:端口 在浏览器登录控制面板，然后在环境变量里添加好WSKEY或者PT_KEY，再按Y进入下一步"
	echo
	TIME y "您也可以不添加WSKEY或者PT_KEY，但是一定要登录控制面板"
	echo
	TIME g "登录页面，点击[开始安装]，设置好[用户名]跟[密码],然后点击[提交]，[通知方式]跳过，以后再设置，然后点击[去登录]，输入帐号密码完成登录!"
	echo
	while :; do
	read -p " [ N/n ]退出程序，[ Y/y ]回车继续安装脚本： " MENU
	if [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` -ge '1' ]]; then
		S="Yy"
	else
		echo
		TIME r "提示：一定要登录管理面板之后再执行下一步操作,或者您输入[N/n]按回车退出!"
		echo
	fi
	case $MENU in
		[${S}])
			echo
			TIME y "开始安装脚本，请耐心等待..."
			echo
			docker exec -it qinglong bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"
			if [[ $? -ne 0 ]];then
				docker exec -it qinglong bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun.sh)"
			fi
			sleep 2
			exit 0
		break
		;;
		[Nn])
			echo
			TIME r "退出安装程序!"
			echo
			sleep 2
			exit 1
		break
    		;;
    		*)
			TIME r ""
		;;
	esac
	done
else
	echo
	echo
	TIME y "青龙面板安装失败！"
	echo
	sleep 2
	exit 1
fi
echo
echo
exit 0
