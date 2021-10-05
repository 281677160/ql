#!/usr/bin/env bash
# 
## 本脚本搬运并模仿 liuqitoday
# 

echo "开始运行安装脚本程序！"

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
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun/config.sample.sh > $sample_shell_path
cp $sample_shell_path $config_shell_path

# 判断是否下载成功
config_size=$(ls -l $config_shell_path | awk '{print $5}')
if (( $(echo "${config_size} < 100" | bc -l) )); then
    echo "config.sh 下载失败"
    exit 0
fi


# 下载 wskey.py
if [ ! -a "$wskey_shell_path" ]; then
    touch $wskey_shell_path
fi
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun/wskey.py > $wskey_shell_path
cp $wskey_shell_path $dir_script/wskey.py

# 判断是否下载成功
wskey_size=$(ls -l $wskey_shell_path | awk '{print $5}')
if (( $(echo "${wskey_size} < 100" | bc -l) )); then
    echo "wskey.py 下载失败"
    exit 0
fi

# 下载 extra.sh
if [ ! -a "$extra_shell_path" ]; then
    touch $extra_shell_path
fi
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun/extra.sh > $extra_shell_path
cp $extra_shell_path $dir_shell/extra.sh

# 判断是否下载成功
extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
if (( $(echo "${extra_size} < 100" | bc -l) )); then
    echo "extra.sh 下载失败"
    exit 0
fi

# 授权
chmod -R +x $dir_shell

# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task ql extra"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每8小时更新任务","command":"ql extra","schedule":"15 0-23/8 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi

if [ "$(grep -c wskey.py /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task wskey.py"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"每天检测WSKEY","command":"task wskey.py","schedule":"15 1 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1633428022377'
fi

pip3 install requests

if [ "$(grep -c JD_WSCK=\"pin= /ql/config/env.sh)" = 1 ]; then
    task wskey.py
fi

ql extra

echo "所有任务安装完毕"
