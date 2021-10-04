#!/usr/bin/env bash

#------ 说明区 ------#
## 1. 拉取仓库
## 定时任务→添加定时→命令【ql extra】→定时规则【15 0-23/8 * * *】→运行
## 2. 安装依赖
## 默认不安装，因为 code.sh 自动检查修复依赖

#------ 设置区 ------#
## 1. 拉取仓库编号设置，默认 shufflewzc 仓库
CollectedRepo=(1) ##示例：CollectedRepo=(1 2)
OtherRepo=(1) ##示例：OtherRepo=(1 2)
## 2. 是否安装依赖和安装依赖包的名称设置
dependencies="r" ##yes为全部安装，no为不安装，p为安装package，r为安装requirement
package_name="@types/node axios canvas crypto-js date-fns dotenv fs jsdom png-js require ts-md5 tslib typescript"
requirement_name="cryptography~=3.2.1 json5 requests rsa"

#------ 编号区 ------#
:<<\EOF
一、集成仓库（Collected Repositories)
1-shufflewzc
2-JDHelloWorld
二、其他仓库（Other Repositories）
1-wskey
EOF

#------ 代码区 ------#
# 📝更新示例
## curl -s --connect-timeout 3 https://cdn.jsdelivr.net/gh/xtoys/Scripts@main/dragon/shell/config.sample.sh > /ql/sample/config.sample.sh

# 🌱拉取仓库
## Collected Repositories
CR1(){
    ql repo https://ghproxy.com/https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen|update|test" "^jd[^_]|USER|^TS|utils|notify|env|package|ken.js"
    ql repo https://ghproxy.com/https://github.com/shufflewzc/faker2.git "jd_|jx_|gua_|jddj_|getJDCookie" "activity|backUp" "^jd[^_]|USER|function|utils|ZooFaker_Necklace.js|JDJRValidator_Pure|sign_graphics_validate|ql|sendNotify"
    task /ql/scripts/disableDuplicateTasksImplement.py
}
for i in ${CollectedRepo[@]}; do
    CR$i
    sleep 10
done

## Other Repositories
OR1(){
    ql repo https://ghproxy.com/https://github.com/Zy143L/wskey.git "" "" "wskey.py"
}
for i in ${OtherRepo[@]}; do
    OR$i
    sleep 5
done

# 📦安装依赖
install_packages_normal(){
    for i in $@; do
        case $i in
            canvas)
                cd /ql/scripts
                if [[ "$(echo $(npm ls $i) | grep ERR)" != "" ]]; then
                    npm uninstall $i
                fi
                if [[ "$(npm ls $i)" =~ (empty) ]]; then
                    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i $i --prefix /ql/scripts --build-from-source
                fi
                ;;
            *)
                if [[ "$(npm ls $i)" =~ $i ]]; then
                    npm uninstall $i
                elif [[ "$(echo $(npm ls $i -g) | grep ERR)" != "" ]]; then
                    npm uninstall $i -g
                fi
                if [[ "$(npm ls $i -g)" =~ (empty) ]]; then
                    [[ $i = "typescript" ]] && npm i $i -g --force || npm i $i -g
                fi
                ;;
        esac
    done
}

install_packages_force(){
    for i in $@; do
        case $i in
            canvas)
                cd /ql/scripts
                if [[ "$(npm ls $i)" =~ $i && "$(echo $(npm ls $i) | grep ERR)" != "" ]]; then
                    npm uninstall $i
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                fi
                if [[ "$(npm ls $i)" =~ (empty) ]]; then
                    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i $i --prefix /ql/scripts --build-from-source --force
                fi
                ;;
            *)
                cd /ql/scripts
                if [[ "$(npm ls $i)" =~ $i ]]; then
                    npm uninstall $i
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                elif [[ "$(npm ls $i -g)" =~ $i && "$(echo $(npm ls $i -g) | grep ERR)" != "" ]]; then
                    npm uninstall $i -g
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                fi
                if [[ "$(npm ls $i -g)" =~ (empty) ]]; then
                    npm i $i -g --force
                fi
                ;;
        esac
    done
}

install_packages_all(){
    install_packages_normal $package_name
    for i in $package_name; do
        install_packages_force $i
    done
}

install_requirements(){
    for i in $requirement_name; do
        case $i in
            cryptography~=3.2.1)
                cd /ql/scripts
                if [[ "$(pip3 freeze)" =~ "cryptography==3.2.1" ]]; then
                    echo "cryptography==3.2.1 已安装"
                else
                    apk add --no-cache gcc libffi-dev musl-dev openssl-dev python3-dev && pip3 install cryptography~=3.2.1
                fi
                ;;
            *)
                if [[ "$(pip3 freeze)" =~ $i ]]; then
                    echo "$i 已安装"
                else
                    pip3 install $i
                fi
        esac
    done
}

case $dependencies in
    yes)
    install_packages_all &
    install_requirements &
    ;;
    p)
    install_packages_all &
    ;;
    r)
    install_requirements & 
    ;;   
esac
