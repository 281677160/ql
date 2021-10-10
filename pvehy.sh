#!/bin/bash

TIME g "正在更换源...!"
echo
echo
echo '
deb http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib
' > /etc/apt/sources.list
sed -i '1d' /etc/apt/sources.list

rm -rf /etc/apt/sources.list.d/pve-enterprise.list
echo "deb http://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" >/etc/apt/sources.list.d/pve-install-repo.list
sed -i 's#http://download.proxmox.com#https://mirrors.tuna.tsinghua.edu.cn/proxmox#g' /usr/share/perl5/PVE/APLInfo.pm
echo
echo
TIME g "下载PVE7.0源的密匙!"
echo
echo
rm -fr /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
wget http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
	if [[ $? -ne 0 ]];then
		wget http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
    if [[ $? -ne 0 ]];then
      TIME r "下载下载秘钥失败，请检查网络再尝试!"
      sleep 2
      exit 1
    fi
	fi
echo
echo
TIME g "去掉无效订阅"
echo
echo
sed -i 's#if (res === null || res === undefined || !res || res#if (false) {#g' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -i '/data.status.toLowerCase/d' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
echo
echo
TIME g "更新源和安装常用软件"
echo
echo
apt-get update && apt-get install -y lrzsz net-tools curl screen uuid-runtime git
echo
echo
TIME g "更换DNS"
echo
echo
echo '
search com
nameserver 223.5.5.5
nameserver 114.114.114.114
' > /etc/resolv.conf
sed -i '1d' /etc/resolv.conf
rm -fr /root/pvekclean
echo
echo
TIME g "重启PVE，需要几分钟时间，请耐心等候..."
echo
echo
rm -fr /root/pvehy.sh
reboot
