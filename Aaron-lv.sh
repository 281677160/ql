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

mkdir -p /ql/data/scripts/utils
curl -fsSL ${curlurl}/Aaron-lv/utils/jd_jxmc.js > /ql/data/scripts/utils/jd_jxmc.js
curl -fsSL ${curlurl}/Aaron-lv/utils/jd_jxmcToken.js > /ql/data/scripts/utils/jd_jxmcToken.js
curl -fsSL ${curlurl}/Aaron-lv/jd_cfd_sharecodes.ts > /ql/data/scripts/jd_cfd_sharecodes.ts
curl -fsSL ${curlurl}/Aaron-lv/jd_jxmc_sharecodes.ts > /ql/data/scripts/jd_jxmc_sharecodes.ts
curl -fsSL ${curlurl}/Aaron-lv/TS_USER_AGENTS.ts > /ql/data/scripts/TS_USER_AGENTS.ts

TIME l "拉取crypto-js.js"
curl -fsSL ${curlurl}/Aaron-lv/crypto-js.js > /ql/data/qlwj/crypto-js.js
TIME l "拉取config.sample.sh"
curl -fsSL ${curlurl}/Aaron-lv/config.sample.sh > /ql/data/qlwj/config.sample.sh
TIME l "拉取extra.sh"
curl -fsSL ${curlurl}/Aaron-lv/extra.sh > /ql/data/qlwj/extra.sh
TIME l "拉取disableDuplicateTasksImplement.py"
curl -fsSL ${curlurl}/Aaron-lv/disableDuplicateTasksImplement.py > /ql/data/qlwj/disableDuplicateTasksImplement.py
TIME l "拉取jd_get_share_code.js"
curl -fsSL ${curlurl}/Aaron-lv/jd_get_share_code.js > /ql/data/qlwj/jd_get_share_code.js
TIME l "拉取jdCookie.js"
curl -fsSL ${curlurl}/Aaron-lv/jdCookie.js > /ql/data/qlwj/jdCookie.js
TIME l "拉取jd_cleancartAll.js"
curl -fsSL ${curlurl}/Aaron-lv/jd_cleancartAll.js > /ql/data/qlwj/jd_cleancartAll.js
TIME l "拉取1-5.sh"
curl -fsSL ${curlurl}/Aaron-lv/jd/1-5.sh > /ql/data/jd/1-5.sh
TIME l "拉取6-10.sh"
curl -fsSL ${curlurl}/Aaron-lv/jd/6-10.sh > /ql/data/jd/6-10.sh
chmod -R +x /ql/data/qlwj
cp -Rf /ql/data/qlwj/config.sample.sh /ql/data/config/config.sh
cp -Rf /ql/data/qlwj/config.sample.sh /ql/sample/config.sample.sh
cp -Rf /ql/data/qlwj/extra.sh /ql/data/config/extra.sh
cp -Rf /ql/data/qlwj/extra.sh /ql/sample/extra.sample.sh
cp -Rf /ql/data/qlwj/disableDuplicateTasksImplement.py /ql/data/scripts/disableDuplicateTasksImplement.py
cp -Rf /ql/data/qlwj/jd_get_share_code.js /ql/data/scripts/jd_get_share_code.js
cp -Rf /ql/data/qlwj/jdCookie.js /ql/data/scripts/jdCookie.js
cp -Rf /ql/data/qlwj/jd_cleancartAll.js /ql/data/scripts/jd_cleancartAll.js
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
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"30 11 * * 6"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
fi
sleep 1
echo
# 将 jd_get_share_code.js 添加到定时任务
if [ "$(grep -c jd_get_share_code.js /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [获取助力码]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"获取助力码","command":"task jd_get_share_code.js","schedule":"20 13 * * 6"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1637505495835'
fi
sleep 1
echo
# 将 jd_jxmc_sharecodes.ts 添加到定时任务
if [ "$(grep -c jd_jxmc_sharecodes.ts /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [京喜牧场上车]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"京喜牧场上车","command":"task jd_jxmc_sharecodes.ts","schedule":"1 0 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1639071292827'
fi
sleep 1
echo
# 将 jd_cfd_sharecodes.ts 添加到定时任务
if [ "$(grep -c jd_cfd_sharecodes.ts /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [京喜财富岛上车]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"京喜财富岛上车","command":"task jd_cfd_sharecodes.ts","schedule":"10 0,12,18 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1639071050874'
fi
sleep 1
echo
# 将 jd_cleancartAll.js 添加到定时任务
if [ "$(grep -c jd_cleancartAll.js /ql/data/config/crontab.list)" = 0 ]; then
    echo
    TIME g "添加任务 [清空购物车]"
    echo
    # 获取token
    token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"清空购物车","command":"task jd_cleancartAll.js","schedule":"3 6,12,23 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1639110553549'
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
TIME y "拉取okyyds和JDHelloWorld两个大佬的脚本（用TG机器人每周提交助力码）"
echo
echo
rm -fr /ql/azcg.log
ql extra |tee /ql/azcg.log
TIME y "拉取机器人"
ql bot
if [[ `ls -a |grep -c "成功" /ql/azcg.log` -ge '1' ]]; then
	rm -fr /ql/azcg.log
else
	TIME r "脚本安装失败,请再次执行一键安装脚本尝试安装，或看看青龙面板有没有[每x小时更新任务]，有的话执行这个拉取任务试试"
	rm -fr /ql/azcg.log
	echo "Error" > /ql/data/config/Error
fi
exit 0
