#!/usr/bin/env bash

#====================================================
# Author：281677160
# Dscription：qinglong onekey Management
# github：https://github.com/281677160/danshui
#====================================================

# 字体颜色配置
Green="\033[32;1m"
Red="\033[31;1m"
Yellow="\033[33;1m"
Blue="\033[36;1m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
ERROR="${Red}[ERROR]${Font}"

function print_ok() {
  echo
  echo -e " ${OK} ${Blue} $1 ${Font}"
  echo
}
function print_error() {
  echo
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
  echo
}
function ECHOY() {
  echo
  echo -e "${Yellow} $1 ${Font}"
  echo
}
function ECHOB() {
  echo
  echo -e "${Blue} $1 ${Font}"
}
function ECHOG() {
  echo
  echo -e "${Green} $1 ${Font}"
  echo
}
function ECHOR() {
  echo
  echo -e "${Red} $1 ${Font}"
  echo
}
function ECHOYY() {
  echo -e "${Yellow} $1 ${Font}"
}
function ECHOGG() {
  echo -e "${Green} $1 ${Font}"
}
function ECHORR() {
  echo -e "${Red} $1 ${Font}"
}
judge() {
  if [[ 0 -eq $? ]]; then
    echo
    print_ok "$1 完成"
    echo
    sleep 1
  else
    echo
    print_error "$1 失败"
    echo
    exit 1
  fi
}

if [[ ! "$USER" == "root" ]]; then
  print_error "警告：请使用root用户操作!~~"
  exit 1
fi

export Current="$PWD"

function qinglong_port() {
  clear
  echo
  ECHOY " 请选择网络类型"
  ECHOB " 1. bridge [默认类型]"
  ECHOB " 2. host [一般为openwrt旁路由才选择的]"
  echo
  scqlbianma="输入您选择的编码"
  while :; do
  domainy=""
  read -p " ${scqlbianma}： " SCQL
  case $SCQL in
  1)
    export QING_PORT="YES"
  break
  ;;
  2)
    export QING_PORT="NO"
  break
  ;;
  *)
    scqlbianma="请输入正确的编码"
  ;;
  esac
  done
  export YUMING="请输入您当前服务器的IP[比如：192.168.2.99]"
  echo
  echo
  while :; do
  read -p " ${YUMING}：" IP
  if [[ -n "${IP}" ]] && [[ "$(echo ${IP} |grep -c '.*\..*\..*\..*')" == '1' ]]; then
    domainy="Y"
  fi
  case $domainy in
  Y)
    export IP="${IP}"
  break
  ;;
  *)
    export YUMING="敬告：请输入正确的IP"
  ;;
  esac
  done
  echo
  if [[ "${QING_PORT}" == "YES" ]]; then
    read -p " 请输入您想设置的青龙面板端口(直接回车默认：5700): " QL_PORT && printf "\n"
    export QL_PORT=${QL_PORT:-"5700"}
    export NETLEIXING="bridge"
    export NETWORK="-p ${QL_PORT}:5700"
    export YPORT="青龙面口为"
  elif [[ "${QING_PORT}" == "NO" ]]; then
    export QL_PORT="5700"
    export YPORT="host模式默认青龙端口为"
    export NETWORK="--net host"
    export NETLEIXING="host"
  fi
  if [[ "${Api_Client}" == "true" ]]; then
     read -p " nvjdc面板名称，可中文可英文(直接回车默认：NolanJDCloud): " NVJDCNAME && printf "\n"
     export NVJDCNAME=${NVJDCNAME:-"NolanJDCloud"}
     read -p " 请输入您想设置的nvjdc面板端口(直接回车默认：5701): " JDC_PORT && printf "\n"
     export JDC_PORT=${JDC_PORT:-"5701"}
     read -p " 请输入通过nvjdc面板验证最大挂机数(直接回车默认：99): " CAPACITY && printf "\n"
     export CAPACITY=${CAPACITY:-"99"}
     echo -e "\033[32m pushplus网址：http://www.pushplus.plus \033[0m"
     read -p " 输入pushplus的TOKEN，有人通过nvjdc面板进入挂机或删除KEY时通知您(直接回车默认不通知): " PUSHPLUS && printf "\n"
     export PUSHPLUS=${PUSHPLUS:-""}
     export QLurl="http://${IP}:${QL_PORT}"
     if [[ -z ${PUSHPLUS} ]]; then
       PUSHP="不开启通知"
     else
       PUSHP="${PUSHPLUS}"
     fi
  fi
  ECHOGG "网络类型：${NETLEIXING}"
  ECHOGG "您的IP为：${IP}"
  ECHOGG "${YPORT}：${QL_PORT}"
  ECHOGG "您的青龙登录地址将为：http://${IP}:${QL_PORT}"
  if [[ "${Api_Client}" == "true" ]]; then
    echo
    ECHOYY "nvjdc面板名称为：${NVJDCNAME}"
    ECHOYY "nvjdc面板端口为：${JDC_PORT}"
    ECHOYY "通过nvjdc面板验证最大挂机数为：${CAPACITY}"
    ECHOYY "pushplus的TOKEN为：${PUSHP}"
    ECHOYY "您的nvjdc登录地址将为：http://${IP}:${JDC_PORT}"
  fi
  echo
  read -p " 检查是否正确,正确则按回车继续,不正确输入[Q/q]回车重新输入： " NNRT
  case $NNRT in
  [Qq])
    qinglong_port "$@"
  ;;
  *)
    print_ok "您已确认无误!"
  ;;
  esac
}

function system_check() {
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
    ECHOG "正在安装宿主机所需要的依赖，请稍后..."
    export QL_PATH="/opt"
    yum -y install sudo wget git unzip net-tools.x86_64 subversion
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
    ECHOG "正在安装宿主机所需要的依赖，请稍后..."
    export QL_PATH="/opt"
    apt-get -y update
    apt-get -y install sudo wget git unzip net-tools subversion
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
    ECHOG "正在安装宿主机所需要的依赖，请稍后..."
    export QL_PATH="/opt"
    apt -y update
    apt -y install sudo wget git unzip net-tools subversion
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    ECHOG "正在安装宿主机所需要的依赖，请稍后..."
    export QL_PATH="/opt"
    apk update
    apk add sudo wget git unzip net-tools subversion
  elif [[ -f /etc/openwrt_release ]] && [[ -f /rom/etc/openwrt_release ]]; then
    ECHOG "正在安装宿主机所需要的依赖，请稍后..."
    opkg update
    opkg install git-http > /dev/null 2>&1
    opkg install ca-bundle > /dev/null 2>&1
    opkg install coreutils-timeout > /dev/null 2>&1
    opkg install findutils-xargs > /dev/null 2>&1
    opkg install unzip
    XTong="openwrt"
    if [[ -d /opt/docker ]]; then
      export QL_PATH="/opt"
      export QL_Kongjian="/opt/docker"
    elif [[ -d /mnt/mmcblk2p4/docker ]]; then
      export QL_PATH="/root"
      export QL_Kongjian="/mnt/mmcblk2p4/docker"
    else
      print_error "没找到/opt/docker或者/mnt/mmcblk2p4/docker"
      exit 1
    fi
  else
    print_error "不支持您的系统"
    exit 1
  fi
}

function kaiqiroot_ssh() {
  if [[ ! -f /etc/openwrt_release ]] && [[ ! -f /rom/etc/openwrt_release ]]; then
    echo
    ECHOGG "开启root用户ssh，方便使用工具连接服务器直接修改文件代码"
    bash -c "$(curl -fsSL ${curlurl}/ssh.sh)"
    judge "开启root用户ssh"
    sleep 3
  fi
}

function nolanjdc_lj() {
  export Home="$QL_PATH/nolanjdc"
  export Config="$Home/Config"
  export Chromium="$Home/.local-chromium/Linux-884014"
}

function system_docker() {
  if [[ "${XTong}" == "openwrt" ]]; then
    if [[ ! -x "$(command -v docker)" ]]; then
      print_error "没检测到docker，openwrt请自行安装docker，和挂载好硬盘"
      sleep 1
      exit 1
    fi
  else
    if [[ ! -x "$(command -v docker)" ]]; then
      ECHOR "没检测到docker，正在安装docker"
      bash -c "$(curl -fsSL ${curlurl}/docker.sh)"
    fi
  fi
}

function systemctl_status() {
  echo
  if [[ "${XTong}" == "openwrt" ]]; then
    /etc/init.d/dockerman start > /dev/null 2>&1
    /etc/init.d/dockerd start > /dev/null 2>&1
    sleep 3
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    service docker start > /dev/null 2>&1
    sleep 1
    if [[ `docker version |grep -c "runc"` == '1' ]]; then
      print_ok "docker正在运行中!"
    else
      print_error "docker没有启动，请先启动docker，或者检查一下是否安装失败"
      sleep 1
      exit 1
    fi
  else
    systemctl start docker > /dev/null 2>&1
    sleep 1
    echo
    ECHOGG "检测docker是否在运行"
    if [[ `systemctl status docker |grep -c "active (running) "` == '1' ]]; then
      print_ok "docker正在运行中!"
    else
      print_error "docker没有启动，请先启动docker，或者检查一下是否安装失败"
      sleep 1
      exit 1
    fi
  fi
}

function uninstall_qinglong() {
  if [[ `docker images | grep -c "qinglong"` -ge '1' ]] || [[ `docker ps -a | grep -c "qinglong"` -ge '1' ]]; then
    ECHOY "检测到青龙面板，正在御载青龙面板，请稍后..."
    docker=$(docker ps -a|grep qinglong) && dockerid=$(awk '{print $(1)}' <<<${docker})
    images=$(docker images|grep qinglong) && imagesid=$(awk '{print $(3)}' <<<${images})
    docker stop -t=5 "${dockerid}" > /dev/null 2>&1
    docker rm "${dockerid}"
    docker rmi "${imagesid}"
    if [[ `docker ps -a | grep -c "qinglong"` == '0' ]]; then
      print_ok "青龙面板御载完成"
      rm -rf /etc/bianliang.sh > /dev/null 2>&1
    else
      print_error "青龙面板御载失败"
      exit 1
    fi
  fi

  if [[ ! -d "$QL_PATH/qlbeifen1" ]]; then
    if [[ -d "$QL_PATH/ql/config" ]]; then
      ECHOY "检测到 $QL_PATH 有 ql 文件夹,正在把 $QL_PATH/ql 移动到 $QL_PATH/qlbeifen 文件夹"
      ECHOY "如有需要备份文件的请到 $QL_PATH/qlbeifen 文件夹查看"
      rm -fr $QL_PATH/qlbeifen && mkdir -p $QL_PATH/qlbeifen
      cp -r $QL_PATH/ql $QL_PATH/qlbeifen/ql > /dev/null 2>&1
      cp -r $QL_PATH/qlbeifen $QL_PATH/qlbeifen1 > /dev/null 2>&1
      rm -rf $QL_PATH/ql > /dev/null 2>&1
      sleep 1
    fi
  else
      rm -rf $QL_PATH/ql > /dev/null 2>&1
  fi
}

function sys_kongjian() {
  if [[ -f /etc/openwrt_release ]] && [[ -f /rom/etc/openwrt_release ]]; then
    Available="$(df -h | grep "${QL_Kongjian}" | awk '{print $4}' | awk 'NR==1')"
    FINAL=`echo ${Available: -1}`
    if [[ "${FINAL}" =~ (M|K) ]]; then
      print_error "敬告：可用空间小于[ ${Sys_kj}G ]，不支持安装青龙${Ql_nvjdc}，请挂载大点磁盘空间容量"
      exit 1
    fi
      Overlay_Available="$(df -h | grep "${QL_Kongjian}" | awk '{print $4}' | awk 'NR==1' | sed 's/.$//g')"
      Kongjian="$(awk -v num1=${Overlay_Available} -v num2=${Sys_kj} 'BEGIN{print(num1>num2)?"0":"1"}')"
      ECHOY "您当前系统可用空间为${Overlay_Available}G"
    if [[ "${Kongjian}" == "1" ]];then
      print_error "敬告：可用空间小于[ ${Sys_kj}G ]，不支持安装青龙${Ql_nvjdc}，请挂载大点磁盘空间容量"
      sleep 1
      exit 1
    fi
  else
    Ubunkj="$(df -h|grep -v tmpfs |grep "/dev/.*" |awk '{print $4}' |awk 'NR==1')"
    FINAL=`echo ${Ubunkj: -1}`
    if [[ "${FINAL}" =~ (M|K) ]]; then
      print_error "敬告：可用空间小于[ ${Sys_kj}G ]，不支持安装青龙${Ql_nvjdc}，请加大磁盘空间容量"
      sleep 1
      exit 1
    fi
    Ubuntu_kj="$(df -h|grep -v tmpfs |grep "/dev/.*" |awk '{print $4}' |awk 'NR==1' |sed 's/.$//g')"
    Kongjian="$(awk -v num1=${Ubuntu_kj} -v num2=${Sys_kj} 'BEGIN{print(num1>num2)?"0":"1"}')"
    ECHOY "您当前系统可用空间为${Ubuntu_kj}G"
    if [[ "${Kongjian}" == "1" ]];then
      print_error "敬告：可用空间小于[ ${Sys_kj}G ]，不支持安装青龙${Ql_nvjdc}，请加大磁盘空间"		
      sleep 1
      exit 1
    fi
  fi
}

function install_ql() {
  ECHOG "正在安装青龙面板，请稍后..."
docker run -dit \
  -v $QL_PATH/ql:/ql/data \
  -v $QL_PATH/ql/jd:/ql/data/jd \
  ${NETWORK} \
  --name qinglong \
  --hostname qinglong \
  --restart unless-stopped \
  whyour/qinglong:latest
  
  docker restart qinglong > /dev/null 2>&1
  sleep 2
  if [[ `docker ps -a | grep -c "qinglong"` == '1' ]]; then
    print_ok "青龙面板安装完成"
  else
    print_error "青龙面板安装失败"
    exit 1
  fi
}

function ql_qlbeifen() {
  if [[ -f ${Current}/ghproxy.sh ]]; then
    docker cp ${Current}/ghproxy.sh qinglong:/ql/data/repo/ghproxy.sh
    rm -rf ${Current}/ghproxy.sh
  else
    print_error "没检测到主应用变量文件，请再次尝试安装!"
    exit 1
  fi
  if [[ -d "$QL_PATH/qlbeifen1" ]]; then
    if [[ "$(grep -c JD_WSCK=\"pin= ${QL_PATH}/qlbeifen1/ql/config/env.sh)"  -ge "1" ]] || [[ "$(grep -c JD_COOKIE=\"pt_key= ${QL_PATH}/qlbeifen1/ql/config/env.sh)" -ge "1" ]]; then
      ECHOG "检测到您有[wskey]或者[pt_key]存在，正在还原env.sh文件（KEY文件）"
      docker cp ${QL_PATH}/qlbeifen1/ql/db/env.db qinglong:/ql/data/db/env.db
      docker cp ${QL_PATH}/qlbeifen1/ql/config/env.sh qinglong:/ql/data/config/env.sh
      judge "还原env.sh文件"
    fi
  fi
}

function qinglong_dl() {
  clear
  echo
  echo
  ECHOG "青龙面板安装完成，请先登录面板再按回车，进行下一步安装程序，步骤如下："
  ECHOYY "请使用 http://${IP}:${QL_PORT} 在浏览器打开青龙面板"
  ECHOB "点击[开始安装] --> [通知方式]跳过 --> 设置好[用户名]跟[密码] --> 点击[提交] --> 点击[去登录] --> 输入帐号密码完成登录!"
  echo
  if [[ "${Api_Client}" == "true" ]]; then
    ECHOYY "登录青龙面板面板后，请在青龙面板设置好Client ID和Client Secret，设置步骤如下："
    ECHOB "系统设置 --> 应用设置 --> 添加应用 --> 名称[随意] --> 权限[全部版块都点击选上] --> 点一下新建应用空白处 --> 点击确定"
    QLMEUN="请登录青龙面板后,再设置好Client ID和Client Secret,按回车继续安装脚本,或者按[ N/n ]退出安装程序"
  else
    QLMEUN="请登录青龙面板后,按回车继续安装脚本,或者按[ N/n ]退出安装程序"
  fi
  echo
  while :; do
  read -p " ${QLMEUN}： " MENU
  S=""
  if [[ "${Api_Client}" == "true" ]]; then
    if [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` -ge '1' ]] && [[ `docker exec -it qinglong bash -c "cat /ql/db/app.db" | grep -c "\"name\""` -ge '1' ]]; then
      S="Y"
    fi
  elif [[ "${Api_Client}" == "false" ]]; then
    if [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` -ge '1' ]]; then
      S="Y"
    fi
  fi
  if [[ ${MENU} == "N" ]] || [[ ${MENU} == "n" ]]; then
    S="N"
  fi
  case $S in
    Y)
    ECHOG ""
  break
  ;;
  N)
    ECHOR "退出安装脚本程序!"
    sleep 1
    exit 1
  break
  ;;
  *)
    if [[ "${Api_Client}" == "true" ]]; then
      if [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` == '0' ]] && [[ `docker exec -it qinglong bash -c "cat /ql/db/app.db" | grep -c "\"name\""` == '0' ]]; then
        echo
        QLMEUN="请先登录青龙面板后,再设置好Client ID和Client Secret,按回车继续安装脚本,或者按[ N/n ]退出安装程序"
      elif [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` -ge '1' ]] && [[ `docker exec -it qinglong bash -c "cat /ql/db/app.db" | grep -c "\"name\""` == '0' ]]; then
        echo
        QLMEUN="您已经登录青龙面板,请设置好Client ID和Client Secret,按回车继续安装脚本,或者按[ N/n ]退出安装程序"
      fi
    else
        echo
        QLMEUN="请登录青龙面板后,按回车继续安装脚本,或者按[ N/n ]退出安装程序"
     fi
  ;;
  esac
  done
}

function install_rw() {
  [[ ${Npm_yilai} == "true" ]] && docker exec -it qinglong bash -c  "$(curl -fsSL ${curlurl}/npm.sh)"
  [[ ${Npm_yilai} == "false" ]] && docker exec -it qinglong bash -c  "$(curl -fsSL ${curlurl}/python3.sh)"
  ECHOG "开始安装脚本，请耐心等待..."
  docker exec -it qinglong bash -c "$(curl -fsSL ${curlurl}/${Sh_Path})"
}

function install_yanzheng() {
  if [[ -f ${QL_PATH}/ql/config/Error ]]; then
    rm -rf ${QL_PATH}/ql/config/Error
    exit 1
  fi
  [[ -f ${QL_PATH}/qlbeifen1/ql/config/bot.json ]] && docker cp ${QL_PATH}/qlbeifen1/ql/config/bot.json qinglong:/ql/data/config/bot.json
  [[ -d ${QL_PATH}/qlbeifen1/ql/jd ]] && docker cp ${QL_PATH}/qlbeifen1/ql/jd qinglong:/ql/data/
  if [[ -f ${QL_PATH}/qlbeifen1/ql/scripts/rwwc ]]; then
    docker cp ${QL_PATH}/qlbeifen1/ql/config/config.sh qinglong:/ql/data/config/config.sh
    docker cp ${QL_PATH}/qlbeifen1/ql/config/config.sh qinglong:/ql/data/sample/config.sample.sh
  fi
  if [[ `ls $QL_PATH/ql/jd | grep -c ".session"` -ge '1' ]] && [[ ${wjmz} == "Aaron-lv" ]]; then
    for X in $(ls -a $QL_PATH/ql/jd |egrep -o [0-9]+-[0-9]+.sh); do docker exec -it qinglong bash -c "task /ql/data/jd/${X}"; done
  fi
  rm -rf ${QL_PATH}/qlbeifen1 > /dev/null 2>&1
  docker exec -it qinglong bash -c "rm -rf /ql/data/qlwj"
  bash -c "$(curl -fsSL ${curlurl}/timesync.sh)"
  echo "${QL_PATH}/ql/scripts/rwwc" > ${QL_PATH}/ql/scripts/rwwc
  echo "export rwwc=${QL_PATH}/ql/scripts/rwwc" > /etc/bianliang.sh
  docker restart qinglong > /dev/null 2>&1
  print_ok "任务安装完成，请刷新青龙面板查看"
}

function jiance_nvjdc() {
  if [[ `docker images | grep -c "nvjdc"` -ge '1' ]] || [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    ECHOY "检测到nvjdc面板，正在御载nvjdc面板，请稍后..."
    dockernv=$(docker ps -a|grep nvjdc) && dockernvid=$(awk '{print $(1)}' <<<${dockernv})
    imagesnv=$(docker images|grep nvjdc) && imagesnvid=$(awk '{print $(3)}' <<<${imagesnv})
    docker stop -t=5 "${dockernvid}" > /dev/null 2>&1
    docker rm "${dockernvid}"
    docker rmi "${imagesnvid}"
    find / -iname 'nolanjdc' | xargs -i rm -rf {} > /dev/null 2>&1
    find / -iname 'nvjdc' | xargs -i rm -rf {} > /dev/null 2>&1
    if [[ `docker images | grep -c "nvjdc"` == '0' ]]; then
      print_ok "nvjdc面板御载完成"
    else
      print_error "nvjdc面板御载失败"
      exit 1
    fi
  fi
}

function git_clone() {
  ECHOG "开始安装nvjdc面板，请稍后..."
  ECHOY "下载nvjdc源码"
  rm -rf "${Home}" && git clone ${GithubProxyUrl}https://github.com/NolanHzy/nvjdcdocker.git ${Home}
  judge "nvjdc源码下载"
}

function pull_nvjdc() {
  ECHOY "安装nvjdc镜像中，安装需要时间，请耐心等候..."
  docker pull nolanhzy/nvjdc:latest
  if [[ `docker images | grep -c "nvjdc"` -ge '1' ]]; then
    print_ok "nvjdc镜像安装 完成"
  else
    print_error "nvjdc镜像安装失败"
    exit 1
  fi
}

function Config_json() {
  mkdir -p ${Config}
  bash -c  "$(curl -fsSL ${curlurl}/json.sh)"
  judge "自动配置nvjdc的Config.json文件"
  chmod +x ${Config}/Config.json
}

function chrome_linux() {
  ECHOY "下载chrome-linux"
  mkdir -p ${Chromium} && cd ${Chromium}
  wget https://mirrors.huaweicloud.com/chromium-browser-snapshots/Linux_x64/884014/chrome-linux.zip
  judge "chrome-linux下载"
  ECHOY "解压chrome-linux文件包，请稍后..."
  unzip chrome-linux.zip
  if [[ ! -d ${Chromium}/chrome-linux ]]; then
    print_error "chrome-linux文件解压失败"
    exit 1
  else
    print_ok "解压chrome-linux文件 完成"
    rm  -f chrome-linux.zip
  fi
}

function linux_nolanjdc() {
  ECHOY "启动镜像中，请稍后..."
  cd ${Current}
  if [[ -f /etc/openwrt_release ]] && [[ -f /rom/etc/openwrt_release ]]; then
    docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  ${Home}:/app \
    -it --privileged=true  nolanhzy/nvjdc:latest
    docker exec -it nolanjdc bash -c "cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
    /etc/init.d/dockerman restart > /dev/null 2>&1
    /etc/init.d/dockerd restart > /dev/null 2>&1
    sleep 3
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  ${Home}:/app \
    -it --privileged=true  nolanhzy/nvjdc:latest
    docker exec -it nolanjdc bash -c "cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
    sleep 2
  else
    cd  ${Home}
    docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  "$(pwd)":/app \
    -v /etc/localtime:/etc/localtime:ro \
    -it --privileged=true  nolanhzy/nvjdc:latest
    sleep 2
  fi
  cd ${Current}
  if [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    docker restart nolanjdc > /dev/null 2>&1
    docker restart qinglong > /dev/null 2>&1
    sleep 3
    print_ok "nvjdc镜像启动成功"
  else
    print_error "nvjdc镜像启动失败"
    exit 1
  fi
  dockernv=$(docker ps -a|grep nvjdc) && dockernvid=$(awk '{print $(1)}' <<<${dockernv})
  docker update --restart=always "${dockernvid}" > /dev/null 2>&1
  rm -rf ${Home}/build.log
  timeout 4 docker logs -f nolanjdc |tee ${Home}/build.log
  timeout 9 docker logs -f nolanjdc |tee ${Home}/build.log
  if [[ `grep -c "启动成功" ${Home}/build.log` -ge '1' ]] || [[ `grep -c "NETJDC started" ${Home}/build.log` -ge '1' ]]; then
    print_ok "nvjdc安装 完成"
    ECHOYY "nvjdc配置已自动配置完成，如您需修改可至 ${Config}/Config.json 修改!"
  else
    print_error "nvjdc安装失败"
    exit 1
  fi
  rm -rf ${Home}/build.log
  ECHOY "您的nvjdc面板地址为：http://${IP}:${JDC_PORT}"
}

function up_nvjdc() {
  cd ${Current}
  [[ -f /etc/bianliang.sh ]] && source /etc/bianliang.sh
  ECHOY "下载nvjdc源码"
  rm -rf ${QL_PATH}/nvjdcbf
  cp -Rf ${Home} ${QL_PATH}/nvjdcbf
  rm -rf "${Home}" && git clone ${GithubProxyUrl}https://github.com/NolanHzy/nvjdcdocker.git ${Home}
  judge "下载源码"
  cp -Rf ${QL_PATH}/nvjdcbf/Config ${Home}/Config
  cp -Rf ${QL_PATH}/nvjdcbf/.local-chromium ${Home}/.local-chromium
  if [[ `docker images | grep -c "nvjdc"` -ge '1' ]] || [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    ECHOY "御载nvjdc镜像"
    dockernv=$(docker ps -a|grep nvjdc) && dockernvid=$(awk '{print $(1)}' <<<${dockernv})
    imagesnv=$(docker images|grep nvjdc) && imagesnvid=$(awk '{print $(3)}' <<<${imagesnv})
    docker stop -t=5 "${dockernvid}" > /dev/null 2>&1
    docker rm "${dockernvid}"
    docker rmi "${imagesnvid}"
  fi
  if [[ `docker images | grep -c "nvjdc"` == '0' ]]; then
    print_ok "nvjdc镜像御载完成"
  else
    print_error "nvjdc镜像御载失败，再次尝试删除"
  fi
  cd ${Current}
  ECHOG "更新镜像，请耐心等候..."
  sudo docker pull nolanhzy/nvjdc:latest
  ECHOY "启动镜像"
  if [[ -f /etc/openwrt_release ]] && [[ -f /rom/etc/openwrt_release ]]; then
    docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  ${Home}:/app \
    -it --privileged=true  nolanhzy/nvjdc:latest
    docker exec -it nolanjdc bash -c "cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
    /etc/init.d/dockerman restart > /dev/null 2>&1
    /etc/init.d/dockerd restart > /dev/null 2>&1
    sleep 3
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  ${Home}:/app \
    -it --privileged=true  nolanhzy/nvjdc:latest
    docker exec -it nolanjdc bash -c "cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
    sleep 2
  else
    cd  ${Home}
    docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  "$(pwd)":/app \
    -v /etc/localtime:/etc/localtime:ro \
    -it --privileged=true  nolanhzy/nvjdc:latest
    sleep 2
  fi
  cd ${Current}
  if [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    docker restart nolanjdc > /dev/null 2>&1
    docker restart qinglong > /dev/null 2>&1
    sleep 5
    print_ok "nvjdc镜像启动成功"
  else
    print_error "nvjdc镜像启动失败"
    exit 1
  fi
  dockernv=$(docker ps -a|grep nvjdc) && dockernvid=$(awk '{print $(1)}' <<<${dockernv})
  docker update --restart=always "${dockernvid}" > /dev/null 2>&1
  rm -rf ${Home}/build.log
  timeout 4 docker logs -f nolanjdc |tee ${Home}/build.log
  timeout 9 docker logs -f nolanjdc |tee ${Home}/build.log
  if [[ `grep -c "启动成功" ${Home}/build.log` -ge '1' ]] || [[ `grep -c "NETJDC started" ${Home}/build.log` -ge '1' ]]; then
    print_ok "nvjdc升级完成"
  else
    print_error "nvjdc升级失败"
    exit 1
  fi
  rm -rf ${Home}/build.log
  exit 0
}

function OpenApi_Client() {
  export MANEID="$(grep 'name' ${QL_PATH}/ql/db/app.db |awk 'END{print}' |sed -r 's/.*name\":\"(.*)\"/\1/' |cut -d "\"" -f1)"
  export CLIENTID="$(grep 'client_id' ${QL_PATH}/ql/db/app.db |awk 'END{print}' |sed -r 's/.*client_id\":\"(.*)\"/\1/' |cut -d "\"" -f1)"
  export CLIENTID_SECRET="$(grep 'client_secret' ${QL_PATH}/ql/db/app.db |awk 'END{print}' |sed -r 's/.*client_secret\":\"(.*)\"/\1/' |cut -d "\"" -f1)"
}

function Google_Check() {
  export Google_Check=$(curl -I -s --connect-timeout 8 google.com -w %{http_code} | tail -n1)
  if [ ! "$Google_Check" == 301 ];then
    export curlurl="https://cdn.jsdelivr.net/gh/281677160/ql@main"
    export GithubProxyUrl="https://ghproxy.com/"
    ECHORR "访问谷歌失败，以下使用代理安装"
    sleep 2
    echo "
    export curlurl="https://cdn.jsdelivr.net/gh/281677160/ql@main"
    export GithubProxyUrl="https://ghproxy.com/"
    " > ${Current}/ghproxy.sh
    sed -i "s/^[ \t]*//g" ${Current}/ghproxy.sh
  else
    export curlurl="https://raw.githubusercontent.com/281677160/ql/main"
    export GithubProxyUrl=""
    echo "
    export curlurl="https://raw.githubusercontent.com/281677160/ql/main"
    export GithubProxyUrl=""
    " > ${Current}/ghproxy.sh
    sed -i "s/^[ \t]*//g" ${Current}/ghproxy.sh
  fi
}

function config_bianliang() {
  echo "
  export IP="${IP}"
  export QL_PATH="${QL_PATH}"
  export QL_PORT="${QL_PORT}"
  export JDC_PORT="${JDC_PORT}"
  export QLurl="http://${IP}:${QL_PORT}"
  export CAPACITY="${CAPACITY}"
  export PUSHPLUS="${PUSHPLUS}"
  export CLIENTID="${CLIENTID}"
  export CLIENTID_SECRET="${CLIENTID_SECRET}"
  export Home="${Home}"
  export Config="${Config}"
  export Chromium="${Chromium}"
  export nvrwwc="${Home}/rwwc"
  " >> /etc/bianliang.sh
  sed -i "s/^[ \t]*//g" /etc/bianliang.sh
  chmod +x /etc/bianliang.sh
  [[ -d ${Home} ]] && echo "${Home}/rwwc" > ${Home}/rwwc
}

function aznvjdc() {
  jiance_nvjdc
  git_clone
  pull_nvjdc
  Config_json
  chrome_linux
  linux_nolanjdc
  config_bianliang
}

function qinglong_nvjdc() {
  qinglong_port
  Google_Check
  system_check
  kaiqiroot_ssh
  nolanjdc_lj
  system_docker
  systemctl_status
  uninstall_qinglong
  jiance_nvjdc
  sys_kongjian
  install_ql
  qinglong_dl
  ql_qlbeifen
  OpenApi_Client
  install_rw
  install_yanzheng
  aznvjdc
}

function azqinglong() {
  qinglong_port
  Google_Check
  system_check
  kaiqiroot_ssh
  system_docker
  systemctl_status
  uninstall_qinglong
  jiance_nvjdc
  sys_kongjian
  install_ql
  qinglong_dl
  ql_qlbeifen
  install_rw
  install_yanzheng
  config_bianliang
}

memunvjdc() {
  clear
  echo
  echo
  ECHOB " 1. 升级青龙面板"
  ECHOB " 2. 更新撸豆脚本库"
  ECHOB " 3. 升级nvjdc面板"
  ECHOB " 4. 重启青龙和nvjdc"
  ECHOB " 5. 重置青龙登录错误次数和检测环境并修复"
  ECHOB " 6. 御载nvjdc面板"
  ECHOB " 7. 御载青龙+nvjdc面板"
  ECHOB " 8. 进入第一主菜单（安装界面）"
  ECHOB " 9. 退出程序!"
  echo
  scqlbianmaa="输入您选择的编码"
  while :; do
  read -p " ${scqlbianmaa}： " MVQLJB
  case $MVQLJB in
  1)
    ECHOG "正在检测更新青龙面板,请耐心等候..."
    docker exec -it qinglong ql update
  break
  ;;
  2)
    ECHOY "正在更新任务，请耐心等候..."
    docker exec -it qinglong bash -c "ql extra"
  break
  ;;
  3)
    ECHOY "开始升级nvjdc面板，请耐心等候..."
    Google_Check
    up_nvjdc
  break
  ;;
  4)
    ECHOY "重启nvjdc和青龙，请耐心等候..."
    docker restart nolanjdc
    docker restart qinglong
    sleep 5
    print_ok "命令执行完成"
  break
  ;;
  5)
    ECHOY "开始重置青龙登录错误次数和检测环境并修复，请耐心等候..."
    docker exec -it qinglong bash -c "ql resetlet"
    sleep 2
    docker exec -it qinglong bash -c "ql check"
    bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/timesync.sh)"
    print_ok "命令执行完成"
  break
  ;;
  6)
    ECHOY " 是否御载nvjdc面板?"
    read -p " 是否御载nvjdc面板?输入[Yy]回车确认,直接回车返回菜单：" YZJDC
    case $YZJDC in
    [Yy])
      ECHOG " 正在御载nvjdc面板"
      jiance_nvjdc
    ;;
    *)
      memunvjdc "$@"
    ;;
    esac
  break
  ;;
  7)
    ECHOY " 是否御载青龙+nvjdc面板?"
    read -p " 是否御载青龙+nvjdc面板?输入[Yy]回车确认,直接回车返回菜单：" YZQLNV
    case $YZQLNV in
    [Yy])
      ECHOG "正在御载青龙+nvjdc面板"
      uninstall_qinglong
      jiance_nvjdc
      rm -rf /etc/bianliang.sh
    ;;
    *)
      memunvjdc "$@"
    ;;
    esac
  break
  ;;
  8)
    memu
  break
  ;;
  9)
    ECHOR "您选择了退出程序!"
    sleep 1
    exit 1
  break
  ;;
  *)
    scqlbianmaa="请输入正确的编码"
  ;;
  esac
  done
}

memuqinglong() {
  clear
  echo
  echo
  ECHOYY " 1. 升级青龙面板"
  ECHOY " 2. 更新撸豆脚本库"
  ECHOYY " 3. 重启青龙面板"
  ECHOY " 4. 重置青龙登录错误次数和检测环境并修复"
  ECHOYY " 5. 御载青龙面板"
  ECHOY " 6. 进入第一主菜单（安装界面）"
  ECHOYY " 7. 退出程序!"
  echo
  scqlbianmaa="输入您选择的编码"
  while :; do
  read -p " ${scqlbianmaa}： " QLJB
  case $QLJB in
  1)
    ECHOG "正在检测更新青龙面板,请耐心等候..."
    docker exec -it qinglong ql update
  break
  ;;
  2)
    ECHOY "正在更新任务，请耐心等候..."
    docker exec -it qinglong bash -c "ql extra"
  break
  ;;
  3)
    ECHOY "重启青龙，请耐心等候..."
    docker restart qinglong
    sleep 5
    print_ok "命令执行完成"
  break
  ;;
  4)
    ECHOY "开始重置青龙登录错误次数和检测环境并修复，请耐心等候..."
    docker exec -it qinglong bash -c "ql resetlet"
    sleep 2
    docker exec -it qinglong bash -c "ql check"
    bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/timesync.sh)"
    print_ok "命令执行完成"
  break
  ;;
  5)
    ECHOB " 是否御载青龙面板?"
    echo
    read -p " 是否御载青龙面板?输入[Yy]回车确认,直接回车返回菜单：" YZQLN
    case $YZQLN in
    [Yy])
      ECHOG "正在御载青龙面板"
      uninstall_qinglong
      rm -rf /etc/bianliang.sh
    ;;
    *)
      memuqinglong "$@"
    ;;
    esac
  break
  ;;
  6)
    memu
  break
  ;;
  7)
    ECHOR "您选择了退出程序!"
    sleep 1
    exit 1
  break
  ;;
  *)
    scqlbianmaa="请输入正确的编码"
  ;;
  esac
  done
}

memuaz() {
  clear
  echo
  echo
  [[ -n "${kugonggao}" ]] && ECHOY " ${kugonggao}"
  ECHOB " 1. 安装青龙+任务+依赖+nvjdc面板"
  ECHOB " 2. 安装青龙+任务+nvjdc面板（依赖自行在青龙面板安装）"
  ECHOB " 3. 安装青龙+任务+依赖"
  ECHOB " 4. 安装青龙+任务（依赖自行在青龙面板安装）"
  ECHOB " 5. 退出安装程序!"
  echo
  scqlbianmaa="输入您选择的编码"
  while :; do
  read -p " ${scqlbianmaa}： " QLJB
  case $QLJB in
  1)
    export Api_Client="true"
    export Npm_yilai="true"
    export Sys_kj="10"
    export Ql_nvjdc="和nvjdc面板"
    ECHOG " 安装青龙+任务+依赖+nvjdc面板"
    qinglong_nvjdc
  break
  ;;
  2)
    export Api_Client="true"
    export Npm_yilai="false"
    export Sys_kj="10"
    export Ql_nvjdc="和nvjdc面板"
    ECHOG " 安装青龙+任务+nvjdc面板（依赖自行在青龙面板安装）"
    qinglong_nvjdc
  break
  ;;
  3)
    export Api_Client="false"
    export Npm_yilai="true"
    export Sys_kj="5"
    export Ql_nvjdc=""
    ECHOG " 安装青龙+任务+依赖"
    azqinglong
  break
  ;;
  4)
    export Api_Client="false"
    export Npm_yilai="false"
    export Sys_kj="5"
    export Ql_nvjdc=""
    ECHOG " 安装青龙+任务（依赖自行在青龙面板安装）"
    azqinglong
  break
  ;;
  5)
    ECHOR "您选择了退出程序!"
    sleep 1
    exit 1
  break
  ;;
  *)
    scqlbianmaa="请输入正确的编码"
  ;;
  esac
  done
}

memu() {
  clear
  echo
  echo
  ECHORR "脚本适用于（ubuntu、debian、centos、alpine、openwrt）"
  ECHORR "一键安装青龙，包括（docker、任务、依赖安装，一条龙服务"
  ECHORR "N1或者其他晶晨系列盒子安装在[root]文件夹，其他设备都安装在[opt]文件夹内"
  ECHORR "自动检测docker，有则跳过，无则安装，openwrt则请自行安装docker，如果空间太小请挂载好硬盘"
  ECHORR "如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装"
  ECHORR "如果安装当前文件夹已经存在 ql 文件的话，如果您的[环境变量文件]符合要求，就会继续使用，免除重新输入KEY的烦恼"
  ECHORR "nvjdc面板可以进行手机验证挂机，无需复杂的抓KEY，如果是外网架设的话，任何人都可以用您的nvjdc面板进入您的青龙挂机"
  ECHORR "安装过程会有重启docker操作，如不能接受，请退出安装"
  echo
  ECHOY " 请选择您要安装什么类型的任务库"
  ECHOB " 1. TG机器人每周提交助力码库（shufflewzc/faker2和JDHelloWorld/jd_scripts）两个库"
  ECHOB " 2. 自动提交助力码库,要去库的作者那里提交资料过白名单（feverrun/my_scripts）单库"
  ECHOB " 3. 退出安装程序!"
  echo
  scqlanmaa="输入您选择的编码"
  while :; do
  read -p " ${scqlanmaa}： " TGQLJB
  case $TGQLJB in
  1)
    export wjmz="Aaron-lv"
    export Sh_Path="Aaron-lv.sh"
    export kugonggao="您库的选择：shufflewzc/faker2和JDHelloWorld/jd_scripts"
    memuaz
  break
  ;;
  2)
    export wjmz="feverrun"
    export Sh_Path="feverrun.sh"
    export kugonggao="您库的选择：feverrun/my_scripts"
    memuaz
  break
  ;;
  3)
    ECHOR "您选择了退出程序!"
    sleep 1
    exit 1
  break
  ;;
  *)
    scqlanmaa="请输入正确的编码"
  ;;
  esac
  done
}
[[ -f /etc/bianliang.sh ]] && source /etc/bianliang.sh
if [[ `docker images |grep -c "qinglong"` -ge '1' ]] && [[ `docker images |grep -c "nvjdc"` -ge '1' ]] && [[ -f ${rwwc} ]] && [[ -f ${nvrwwc} ]]; then
  memunvjdc "$@"
elif [[ `docker images | grep -c "qinglong"` -ge '1' ]] && [[ -f ${rwwc} ]]; then
  memuqinglong "$@"
else
  memu "$@"
fi
