#!/usr/bin/env bash

# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
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
    [[ ${CHONGXIN} == "YES" ]] && unstall_centos_dk
    ECHOY "正在安装docker，请耐心等候..."
    install_centos_dk
    hello_world
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
    apt-get -y update
    apt-get install -y sudo wget curl
    [[ ${CHONGXIN} == "YES" ]] && unstall_ubuntu_dk
    ECHOY "正在安装docker，请耐心等候..."
    install_ubuntu_dk
    hello_world
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
    apt-get -y update
    apt-get install -y sudo wget curl
    [[ ${CHONGXIN} == "YES" ]] && unstall_debian_dk
    ECHOY "正在安装docker，请耐心等候..."
    install_debian_dk
    hello_world
  else
    print_error "本一键安装docker脚本只支持（centos、ubuntu和debian）!"
    exit 1
  fi
}

function jiance_dk() {
  if [[ -x "$(command -v docker)" ]]; then
    ECHOY "检测到docker存在，是否重新安装?"
    ECHOB "重新安装会把您现有的所有容器及镜像全部删除，请慎重!"
    while :; do
    export CHONGXIN=""
    read -p " [输入[ N/n ]退出安装，输入[ Y/y ]回车继续]： " ANDK
    case $ANDK in
     [Yy])
       export CHONGXIN="YES"
    break
    ;;
    [Nn])
      export CHONGXIN="NO"
      TIME r "您选择了退出安装程序!"
      sleep 1
      exit 1
    break
    ;;
    *)
      TIME b "提示：请输入正确的选择!"
    ;;
    esac
    done
  fi
}

function install_centos_dk() {
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce docker-ce-cli containerd.io
  sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  sudo systemctl enable docker
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
}

function unstall_centos_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  yum -y remove docker-ce.x86_64
  yum -y remove
  find / -iname 'docker' | xargs -i rm -rf {}
}


function install_ubuntu_dk() {
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  if [[ $? -ne 0 ]];then
    curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  fi
  sudo apt-key fingerprint 0EBFCD88
  if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
    TIME r "密匙验证出错，或者没下载到密匙了，请检查网络，或者源有问题"
    exit 1
  fi
  sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
}

function unstall_ubuntu_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  sudo apt-get autoremove docker-* --purge
  sudo find / -iname 'docker' | xargs -i rm -rf {}
}

function install_debian_dk() {
  sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
  if [[ $? -ne 0 ]];then
    curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
  fi
  sudo apt-key fingerprint 0EBFCD88
  if [[ `sudo apt-key fingerprint 0EBFCD88 | grep -c "0EBF CD88"` = '0' ]]; then
    TIME r "密匙验证出错，或者没下载到密匙了，请检查网络，或者上游有问题"
    exit 1
  fi
  sudo add-apt-repository -y "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  sed -i 's#ExecStart=/usr/bin/dockerd -H fd://#ExecStart=/usr/bin/dockerd#g' /lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  if [[ -x "$(command -v docker)" ]]; then
    print_ok "docker安装完成"
  else
    print_error "docker安装失败"
    exit 1
  fi
}

function unstall_debian_dk() {
  ECHOY "正在御载docker..."
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -q)
  sudo apt autoremove docker-* --purge
  find / -iname 'docker' | xargs -i rm -rf {}
}

function hello_world() {
  ECHOY "测试docker拉取镜像是否成功"
  sudo docker run hello-world |tee build.log
  if [[ `docker ps -a | grep -c "hello-world"` -ge '1' ]] && [[ `grep -c "docs.docker" build.log` -ge '1' ]]; then
    ECHOG "测试镜像拉取成功，正在删除测试镜像..."
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    rm -fr build.log
    ECHOY "测试镜像删除完毕"
    print_ok "docker安装成功"
  else
    ECHOY "docker虽然安装成功但是拉取镜像失败，这个原因很多是因为以前的docker没御载完全造成的，或者容器网络问题"
    ECHOY "重启服务器后，用 sudo docker run hello-world 命令测试吧，能拉取成功就成了"
    rm -fr build.log
    sleep 2
    exit 1
  fi
}

memu() {
  jiance_dk
  system_check
}

memu "$@"
