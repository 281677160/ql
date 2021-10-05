#!/usr/bin/env bash

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx
## 安装python依赖使用 pip3 install xxx

task wskey.py

ql repo https://github.com/feverrun/my_scripts.git "jd_|jx_|gua|jddj|getCookie|getJDCookie" "backUp" "^(jd|JD|JS)[^_]|USER|sendNotify|utils"

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
