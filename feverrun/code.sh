
#!/usr/bin/env bash

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx
## 安装python依赖使用 pip3 install xxx

if [ -z "$(ls -A "/ql/yilai.log" 2>/dev/null)" ]; then
    echo "yilai" > /ql/yilai.log
fi


if [[ `grep -c "002" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装002依赖中.."
  cd /ql && cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i && npm i -S ts-node typescript @types/node date-fns axios png-js canvas --build-from-source
  if [[ $? == 0 ]];then
    echo -e "\n002" >> /ql/yilai.log
  fi
else
    echo -e "002依赖已安装"
fi


if [[ `grep -c "003" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装003依赖中.."
  cd /ql && npm install -g typescript
  if [[ $? == 0 ]];then
    echo -e "\n003" >> /ql/yilai.log
    cd /ql
  fi
else
    echo -e "003依赖已安装"
fi


if [[ `grep -c "004" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装004依赖中.."
  cd /ql && npm install axios date-fns
  if [[ $? == 0 ]];then
    echo -e "\n004" >> /ql/yilai.log
    cd /ql
  fi
else
    echo -e "004依赖已安装"
fi


if [[ `grep -c "005" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装005依赖中.."
  cd /ql && npm install crypto -g
  if [[ $? == 0 ]];then
    echo -e "\n005" >> /ql/yilai.log
  fi
else
    echo -e "005依赖已安装"
fi


if [[ `grep -c "006" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装006依赖中.."
  cd /ql && npm install jsdom
  if [[ $? == 0 ]];then
    echo -e "\n006" >> /ql/yilai.log
  fi
else
    echo -e "006依赖已安装"
fi


if [[ `grep -c "007" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装007依赖中.."
  cd /ql && npm install png-js
  if [[ $? == 0 ]];then
    echo -e "\n007" >> /ql/yilai.log
  fi
else
    echo -e "007依赖已安装"
fi


if [[ `grep -c "008" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装008依赖中.."
  cd /ql && npm install -g npm
  if [[ $? == 0 ]];then
    echo -e "\n008" >> /ql/yilai.log
  fi
else
    echo -e "008依赖已安装"
fi


if [[ `grep -c "009" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装009依赖中.."
  cd /ql && pnpm i png-js
  if [[ $? == 0 ]];then
    echo -e "\n009" >> /ql/yilai.log
  fi
else
    echo -e "009依赖已安装"
fi


if [[ `grep -c "010" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装010依赖中.."
  cd /ql && pip3 install requests
  if [[ $? == 0 ]];then
    echo -e "\n010" >> /ql/yilai.log
  fi
else
    echo -e "010依赖已安装"
fi

if [[ `grep -c "001" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装001依赖中.."
    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
  if [[ $? == 0 ]];then
    echo -e "\n001" >> /ql/yilai.log
  fi
else
    echo -e "001依赖已安装"
fi

if [[ `grep -c "011" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装011依赖中.."
  cd /ql && apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
  if [[ $? == 0 ]];then
    echo -e "\n011" >> /ql/yilai.log
  fi
else
    echo -e "011依赖已安装"
fi



if [[ `grep -c "012" /ql/yilai.log` = '0' ]]; then
    echo -e "正在安装012依赖中.."
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
  if [[ $? == 0 ]];then
    echo -e "\n012" >> /ql/yilai.log
  fi
else
    echo -e "012依赖已安装"
fi
