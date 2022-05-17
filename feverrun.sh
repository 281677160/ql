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
if [ "$(grep -c \"token\" /ql/data/config/auth.json)" = 0 ]; then
	echo
	TIME r "提示：请先登录青龙面板再执行命令安装任务!"
	echo
	exit 1
fi
dir_shell=/ql/data/config
dir_script=/ql/data/scripts
config_shell_path=$dir_shell/config.sh
extra_shell_path=$dir_shell/extra.sh
code_shell_path=$dir_shell/code.sh
disable_shell_path=$dir_script/disableDuplicateTasksImplement.py
wskey_shell_path=$dir_script/wskey.py
crypto_shell_path=$dir_script/crypto-js.js
wx_jysz_shell_path=$dir_script/wx_jysz.js
OpenCard_shell_path=$dir_script/jd_OpenCard.py
task_before_shell_path=$dir_shell/task_before.sh
sample_shell_path=/ql/data/sample/config.sample.sh
chmod +x /ql/data/repo/ghproxy.sh && source /ql/data/repo/ghproxy.sh
rm -rf /ql/data/repo/ghproxy.sh
mkdir -p /ql/data/qlwj
echo
TIME l "拉取crypto-js.js"
curl -fsSL ${curlurl}/feverrun/crypto-js.js > /ql/data/qlwj/crypto-js.js
TIME l "拉取config.sample.sh"
curl -fsSL ${curlurl}/feverrun/config.sample.sh > /ql/data/qlwj/config.sample.sh
TIME l "拉取extra.sh"
curl -fsSL ${curlurl}/feverrun/extra.sh > /ql/data/qlwj/extra.sh
chmod -R +x /ql/data/qlwj
cp -Rf /ql/data/qlwj/config.sample.sh /ql/data/config/config.sh
cp -Rf /ql/data/qlwj/config.sample.sh /ql/sample/config.sample.sh
cp -Rf /ql/data/qlwj/extra.sh /ql/data/config/extra.sh
cp -Rf /ql/data/qlwj/extra.sh /ql/sample/extra.sample.sh
cp -Rf /ql/data/qlwj/wskey.py /ql/data/scripts/wskey.py
cp -Rf /ql/data/qlwj/crypto-js.js /ql/data/scripts/crypto-js.js
echo
# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [每1小时更新任务]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每1小时更新任务","command":"ql extra","schedule":"1 0-23/1 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi
sleep 1
echo
if [ "$(grep -c wskey.py /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [每6小时转换WSKEY]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每6小时转换WSKEY","command":"task Zy143L_wskey/wskey.py","schedule":"58 0-23/5 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1633428022377'
fi
sleep 1
echo
# 将 bot 添加到定时任务
if [ "$(grep -c bot /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [拉取机器人]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * 0"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
fi
sleep 1
echo
# 将 7天删除日志 添加到定时任务
if [ "$(grep -c rmlog /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [每隔7天删除日志]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每隔7天删除日志","command":"ql rmlog 7","schedule":"0 2 */7 * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1640581005650'
fi
ql repo https://github.com/Zy143L/wskey.git
if [[ "$(grep -c JD_WSCK=\"pin= /ql/data/config/env.sh)" = 1 ]]; then
  task /ql/data/scripts/Zy143L_wskey
fi
echo
TIME y "拉取feverrun大佬的自动提交助力码脚本（要找库的作者过白名单）"
echo
rm -fr /ql/azcg.log
ql extra |tee azcg.log
if [[ `ls -a |grep -c "成功" /ql/azcg.log` -ge '1' ]]; then
	rm -fr /ql/azcg.log
else
	TIME r "脚本安装失败,请再次执行一键安装脚本尝试安装，或看看青龙面板有没有[每x小时更新任务]，有的话执行这个拉取任务试试"
	rm -fr /ql/azcg.log
	echo "Error" > /ql/data/config/Error
fi
exit 0
