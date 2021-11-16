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
TIME l "安装依赖pnpm"
pnpm i
TIME y "安装依赖pnpm"
pnpm updated
TIME l "更改pnpm源"
pnpm config set registry https://registry.npm.taobao.org/
pnpm config get registry
TIME l "安装依赖png-js"
pnpm i png-js
TIME l "安装依赖date-fns"
pnpm i date-fns
TIME l "安装依赖axios"
pnpm i axios
TIME l "安装依赖crypto-js"
pnpm i crypto-js
TIME l "安装依赖md5"
pnpm i md5
TIME l "安装依赖ts-md5"
pnpm i ts-md5
TIME l "安装依赖tslib"
pnpm i tslib
TIME l "安装依赖@types/node"
pnpm i @types/node
TIME l "安装依赖requests"
pnpm i requests
TIME l "安装依赖tough-cookie"
pnpm i tough-cookie
TIME l "安装依赖jsdom"
pnpm i jsdom
TIME l "安装依赖download"
pnpm i download
TIME l "安装依赖tunnel"
pnpm i tunnel
TIME l "安装依赖fs"
pnpm i fs
TIME l "安装依赖ws"
pnpm i ws
TIME l "安装依赖js-base64"
pnpm i js-base64
TIME l "安装依赖jieba"
pnpm i jieba
TIME l "安装依赖ts-node"
pnpm i ts-node
TIME l "安装依赖typescript"
pnpm i typescript
TIME l "安装依赖canvas"
pnpm i canvas
cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev
cd /ql
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
cd /ql
echo
TIME g "依赖安装完毕..."
echo
exit 0
