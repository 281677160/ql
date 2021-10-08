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


dir_shell=/ql/config
dir_script=/ql/scripts
config_shell_path=$dir_shell/config.sh
extra_shell_path=$dir_shell/extra.sh
code_shell_path=$dir_shell/code.sh
disable_shell_path=$dir_script/disableDuplicateTasksImplement.py
wskey_shell_path=$dir_script/wskey.py
task_before_shell_path=$dir_shell/task_before.sh
sample_shell_path=/ql/sample/config.sample.sh

rm -rf feverrun.sh

# 下载 config.sh
if [ ! -a "$config_shell_path" ]; then
    touch $config_shell_path
fi
curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/config.sample.sh > $sample_shell_path
curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun/config.sample.sh > $sample_shell_path
cp $sample_shell_path $config_shell_path

# 判断是否下载成功
config_size=$(ls -l $config_shell_path | awk '{print $5}')
if (( $(echo "${config_size} < 100" | bc -l) )); then
    echo
    TIME y "config.sh 下载失败"
    exit 0
fi


# 下载 wskey.py
if [ ! -a "$wskey_shell_path" ]; then
    touch $wskey_shell_path
fi
curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/wskey.py > $wskey_shell_path
curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun/wskey.py > $wskey_shell_path
cp $wskey_shell_path $dir_script/wskey.py

# 判断是否下载成功
wskey_size=$(ls -l $wskey_shell_path | awk '{print $5}')
if (( $(echo "${wskey_size} < 100" | bc -l) )); then
    echo
    TIME y "wskey.py 下载失败"
    exit 0
fi

# 下载 extra.sh
if [ ! -a "$extra_shell_path" ]; then
    touch $extra_shell_path
fi
curl -fsSL https://cdn.jsdelivr.net/gh/281677160/ql@main/feverrun/extra.sh > $extra_shell_path
curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun/extra.sh > $extra_shell_path
cp $extra_shell_path $dir_shell/extra.sh

# 判断是否下载成功
extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
if (( $(echo "${extra_size} < 100" | bc -l) )); then
    echo
    TIME y "extra.sh 下载失败"
    exit 0
fi

# 授权
chmod -R +x $dir_shell

# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加任务 ql extra"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每8小时更新任务","command":"ql extra","schedule":"15 0-23/8 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi

if [ "$(grep -c wskey.py /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    TIME g "开始添加任务 task wskey.py"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每天检测WSKEY","command":"task wskey.py","schedule":"15 1 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1633428022377'
fi

# 将 bot 添加到定时任务
if [ "$(grep -c bot /ql/config/crontab.list)" = 0 ]; then
    echo
    echo
    echo "开始添加 ql bot"
    echo
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
fi

pip3 install requests

if [[ "$(grep -c JD_WSCK=\"pin= /ql/config/env.sh)" = 1 ]]; then
    echo
    TIME g "执行WSKEY转换PT_KEY操作"
    task wskey.py
    echo
    if [[ "$(grep -c JD_COOKIE=\"pt_key= /ql/config/env.sh)" = 1 ]]; then
    	echo
    	TIME g "WSKEY转换PT_KEY成功"
	echo
    else
    	echo
    	TIME g "WSKEY转换PT_KEY失败，检查KEY的格式对不对，或者有没有失效，然后在任务里手动转换"
	echo
    fi
fi

ql extra

echo
if [[ "$(grep -c JD_WSCK=\"pin= /ql/config/env.sh)" = 0 ]] && [[ "$(grep -c JD_COOKIE=\"pt_key= /ql/config/env.sh)" = 0 ]]; then
    TIME y "没发现WSKEY或者PT_KEY，请注意设置好KEY，要不然脚本不会运行!"
fi
echo
echo
TIME g "脚本安装完成，下面开始安装依赖!"
echo
echo
echo
echo
TIME l "安装依赖，依赖必须安装，要不然脚本不运行"
echo
TIME y "最好使用翻墙网络来安装，或者更换虚拟机的源，要不然安装依赖的时候你会急死的"
echo
TIME g "没翻墙条件，也不更换源的话，安装依赖太慢就换时间安装，我测试过不同时段有不同效果"
echo
TIME y "依赖安装时看到显示ERR!错误提示不用管，只要依赖能从头到尾的下载运行完毕就好了"
echo
TIME g "如果安装太慢，而想换时间安装的话，按键盘的 Ctrl+C 退出就行了，到时候可以使用我的一键独立安装依赖脚本来安装"
echo
sleep 15
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
