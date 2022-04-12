#!/usr/bin/env bash

# 字体颜色配置
Green="\033[32;1m"
Red="\033[31m"
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
  echo -e "${Blue} $1 ${Font}"
}
function ECHOG() {
  echo
  echo -e "${Green} $1 ${Font}"
  echo
}

if [[ ! "$USER" == "root" ]]; then
  print_error "警告：请使用root用户操作!~~"
  exit 1
fi

function system_check() {
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
    yum install -y sudo wget curl
    [[ ${CHONGXIN} == "YES" ]] && uninstall_centos_dk
    install_centos_dk
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
    apt-get -y update
    apt-get install -y sudo wget curl
    [[ ${CHONGXIN} == "YES" ]] && uninstall_ubuntu_dk
    install_ubuntu_dk
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
    apt -y update
    apt install -y sudo wget curl
    [[ ${CHONGXIN} == "YES" ]] && uninstall_debian_dk
    install_debian_dk
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    apk update
    apk add sudo wget curl
    [[ ${CHONGXIN} == "YES" ]] && uninstall_alpine_dk
    install_alpine_dk
  else
    print_error "本一键安装docker脚本只支持（centos、ubuntu、debian和alpine）!"
    exit 1
  fi
}

function jiance_dk() {
  if [[ -x "$(command -v docker)" ]]; then
    ECHOY "检测到docker存在，是否重新安装?"
    ECHOG "重新安装会把您现有的所有容器及镜像全部删除，请慎重!"
    while :; do
    export CHONGXIN=""
    read -p " 输入[ N/n ]退出安装，输入[ Y/y ]回车继续： " ANDK
    case $ANDK in
     [Yy])
       export CHONGXIN="YES"
    break
    ;;
    [Nn])
      export CHONGXIN="NO"
      ECHOG "您选择了退出安装程序!"
      sleep 1
      exit 1
    break
    ;;
    *)
      ECHOB "提示：请输入正确的选择!"
    ;;
    esac
    done
  fi
}

function install_centos_dk() {
  ECHOY "正在安装docker，请耐心等候..."
  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  yum install -y docker-ce docker-ce-cli containerd.io
  sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
  docker_daemon
  systemctl daemon-reload
  systemctl enable docker
  systemctl restart docker
  sleep 5
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
}

function uninstall_centos_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  systemctl stop docker
  yum -y remove docker-ce.x86_64
  yum -y remove docker-*
  rm -rf /var/lib/docker
  rm -rf /etc/docker /etc/systemd/system/docker.service.d
  rm -rf /etc/init.d/docker
  rm -rf /lib/systemd/system/{docker.service,docker.socket}
  rm /var/lib/dpkg/info/$nomdupaquet* -f
}


function install_ubuntu_dk() {
  ECHOY "正在安装docker，请耐心等候..."
  apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  if [[ $? -ne 0 ]];then
    curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  fi
  apt-key fingerprint 0EBFCD88
  if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
    print_error "密匙验证出错，或者没下载到密匙了，请检查网络，或者源有问题"
    exit 1
  fi
  add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
  sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
  docker_daemon
  systemctl daemon-reload
  systemctl restart docker
  sleep 5
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  if [[ `docker-compose --version | grep -c "build"` -ge '1' ]]; then
    print_ok "docker-compose安装完成"
  else
    print_error "docker-compose安装失败,对docker使用没影响"
  fi
}

function uninstall_ubuntu_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  systemctl stop docker
  apt-get -y autoremove docker-* --purge
  apt-get -y autoremove --purge
  apt-get -y clean
  rm -rf /var/lib/docker
  rm -rf /etc/init.d/docker
  rm -rf /etc/docker /etc/systemd/system/docker.service.d
  rm -rf /lib/systemd/system/{docker.service,docker.socket}
  rm /var/lib/dpkg/info/$nomdupaquet* -f
  sudo rm /usr/local/bin/docker-compose
}

function install_debian_dk() {
  ECHOY "正在安装docker，请耐心等候..."
  apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
  if [[ $? -ne 0 ]];then
    curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
  fi
  apt-key fingerprint 0EBFCD88
  if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
    print_error "密匙验证出错，或者没下载到密匙了，请检查网络，或者上游有问题"
    exit 1
  fi
  add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
  apt update
  apt install -y docker-ce docker-ce-cli containerd.io
  sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
  docker_daemon
  systemctl daemon-reload
  systemctl restart docker
  sleep 5
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  if [[ `docker-compose --version | grep -c "build"` -ge '1' ]]; then
    print_ok "docker-compose安装完成"
  else
    print_error "docker-compose安装失败,对docker使用没影响"
  fi
}

function uninstall_debian_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  systemctl stop docker
  apt -y autoremove docker-* --purge
  apt -y autoremove --purge
  apt -y clean
  rm -rf /var/lib/docker
  rm -rf /etc/init.d/docker
  rm -rf /etc/docker /etc/systemd/system/docker.service.d
  rm -rf /lib/systemd/system/{docker.service,docker.socket}
  rm /var/lib/dpkg/info/$nomdupaquet* -f
  sudo rm /usr/local/bin/docker-compose
}

function install_alpine_dk() {
  ECHOY "正在安装docker，请耐心等候..."
  echo "
  https://dl-cdn.alpinelinux.org/alpine/v3.14/main
  https://dl-cdn.alpinelinux.org/alpine/v3.14/community
  " > /etc/apk/repositories
  sed -i "s/^[ \t]*//g" /etc/apk/repositories
  apk update
  apk add docker
  rc-update add docker boot
  mkdir -p /var/lib/docker/tmp
  docker_daemon
  service docker start
  sleep 10
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
  apk add py-pip
  apk add docker-compose
  if [[ `docker-compose --version | grep -c "build"` -ge '1' ]]; then
    print_ok "docker-compose安装完成"
  else
    print_error "docker-compose安装失败,对docker使用没影响"
  fi
}

function uninstall_alpine_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  service docker stop
  apk del docker
  rc-update del docker boot
  rm -rf /var/lib/docker
  rm -rf /etc/docker
  rm -rf /etc/init.d/docker
  apk del py-pip docker-compose
}

function hello_world() {
  ECHOY "测试docker拉取镜像是否成功"
  sleep 3
  docker run hello-world |tee build.log
  if [[ `docker ps -a | grep -c "hello-world"` -ge '1' ]] && [[ `grep -c "hub.docker.com" build.log` -ge '1' ]]; then
    ECHOG "测试镜像拉取成功，正在删除测试镜像..."
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    rm -fr build.log
    ECHOY "测试镜像删除完毕"
    print_ok "docker安装成功"
  else
    print_error "docker虽然安装成功但是拉取镜像失败，这个原因很多是因为以前的docker没御载完全造成的，或者容器网络问题"
    print_error "重启服务器后，用 sudo docker run hello-world 命令测试吧，能拉取成功就成了"
    rm -fr build.log
    sleep 1
    exit 1
  fi
}

function docker_daemon() {
sudo mkdir -p /etc/docker
cat >/etc/docker/daemon.json <<-EOF
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF
chmod +x /etc/docker/daemon.json
}

memu() {
  jiance_dk
  system_check
  hello_world
}

memu "$@"
