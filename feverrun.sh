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
chmod +x /ql/repo/ghproxy.sh && source /ql/repo/ghproxy.sh
rm -rf /ql/repo/ghproxy.sh
mkdir -p /ql/qlwj
echo
TIME l "拉取crypto-js.js"
curl -fsSL ${curlurl}/feverrun/crypto-js.js > /ql/qlwj/crypto-js.js
TIME l "拉取config.sample.sh"
curl -fsSL ${curlurl}/feverrun/config.sample.sh > /ql/qlwj/config.sample.sh
TIME l "拉取extra.sh"
curl -fsSL ${curlurl}/feverrun/extra.sh > /ql/qlwj/extra.sh
TIME l "拉取jd_OpenCard.py"
curl -fsSL ${curlurl}/feverrun/raw_jd_OpenCard.py > /ql/qlwj/raw_jd_OpenCard.py
TIME l "拉取wskey.py"
curl -fsSL ${curlurl}/feverrun/wskey.py > /ql/qlwj/wskey.py
chmod -R +x /ql/qlwj
cp -Rf /ql/qlwj/config.sample.sh /ql/config/config.sh
cp -Rf /ql/qlwj/config.sample.sh /ql/sample/config.sample.sh
cp -Rf /ql/qlwj/extra.sh /ql/config/extra.sh
cp -Rf /ql/qlwj/extra.sh /ql/sample/extra.sample.sh
cp -Rf /ql/qlwj/raw_jd_OpenCard.py /ql/scripts/raw_jd_OpenCard.py
cp -Rf /ql/qlwj/wskey.py /ql/scripts/wskey.py
cp -Rf /ql/qlwj/crypto-js.js /ql/scripts/crypto-js.js
echo
# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra /ql/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [每4小时更新任务]"
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每4小时更新任务","command":"ql extra","schedule":"40 0-23/3 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi
sleep 1
echo
if [ "$(grep -c wskey.py /ql/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [每6小时转换WSKEY]"
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每6小时转换WSKEY","command":"task wskey.py","schedule":"58 0-23/5 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1633428022377'
fi
sleep 1
echo
# 将 bot 添加到定时任务
if [ "$(grep -c bot /ql/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [拉取机器人]"
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * 0"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
fi
sleep 1
echo
# 将 raw_jd_OpenCard.py 添加到定时任务
if [ "$(grep -c raw_jd_OpenCard.py /ql/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [JD入会开卡领取京豆]"
    echo
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"JD入会开卡领取京豆","command":"task raw_jd_OpenCard.py","schedule":"8 8,15,20 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1634041221437'
fi
task wskey.py
echo
TIME y "拉取feverrun大佬的自动提交助力码脚本（要找库的作者过白名单）"
echo
rm -fr /ql/azcg.log
ql extra |tee azcg.log
if [[ `ls -a |grep -c "成功" /ql/azcg.log` -ge '1' ]]; then
	rm -fr /ql/azcg.log
else
	TIME r "脚本安装失败,请再次执行一键安装脚本尝试安装"
	rm -fr /ql/azcg.log
	echo "Error" > /ql/config/Error
fi
exit 0
