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
pip3 install requests
pnpm install
npm config set registry https://mirrors.huaweicloud.com/repository/npm/
npm config get registry
TIME l "安装依赖png-js"
pnpm install png-js
TIME l "安装依赖date-fns"
pnpm install date-fns
TIME l "安装依赖axios"
pnpm install axios
TIME l "安装依赖crypto-js"
pnpm install crypto-js
TIME l "安装依赖md5"
pnpm install md5
TIME l "安装依赖ts-md5"
pnpm install ts-md5
TIME l "安装依赖tslib"
pnpm install tslib
TIME l "安装依赖@types/node"
pnpm install @types/node
TIME l "安装依赖requests"
pnpm install requests
TIME l "安装依赖tough-cookie"
pnpm install tough-cookie
TIME l "安装依赖jsdom"
pnpm install jsdom
TIME l "安装依赖download"
pnpm install download
TIME l "安装依赖tunnel"
pnpm install tunnel
TIME l "安装依赖fs"
pnpm install fs
TIME l "安装依赖ws"
pnpm install ws
TIME l "安装依赖js-base64"
pnpm install js-base64
TIME l "安装依赖jieba"
pnpm install jieba
TIME l "安装依赖ts-node"
pnpm install ts-node
TIME l "安装依赖typescript"
pnpm install typescript
TIME l "安装依赖canvas"
pnpm install canvas
cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev
cd /ql
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
cd /ql
echo
TIME g "依赖安装完毕..."
echo
exit 0
