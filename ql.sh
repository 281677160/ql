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
	TIME z "脚本适用于（ubuntu、debian、openwrt）"
	TIME z "自动检测docker，有则跳过，无则执行安装，如果是openwrt则请自行安装 docker"
	TIME z "如果您以前安装有青龙的话，则自动删除您的青龙，全部推倒重新安装"
	TIME z "如果您有要备份的青龙文件，请先备份再来安装，免得损失"
	TIME z "如果有条件的话，最好使用翻墙网络来安装，要不然安装依赖的时候你会急死的"
	TIME g "如要不能接受的话，请选择 3 回车退出程序!"
	echo
	echo
	echo
	TIME y "如要继续的话，请选择容器的网络类型!"
	echo
	TIME l " 1. bridge [默认类型] "
	echo
	TIME l " 2. host [一般为openwrt旁路由器才选择的]"
	echo
	TIME l " 3. 退出安装程序!"
	echo
	while :; do
	read -p " [输入您的选择编码]： " SCQL
	case $SCQL in
		1)
			QL_PORT="5700"
			NETWORK="p $QL_PORT:5700"
		break
		;;
		2)
			NETWORK="-net host"
		break
		;;
		3)
			TIME r "您选择了退出编译程序"
			exit 0
		break
    		;;
    		*)
			TIME b "提示：请输入正确的选择!"
		;;
	esac
	done
fi
echo
echo
[[ "${QL_PORT}" == "5700" ]] && {
	TIME g "请设置端口，默认为5700，不设置的话直接回车"
	read -p " 请输入端口：" QL_PORT
	QL_PORT=${QL_PORT:-"5700"}
	TIME y "您端口为：$QL_PORT"
	NETWORK="-p $QL_PORT:5700"
}
echo
echo
TIME g "正在安装宿主机所需要的依赖，请稍后..."
echo
if [[ -z "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
	apt update
	apt install -y sudo curl dpkg wget
fi

if [[ -n "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
	if [[ `docker --version | grep -c "version"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，请先安装docker"
		echo
		sleep 3
		exit 1
	fi
else
	if [[ `docker --version | grep -c "version"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，正在安装docker，请稍后..."
		echo
		wget -O docker.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/docker.sh && bash docker.sh
		if [[ $? -ne 0 ]];then
			curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/docker.sh && bash docker.sh
		fi
		
	fi
fi
if [[ -n "$(ls -A "/etc/openwrt_release" 2>/dev/null)" ]]; then
	if [[ `docker --version | grep -c "version"` -eq '0' ]]; then
		echo
		TIME y "没检测到docker，请先安装docker"
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
if [[ `docker ps | grep -c "whyour"` -ge '1' ]]; then
	echo
	TIME g "检测到已有青龙面板，需要删除面板才能继续..."
	echo
	TIME y "正在删除旧的青龙容器和镜像，请稍后..."
	echo
	docker=$(docker ps|grep whyour) && dockerid=$(awk '{print $(1)}' <<<${docker})
	images=$(docker images|grep whyour) && imagesid=$(awk '{print $(3)}' <<<${images})
	docker stop -t=5 "${dockerid}"
	docker rm "${dockerid}"
	docker rmi "${imagesid}"
fi
rm -rf /opt/ql
rm -rf /root/ql
echo
echo
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
  -${NETWORK} \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest

if [[ `docker ps -a | grep -c "whyour"` -ge '1' ]]; then
	docker restart qinglong
	sleep 13
	echo
	TIME z "青龙面板安装完成"
	echo
	TIME g "请使用 IP:$QL_PORT 在浏览器登录控制面板，然后在环境变量里添加好WSKEY或者PT_KEY"
	echo
	TIME y "您也可以不添加WSKEY或者PT_KEY，但是一定要登录管理面"
	echo
	TIME r "重要提示：重要，一定要登录管理面板之后再执行下一步操作！！！"
	echo
	TIME y "输入 N 回车退出程序，或者进入过管理页面后输入 Y 回车继续安装脚本"
	echo
	while :; do
	read -p " [ N/n ]退出程序，[ Y/y ]回车继续安装脚本： " MENU
	if [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` -ge '1' ]]; then
		S="Yy"
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
			rm -fr ql.sh
		break
		;;
		[Nn])
			TIME r "退出安装程序!"
			sleep 2
			exit 1
		break
    		;;
    		*)
			TIME r "重要提示：一定要登录管理面板之后再执行下一步操作,或者您按[N/n]退出!"
		;;
	esac
	done
else
	TIME y "青龙面板安装失败！"
	sleep 2
	exit 1
fi
echo
echo
if [[ `docker ps | grep -c "whyour"` -ge '1' ]]; then
	TIME l "安装依赖，依赖必须安装，要不然脚本不运行"
	echo
	TIME y "但是用国内的网络安装比较慢，请尽量使用翻墙网络"
	echo
	TIME g "没翻墙条件的话，安装依赖太慢就换时间安装，我测试过不同时段有不同效果"
	echo
	TIME y "依赖安装时看到显示ERR!错误提示不用管，只要依赖能从头到尾的下载运行完毕就好了"
	echo
	TIME g "如果安装太慢，而想换时间安装的话，按键盘的 Ctrl+C 退出就行了，到时候可以使用我的一键独立安装依赖脚本来安装"
	echo
	sleep 15
	docker exec -it qinglong bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/npm.sh)"
	if [[ $? -ne 0 ]];then
		docker exec -it qinglong bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/npm.sh)"
	fi
fi

exit 0
