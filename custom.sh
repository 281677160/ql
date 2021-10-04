#!/usr/bin/env bash
# 
## 本脚本搬运并模仿 liuqitoday
# 

dir_shell=/ql/config
dir_script=/ql/scripts
config_shell_path=$dir_shell/config.sh
extra_shell_path=$dir_shell/extra.sh
code_shell_path=$dir_shell/code.sh
task_before_shell_path=$dir_shell/task_before.sh
sample_shell_path=/ql/sample/config.sample.sh

docker exec -it qinglong  /bin/bash

# 下载 config.sh
if [ ! -a "$config_shell_path" ]; then
    touch $config_shell_path
fi
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/shell/config.sample.sh > $sample_shell_path
cp $sample_shell_path $config_shell_path

# 判断是否下载成功
config_size=$(ls -l $config_shell_path | awk '{print $5}')
if (( $(echo "${config_size} < 100" | bc -l) )); then
    echo "config.sh 下载失败"
    exit 0
fi

curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/shell/disableDuplicateTasksImplement.py > /ql/scripts/disableDuplicateTasksImplement.py
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/shell/wskey.py > /ql/scripts/wskey.py

# 下载 extra.sh
if [ ! -a "$extra_shell_path" ]; then
    touch $extra_shell_path
fi
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/shell/extra.sh > $extra_shell_path
cp $extra_shell_path $dir_shell/extra.sh

# 判断是否下载成功
extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
if (( $(echo "${extra_size} < 100" | bc -l) )); then
    echo "extra.sh 下载失败"
    exit 0
fi

# 授权
chmod 755 $extra_shell_path

# extra.sh 预设仓库及默认拉取仓库设置
defaultNum=${defaultNum:-'1'}
sed -i "s/CollectedRepo=(1)/CollectedRepo=($defaultNum)/g" $extra_shell_path

# 将 extra.sh 添加到定时任务
if [ "$(grep -c extra /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task ql extra"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"初始化任务","command":"ql extra","schedule":"15 0-23/8 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1624782068473'
fi


# 下载 code.sh
if [ ! -a "$code_shell_path" ]; then
    touch $code_shell_path
fi
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/xtoys/Scripts/main/dragon/shell/code.sh > $code_shell_path
cp $code_shell_path $dir_shell/code.sh

# 判断是否下载成功
code_size=$(ls -l $code_shell_path | awk '{print $5}')
if (( $(echo "${code_size} < 100" | bc -l) )); then
    echo "code.sh 下载失败"
    exit 0
fi

# 授权
chmod 755 $code_shell_path

# code.sh 预设仓库及默认调用仓库设置
repoNum=${repoNum:-'1'}
sed -i "s/\$repo1/\$repo$repoNum/g" $code_shell_path

# 将 code.sh 添加到定时任务
if [ "$(grep -c code.sh /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task code.sh"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"格式化更新助力码","command":"task /ql/config/code.sh &","schedule":"20 * * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247939659'
fi


# 下载 task_before.sh
curl -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/shell/task_before.sh > $task_before_shell_path

# 判断是否下载成功
task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
if (( $(echo "${task_before_size} < 100" | bc -l) )); then
    echo "task_before.sh 下载失败"
    exit 0
fi

# 将 bot 添加到定时任务
if [ "$(grep -c bot /ql/config/crontab.list)" = 0 ]; then
    echo "开始添加 task ql bot"
    # 获取token
    token=$(cat /ql/config/auth.json | jq --raw-output .token)
    curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"拉取机器人","command":"ql bot","schedule":"13 14 * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1626247933219'
fi

pip3 install requests
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
cd /ql
npm install png-js -S
npm install date-fns -S
npm install axios -S
npm install crypto-js -S
npm install ts-md5 -S
npm install tslib -S
npm install @types/node -S
cd scripts && pnpm install jsdom
cd /ql

if [ "$(grep -c wskey.py /ql/scripts/wskey.py)" = 1 ]; then
    task /ql/scripts/wskey.py
fi

if [ "$(grep -c extra.sh /ql/config/extra.sh)" = 1 ]; then
    ql extra
fi







echo "所有任务安装完毕"
