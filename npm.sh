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
echo
echo
echo
TIME l "安装依赖..."
echo
TIME y "安装依赖需要时间，请耐心等待!"
echo
sleep 2
npm config set registry https://mirrors.huaweicloud.com/repository/npm/
npm config get registry
pnpm install
TIME l "安装依赖png-js"
npm install png-js
TIME l "安装依赖date-fns"
npm install date-fns
TIME l "安装依赖axios"
npm install axios
TIME l "安装依赖crypto-js"
npm install crypto-js
TIME l "安装依赖md5"
npm install md5
TIME l "安装依赖ts-md5"
npm install ts-md5
TIME l "安装依赖tslib"
npm install tslib
TIME l "安装依赖@types/node"
npm install @types/node
TIME l "安装依赖requests"
npm install requests
TIME l "安装依赖tough-cookie"
npm install tough-cookie
TIME l "安装依赖jsdom"
npm install jsdom
TIME l "安装依赖download"
npm install download
TIME l "安装依赖tunnel"
npm install tunnel
TIME l "安装依赖fs"
npm install fs
TIME l "安装依赖ws"
npm install ws
TIME l "安装依赖js-base64"
npm install js-base64
TIME l "安装依赖jieba"
npm install jieba
cd /ql
cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && pnpm install && pnpm install -S ts-node typescript @types/node date-fns axios png-js canvas
cd /ql
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
cd /ql
echo
TIME g "依赖安装完毕..."
echo
exit 0
