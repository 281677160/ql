#!/usr/bin/env bash

#====================================================
#	System Request:Ubuntu 18.04+/20.04+
#	Author:	281677160
#	Dscription: qinglong onekey Management
#	github: https://github.com/281677160/danshui
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

function qinglong_port() {
  clear
  echo
  ECHOY " 请选择网络类型"
  ECHOB " 1. bridge [默认类型]"
  ECHOB " 2. host [一般为openwrt旁路由才选择的]"
  echo
  scqlbianma="输入您选择的编码"
  while :; do
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
  export local_ip="$(curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress)"
  export YUMING="请输入您当前服务器的IP"
  ECHOY " ${YUMING}[比如：${local_ip}]"
  while :; do
  read -p " ${YUMING}：" IP
  oip="$(echo ${IP} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ "${IP}" == "${oip}" ]]; then
    export domainy="Y"
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
  if [[ "${QING_PORT}" == "YES" ]]; then
    ECHOG "请设置端口，默认端口为[5700]，不懂设置的话，直接回车使用默认[5700]端口"
    read -p " 请输入端口：" QL_PORT
    export QL_PORT=${QL_PORT:-"5700"}
    export NETWORK="-p ${QL_PORT}:5700"
    export YPORT="您设置的端口为"
  else
    export YPORT="host默认端口为"
    export NETWORK="--net host"
  fi
  echo
  ECHOGG "您的IP为：${IP}"
  ECHOGG "${YPORT}：${QL_PORT}"
  export QLurl="http://${IP}:${QL_PORT}"
  echo
  read -p " 检查是否正确,正确则按回车继续,不正确输入[Q/q]回车重新输入： " NNRT
  case $NNRT in
  [Qq])
    qinglong_port
    exit 0
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
  elif [[ "$(. /etc/os-release && echo "$ID")" == "openwrt" ]]; then
    ECHOG "正在安装宿主机所需要的依赖，请稍后..."
    opkg update
    opkg install git-http
    opkg install ca-bundle
    opkg install unzip
    XTong="openwrt"
    if [[ -d /opt/docker ]]; then
      export QL_PATH="/opt"
      export QL_Kongjian="/opt/docker"
    elif [[ -d /mnt/mmcblk2p4/docker ]]; then
      export QL_PATH="/root"
      export QL_Kongjian="/mnt/mmcblk2p4/docker"
    else
      ECHOR "没找到/opt/docker或者/mnt/mmcblk2p4/docker"
      exit 1
    fi
  else
    print_error "不支持您的系统"
    exit 1
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
      print_error "没检测到docker，openwrt请自行安装docker，和挂载好5G或以上的硬盘"
      sleep 1
      exit 0
    fi
  else
    if [[ ! -x "$(command -v docker)" ]]; then
      ECHOR "没检测到docker，正在安装docker"
      bash -c "$(curl -fsSL ${curlurl}/docker.sh)"
      sleep 1
      exit 0
    fi
  fi
}

function systemctl_status() {
  systemctl start docker
  sleep 2
  ECHOG "检测docker是否在运行"
  if [[ `systemctl status docker |grep -c "active (running) "` == '1' ]]; then
    print_ok "docker正在运行中!"
  else
    print_error "docker没有启动，请先启动docker，或者检查一下是否安装失败"
    sleep 1
    exit 1
  fi
}

function Unstall_qinglong() {
  if [[ `docker images | grep -c "qinglong"` -ge '1' ]] || [[ `docker ps -a | grep -c "qinglong"` -ge '1' ]]; then
    ECHOY "检测青龙面板，正在御载青龙面板，请稍后..."
    docker=$(docker ps -a|grep qinglong) && dockerid=$(awk '{print $(1)}' <<<${docker})
    images=$(docker images|grep qinglong) && imagesid=$(awk '{print $(3)}' <<<${images})
    docker stop -t=5 "${dockerid}" > /dev/null 2>&1
    docker rm "${dockerid}"
    docker rmi "${imagesid}"
    if [[ `docker ps -a | grep -c "qinglong"` == '0' ]]; then
      print_ok "青龙面板御载完成"
    else
      print_error "青龙面板御载失败，再次尝试删除"
      Unstall_qinglong
    fi
  fi

  if [[ ! -d "$QL_PATH/qlbeifen1" ]]; then
    if [[ -d "$QL_PATH/ql/config" ]]; then
      ECHOY "检测到 $QL_PATH 有 ql 文件夹,正在把 $QL_PATH/ql 移动到 $QL_PATH/qlbeifen 文件夹"
      ECHOY "如有需要备份文件的请到 $QL_PATH/qlbeifen 文件夹查看"
      rm -fr $QL_PATH/qlbeifen && mkdir -p $QL_PATH/qlbeifen
      cp -r $QL_PATH/ql $QL_PATH/qlbeifen/ql > /dev/null 2>&1
      cp -r $QL_PATH/qlbeifen $QL_PATH/qlbeifen1 > /dev/null 2>&1
      rm -rf $QL_PATH/ql
      sleep 2
    fi
  else
      rm -rf $QL_PATH/ql
  fi
}

function sys_kongjian() {
  if [[ "$(. /etc/os-release && echo "$ID")" == "openwrt" ]]; then
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
  -v $QL_PATH/ql/config:/ql/config \
  -v $QL_PATH/ql/log:/ql/log \
  -v $QL_PATH/ql/db:/ql/db \
  -v $QL_PATH/ql/scripts:/ql/scripts \
  -v $QL_PATH/ql/jbot:/ql/jbot \
  -v $QL_PATH/ql/raw:/ql/raw \
  -v $QL_PATH/ql/jd:/ql/jd \
  -v $QL_PATH/ql/repo:/ql/repo \
  ${NETWORK} \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest
  if [[ `docker ps -a | grep -c "qinglong"` == '1' ]]; then
    print_ok "青龙面板安装完成"
  else
    print_error "青龙面板安装失败"
    exit 1
  fi
}

function hnanyuan_bf() {
  docker cp /root/ghproxy.sh qinglong:/ql/repo/ghproxy.sh
  rm -rf /root/ghproxy.sh
  if [[ -n "$(ls -A "${QL_PATH}/qlbeifen1" 2>/dev/null)" ]]; then
    curl -fsSL ${curlurl}/${wjmz}/auth.json > ${QL_PATH}/qlbeifen1/auth.json
    docker cp ${QL_PATH}/qlbeifen1/ql/config/env.sh qinglong:/ql/config/env.sh
    docker cp ${QL_PATH}/qlbeifen1/ql/db/env.db qinglong:/ql/db/env.db
    docker cp ${QL_PATH}/qlbeifen1/auth.json qinglong:/ql/config/auth.json
    docker cp ${QL_PATH}/qlbeifen1/auth.json qinglong:/ql/db/auth.db
    docker restart qinglong
  fi
}

function install_rw() {
  clear
  echo
  ECHOY "青龙面板安装完成，请先登录面板再按回车，进行下一步任务安装程序..."
  ECHOYY "请使用 ${IP}:${QL_PORT} 在浏览器打开控制面板"
  ECHOB "点击[开始安装] --> [通知方式]跳过 --> 设置好[用户名]跟[密码] --> 点击[提交] --> 点击[去登录] --> 输入帐号密码完成登录!"
  echo
  QLMEUN="请登录青龙面板后,按回车继续安装脚本,或者现在按[ N/n ]退出安装程序"
  while :; do
  read -p " ${QLMEUN}： " MENU
  if [[ `docker exec -it qinglong bash -c "cat /ql/config/auth.json" | grep -c "\"token\""` -ge '1' ]]; then
    S="Y"
  fi
  if [[ ${MENU} == "N" ]] || [[ ${MENU} == "n" ]]; then
    S="N"
  fi
  case $S in
    Y)
    [[ ${Api_Client} == "true" ]] && OpenApi_Client
    [[ ${Npm_yilai} == "true" ]] && docker exec -it qinglong bash -c  "$(curl -fsSL ${curlurl}/npm.sh)"
    [[ ${Npm_yilai} == "false" ]] && docker exec -it qinglong bash -c  "$(curl -fsSL ${curlurl}/python3.sh)"
    ECHOG "开始安装脚本，请耐心等待..."
    docker exec -it qinglong bash -c "$(curl -fsSL ${curlurl}/${Sh_Path})"
  break
  ;;
  N)
    ECHOR "退出安装脚本程序!"
    sleep 2
    exit 1
  break
  ;;
  *)
    QLMEUN="请先登录青龙面板后,按回车继续安装脚本,或者现在按[ N/n ]退出安装程序"
  ;;
  esac
  done
}

function install_yanzheng() {
  if [[ -f ${QL_PATH}/ql/config/Error ]]; then
    rm -rf ${QL_PATH}/ql/config/Error
    rm -rf ${QL_PATH}/qlbeifen1
    exit 1
  fi
  [[ -f ${QL_PATH}/qlbeifen1/ql/config/bot.json ]] && docker cp ${QL_PATH}/qlbeifen1/ql/config/bot.json qinglong:/ql/config/bot.json
  [[ -d ${QL_PATH}/qlbeifen1/ql/jd ]] && docker cp ${QL_PATH}/qlbeifen1/ql/jd qinglong:/ql/
  if [[ `ls $QL_PATH/ql/jd | grep -c ".session"` -ge '1' ]]; then			
    for X in $(ls -a $QL_PATH/ql/jd |egrep -o [0-9]+-[0-9]+.sh); do docker exec -it qinglong bash -c "task /ql/jd/${X}"; done
  fi
  docker restart qinglong > /dev/null 2>&1
  rm -rf ${QL_PATH}/qlbeifen1 > /dev/null 2>&1
  docker exec -it qinglong bash -c "rm -rf /ql/qlwj"
  bash -c "$(curl -fsSL ${curlurl}/timesync.sh)"
  sleep 2
  print_ok "任务安装完成"
}

function jiance_nvjdc() {
  if [[ `docker images | grep -c "nvjdc"` -ge '1' ]] || [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    ECHOY "检测到nvjdc面板，正在御载nvjdc面板，请稍后..."
    dockernv=$(docker ps -a|grep nvjdc) && dockernvid=$(awk '{print $(1)}' <<<${dockernv})
    imagesnv=$(docker images|grep nvjdc) && imagesnvid=$(awk '{print $(3)}' <<<${imagesnv})
    docker stop -t=5 "${dockernvid}" > /dev/null 2>&1
    docker rm "${dockernvid}"
    docker rmi "${imagesnvid}"
    if [[ `docker images | grep -c "nvjdc"` == '0' ]]; then
      print_ok "nvjdc面板御载完成"
    else
      print_error "nvjdc面板御载失败，再次尝试删除"
      jiance_nvjdc
    fi
    rm -rf "${Home}"
  fi
}

function git_clone() {
  ECHOG "开始安装nvjdc面板，请稍后..."
  ECHOY "下载nvjdc源码"
  rm -rf "${Home}" && git clone ${ghproxy_Path}https://github.com/NolanHzy/nvjdcdocker.git ${Home}
  judge "下载源码"
}

function pull_nvjdc() {
  ECHOY "安装nvjdc镜像中，安装需要时间，请耐心等候..."
  sudo docker pull nolanhzy/nvjdc:latest
  if [[ `docker images | grep -c "nvjdc"` -ge '1' ]]; then
    print_ok "镜像安装成功"
  else
    print_error "镜像安装失败"
    exit 1
  fi
}

function Config_json() {
  mkdir -p ${Config}
  bash -c  "$(curl -fsSL ${curlurl}/json.sh)"
  judge "配置修改"
  chmod +x ${Config}/Config.json
}

function chrome_linux() {
  ECHOY "下载chrome-linux"
  mkdir -p ${Chromium} && cd ${Chromium}
  wget -q https://mirrors.huaweicloud.com/chromium-browser-snapshots/Linux_x64/884014/chrome-linux.zip
  judge "下载Chromium"
  unzip chrome-linux.zip
  if [[ ! -d ${Chromium}/chrome-linux ]]; then
    print_error "chrome-linux文件解压失败"
    exit 1
  else
    print_ok "chrome-linux文件解成功"
    rm  -f chrome-linux.zip
  fi
}

function linux_nolanjdc() {
  cd  ${Home}
  ECHOY "启动镜像"
  sudo docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  "$(pwd)":/app \
  -v /etc/localtime:/etc/localtime:ro \
  -it --privileged=true  nolanhzy/nvjdc:latest
  cd /root
  if [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    print_ok "nvjdc镜像启动成功"
  else
    print_error "nvjdc镜像启动成功"
    exit 1
  fi
  timeout -k 1s 4s docker logs -f nolanjdc |tee ${Home}/build.log
  if [[ `grep -c "序列号" ${Home}/build.log` -eq '1' ]] || [[ `grep -c "NETJDC started" ${Home}/build.log` -eq '1' ]]; then
    print_ok "nvjdc安装完成"
  else
    print_error "nvjdc安装失败"
  fi
  ECHOY "您的nvjdc面板地址为：http://${IP}:${JDC_PORT}"
}

function up_nvjdc() {
  [[ -f /etc/bianliang.sh ]] && source /etc/bianliang.sh
  ECHOY "下载nvjdc源码"
  rm -rf ${QL_PATH}/nvjdcbf
  cp -Rf ${Home} ${QL_PATH}/nvjdcbf
  rm -rf "${Home}" && git clone ${ghproxy_Path}https://github.com/NolanHzy/nvjdcdocker.git ${Home}
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
    up_nvjdc
  fi
  cd /root
  ECHOY "更新镜像，请耐心等候..."
  sudo docker pull nolanhzy/nvjdc:latest
  cd ${Home}
  sudo docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  "$(pwd)":/app \
  -v /etc/localtime:/etc/localtime:ro \
  -it --privileged=true  nolanhzy/nvjdc:latest
  cd /root
  rm -rf ${QL_PATH}/nvjdcbf
  if [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    print_ok "nvjdc镜像启动成功"
  else
    print_error "nvjdc镜像启动失败"
    exit 1
  fi
  timeout -k 1s 4s docker logs -f nolanjdc |tee ${Home}/build.log
  if [[ `grep -c "序列号" ${Home}/build.log` -eq '1' ]] || [[ `grep -c "NETJDC started" ${Home}/build.log` -eq '1' ]]; then
    print_ok "nvjdc升级完成"
  else
    print_error "nvjdc升级失败"
  fi
  rm -rf ${Home}/build.log
  exit 0
}

function OpenApi_Client() {
  clear
  echo
  echo
  echo
  ECHOYY "您选择了安装nvjdc面板，请先在青龙面板设置好Client ID和Client Secret，设置步骤如下："
  ECHOB "系统设置 --> 应用设置 --> 添加应用 --> 名称[qinglong] --> 权限[全部点击选上] --> 点一下新建应用空白处 --> 点击确定"
  echo
  read -p " nvjdc面板名称，可中文可英文(直接回车默认：NolanJDCloud): " NVJDCNAME && printf "\n"
  export NVJDCNAME=${NVJDCNAME:-"NolanJDCloud"}
  read -p " 请输入您想设置的nvjdc面板端口(直接回车默认：5701): " JDC_PORT && printf "\n"
  export JDC_PORT=${JDC_PORT:-"5701"}
  read -p " 请输入青龙最大挂机数(直接回车默认：99): " CAPACITY && printf "\n"
  export CAPACITY=${CAPACITY:-"99"}
  export IDMING="请输入青龙Client ID"
  while :; do
  read -p " ${IDMING}：" CLIENTID
  if [[ -n "${CLIENTID}" ]]; then
    export Clie="Y"
  fi
  case $Clie in
  Y)
    export CLIENTID="${CLIENTID}"
  break
  ;;
  *)
    export IDMING="敬告：Client ID不能为空"
  ;;
  esac
  done
  echo
  export CliING="请输入青龙Client Secret"
  while :; do
  read -p " ${CliING}：" CLIENTID_SECRET
  if [[ -n "${CLIENTID_SECRET}" ]]; then
    export Clie="Y"
  fi
  case $Clie in
  Y)
    export CLIENTID_SECRET="${CLIENTID_SECRET}"
  break
  ;;
  *)
    export CliING="敬告：Client Secret不能为空"
  ;;
  esac
  done
  echo
  ECHOGG "您的nvjdc面板地址将为：http://${IP}:${JDC_PORT}"
  ECHOGG "您的青龙最大挂机数为：${CAPACITY}"
  ECHOGG "您的PUSHPLUS消息推送值为：${PUSHPLUS}"
  ECHOGG "您的青龙Client ID为：${CLIENTID}"
  ECHOGG "您的青龙Client Secret为：${CLIENTID_SECRET}"
  echo
  read -p " 检查是否正确,正确则按回车继续,不正确输入[Q/q]回车重新输入： " NNKC
  case $NNKC in
  [Qq])
    OpenApi_Client
    exit 0
  ;;
  *)
    print_ok "您已确认数据无误!"
  ;;
  esac
}

function Google_Check() {
  export Google_Check=$(curl -I -s --connect-timeout 8 google.com -w %{http_code} | tail -n1)
  if [ ! "$Google_Check" == 301 ];then
    export curlurl="https://cdn.jsdelivr.net/gh/281677160/ql@main"
    export ghproxy_Path="https://ghproxy.com/"
    ECHOGG "切换至使用代理下载文件"
    echo "
    export curlurl="https://cdn.jsdelivr.net/gh/281677160/ql@main"
    export ghproxy_Path="https://ghproxy.com/"
    " > /root/ghproxy.sh
  else
    export curlurl="https://raw.githubusercontent.com/281677160/ql/main"
    export ghproxy_Path=""
    echo "
    export curlurl="https://raw.githubusercontent.com/281677160/ql/main"
    export ghproxy_Path=""
    " > /root/ghproxy.sh
  fi
}

function config_bianliang() {
cat >/etc/bianliang.sh <<-EOF
#!/usr/bin/env bash
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
EOF
chmod +x /etc/bianliang.sh
}

function aznvjdc() {
  jiance_nvjdc
  git_clone
  pull_nvjdc
  Config_json
  chrome_linux
  linux_nolanjdc
}

function qinglong_nvjdc() {
  qinglong_port
  Google_Check
  system_check
  nolanjdc_lj
  system_docker
  systemctl_status
  Unstall_qinglong
  sys_kongjian
  install_ql
  hnanyuan_bf
  install_rw
  install_yanzheng
  config_bianliang
  aznvjdc
}

function azqinglong() {
  qinglong_port
  Google_Check
  system_check
  system_docker
  systemctl_status
  Unstall_qinglong
  jiance_nvjdc
  sys_kongjian
  install_ql
  hnanyuan_bf
  install_rw
  install_yanzheng
  config_bianliang
}

memunvjdc() {
  clear
  echo
  echo
  ECHOB " 1. 升级青龙面板"
  ECHOB " 2. 升级nvjdc面板"
  ECHOB " 3. 御载nvjdc面板"
  ECHOB " 4. 御载青龙+nvjdc面板"
  ECHOB " 5. 进入第一主菜单（安装选择界面）"
  ECHOB " 6. 退出程序!"
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
    ECHOY "开始升级nvjdc面板，请耐心等候..."
    Google_Check
    up_nvjdc
  break
  ;;
  3)
    ECHOG " 正在御载+nvjdc面板"
    jiance_nvjdc
  break
  ;;
  4)
    ECHOG "正在御载青龙+nvjdc面板"
    Unstall_qinglong
    jiance_nvjdc
    rm -rf /etc/bianliang.sh
  break
  ;;
  5)
    memu
  break
  ;;
  6)
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
  ECHOY " 1. 升级青龙面板"
  ECHOYY " 2. 御载青龙面板"
  ECHOY " 5. 进入第一主菜单（安装选择界面）"
  ECHOYY " 6. 退出程序!"
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
    ECHOG "正在御载青龙面板"
    Unstall_qinglong
    rm -rf /etc/bianliang.sh
  break
  ;;
  3)
    memu
  break
  ;;
  4)
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
  ECHORR "脚本适用于（ubuntu、debian、centos、openwrt）"
  ECHORR "一键安装青龙，包括（docker、任务、依赖安装，一条龙服务），安装路径[opt]"
  ECHORR "自动检测docker，有则跳过，无则安装，openwrt则请自行安装docker，如果空间太小请挂载好硬盘"
  ECHORR "如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装"
  ECHORR "如果安装当前文件夹已经存在 ql 文件的话，如果您的[环境变量文件]符合要求，就会继续使用，免除重新输入KEY的烦恼"
  ECHORR "nvjdc面板可以进行手机验证挂机，无需复杂的抓KEY，如果是外网架设的话，任何人都可以用您的面板进入您的青龙挂机"
  ECHORR "安装过程会有重启docker操作，如不能接受，请退出安装"
  echo
  ECHOY " 请选择要安装的脚本库"
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
    wjmz="Aaron-lv"
    Sh_Path="Aaron-lv.sh"
    export Api_Client="true"
    export Npm_yilai="true"
    export Sys_kj="12"
    export Ql_nvjdc="和nvjdc面板"
    ECHOG " 安装青龙+任务+依赖+nvjdc面板"
    qinglong_nvjdc
  break
  ;;
  2)
    wjmz="Aaron-lv"
    Sh_Path="Aaron-lv.sh"
    export Api_Client="true"
    export Npm_yilai="false"
    export Sys_kj="12"
    export Ql_nvjdc="和nvjdc面板"
    ECHOG " 安装青龙+任务+nvjdc面板（依赖自行在青龙面板安装）"
    qinglong_nvjdc
  break
  ;;
  3)
    wjmz="Aaron-lv"
    Sh_Path="Aaron-lv.sh"
    export Api_Client="false"
    export Npm_yilai="true"
    export Sys_kj="5"
    export Ql_nvjdc=""
    ECHOG " 安装青龙+任务+依赖"
    azqinglong
  break
  ;;
  4)
    wjmz="Aaron-lv"
    Sh_Path="Aaron-lv.sh"
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
  if [[ -f /etc/bianliang.sh ]] && [[ `docker images | grep -c "qinglong"` -ge '1' ]] && [[ `docker images | grep -c "nvjdc"` -ge '1' ]]; then
    source /etc/bianliang.sh
    memunvjdc "$@"
  elif [[ -f /etc/bianliang.sh ]] && [[ `docker images | grep -c "qinglong"` -ge '1' ]]; then
    source /etc/bianliang.sh
    memuqinglong "$@"
  else
    memu "$@"
  fi
