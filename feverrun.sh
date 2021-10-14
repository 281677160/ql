#!/usr/bin/env bash
# 
## 本脚本搬运并模仿 liuqitoday
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
if [ "$(grep -c \"token\" /ql/config/auth.json)" = 0 ]; then
	echo
	TIME r "提示：请先登录青龙面板再执行命令安装任务!"
	echo
	exit 1
fi
dir_shell=/ql/config
dir_script=/ql/scripts
config_shell_path=$dir_shell/config.sh
extra_shell_path=$dir_shell/extra.sh
code_shell_path=$dir_shell/code.sh
disable_shell_path=$dir_script/disableDuplicateTasksImplement.py
wskey_shell_path=$dir_script/wskey.py
crypto_shell_path=$dir_script/crypto-js.js
wx_jysz_shell_path=$dir_script/wx_jysz.js
OpenCard_shell_path=$dir_script/raw_jd_OpenCard.py
task_before_shell_path=$dir_shell/task_before.sh
sample_shell_path=/ql/sample/config.sample.sh
rm -fr /ql/repo/feverrun_my_scripts
wget -qO sendNotify.js https://ghproxy.com/https://raw.githubusercontent.com/shufflewzc/faker2/main/sendNotify.js
wget -qO sendNotify.py https://ghproxy.com/https://raw.githubusercontent.com/shufflewzc/faker2/main/sendNotify.py
git clone https://ghproxy.com/https://github.com/281677160/ql qlwj
if [[ $? -ne 0 ]];then
	mkdir -p /ql/qlwj
	curl -fsSL https://cdn.jsdelivr.net/gh/shufflewzc/faker2@main/sendNotify.js > /ql/sendNotify.js
	curl -fsSL https://cdn.jsdelivr.net/gh/shufflewzc/faker2@main/sendNotify.py > /ql/sendNotify.py
	curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/wx_jysz.js > /ql/qlwj/wx_jysz.js
	curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/crypto-js.js > /ql/qlwj/crypto-js.js
	curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/config.sample.sh > /ql/qlwj/config.sample.sh
	curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/extra.sh > /ql/qlwj/extra.sh
	curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/raw_jd_OpenCard.py > /ql/qlwj/raw_jd_OpenCard.py
	curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/wskey.py > /ql/qlwj/wskey.py
	if [[ $? -ne 0 ]];then
		TIME y "应用文件下载失败"
		    exit 1
	fi
fi

# 授权
chmod -R +x /ql/qlwj

cp -Rf /ql/qlwj/feverrun/config.sample.sh /ql/config/config.sh
cp -Rf /ql/qlwj/feverrun/config.sample.sh /ql/sample/config.sample.sh
cp -Rf /ql/qlwj/feverrun/extra.sh /ql/config/extra.sh
cp -Rf /ql/qlwj/feverrun/raw_jd_OpenCard.py /ql/scripts/raw_jd_OpenCard.py
cp -Rf /ql/qlwj/feverrun/wskey.py /ql/scripts/wskey.py
cp -Rf /ql/qlwj/feverrun/wx_jysz.js /ql/scripts/wx_jysz.js
cp -Rf /ql/qlwj/feverrun/crypto-js.js /ql/scripts/crypto-js.js

# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加 [每8小时更新任务]"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每8小时更新任务","command":"ql extra","schedule":"* */8 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi

if [ "$(grep -c wskey.py /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加 [每8小时检测WSKEY]"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每8小时检测WSKEY","command":"task wskey.py","schedule":"* */8 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1633428022377'
fi

# 将 bot 添加到定时任务
if [ "$(grep -c bot /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加 [拉取机器人]"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
fi

# 将 raw_jd_OpenCard.py 添加到定时任务
if [ "$(grep -c raw_jd_OpenCard.py /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加 [JD入会开卡领取京豆]"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"JD入会开卡领取京豆","command":"task raw_jd_OpenCard.py","schedule":"8 8,15,20 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1634041221437'
fi

# 将 wx_jysz.js 添加到定时任务
if [ "$(grep -c wx_jysz.js /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加 [微信_金银手指]"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"微信_金银手指","command":"task wx_jysz.js","schedule":"0 8-22/1 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1634097051985'
fi

pip3 install requests

if [[ "$(grep -c JD_WSCK=\"pin= /ql/config/env.sh)" = 1 ]]; then
    echo
    TIME g "执行WSKEY转换PT_KEY操作"
    task wskey.py |tee azcg.log
    echo
    if [[ `ls -a |grep -c "wskey添加成功" /ql/azcg.log` -ge '1' ]] && [[ `ls -a |grep -c "wskey添加失败" /ql/azcg.log` = '0' ]]; then
    	echo
    	TIME g "WSKEY转换PT_KEY成功"
	echo
    else
    	echo
    	TIME g "WSKEY转换PT_KEY失败，检查KEY的格式对不对，或者有没有失效，如果是多个WSKEY的话，或者有个别KEY出问题"
	echo
    fi
fi
rm -fr /ql/azcg.log
ql extra |tee azcg.log
cp -Rf /ql/sendNotify.js /ql/scripts/sendNotify.js
cp -Rf /ql/sendNotify.py /ql/scripts/sendNotify.py
rm -rf /ql/sendNotify.js
rm -rf /ql/sendNotify.py
rm -rf /ql/qlwj

echo
if [[ "$(grep -c JD_WSCK=\"pin= /ql/config/env.sh)" = 0 ]] && [[ "$(grep -c JD_COOKIE=\"pt_key= /ql/config/env.sh)" = 0 ]]; then
    TIME y "没发现WSKEY或者PT_KEY，请注意设置好KEY，要不然脚本不会运行!"
fi
echo
echo
if [[ `ls -a |grep -c "添加成功" /ql/azcg.log` -ge '1' ]] && [[ `ls -a |grep -c "执行结束" /ql/azcg.log` -ge '1' ]]; then
	TIME g "脚本安装完成，下面开始安装依赖!"
	rm -fr /ql/azcg.log
else
	TIME r "脚本安装失败，请用一键单独安装任务重新尝试!"
	rm -fr /ql/azcg.log
	exit 1
fi
echo
echo
echo
echo
TIME l "安装依赖，依赖必须安装，要不然脚本不运行"
echo
TIME y "建议使用翻墙网络安装，要不然安装依赖的时候你会急死的"
echo
TIME g "没翻墙条件，安装依赖太慢就换时间安装，我测试过不同时段有不同效果"
echo
TIME y "依赖安装时看到显示ERR!错误提示不用管，只要依赖能从头到尾的下载运行完毕就好了"
echo
TIME g "如果安装太慢，而想换时间安装的话，按键盘的 Ctrl+C 退出就行了，到时候可以使用我的一键独立安装依赖脚本来安装"
echo
sleep 5
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
TIME g "所有依赖安装完毕"
exit 0
