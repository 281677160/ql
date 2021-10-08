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

TIME l "安装青龙脚本依赖"
echo
TIME y "最好使用翻墙网络来安装，或者更换虚拟机的源，要不然安装依赖的时候你会急死的"
echo
TIME g "没翻墙条件的话，也不更换源的话，安装依赖太慢就换时间安装，我测试过不同时段有不同效果"
echo
TIME y "依赖安装时看到显示ERR!错误提示不用管，只要依赖能从头到尾的下载运行完毕就好了"
echo
TIME g "如果安装太慢，而想换时间安装的话，按键盘的 Ctrl+C 退出就行了，到时候可以使用我的一键独立安装依赖脚本来安装"
echo
rm -rf npm.sh
cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i && npm i -S ts-node typescript @types/node date-fns axios png-js canvas --build-from-source
cd /ql
npm install -g typescript
cd /ql
npm install axios date-fns
cd /ql
npm install crypto -g
cd /ql
npm install jsdom
cd /ql
npm install png-js
cd /ql
npm install -g npm
cd /ql
pnpm i png-js
cd /ql
pip3 install requests
cd /ql
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
cd /ql
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
cd /ql
package_name="canvas png-js date-fns axios crypto-js ts-md5 tslib @types/node dotenv typescript fs require tslib"
for i in $package_name; do
    case $i in
        canvas)
            cd /ql/scripts
            npm ls $i
            ;;
        *)
            npm ls $i -g
            ;;
    esac
done
echo
TIME g "所有依赖安装完毕"
echo
exit 0
