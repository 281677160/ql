#!/usr/bin/env bash

echo "yilai" > /ql/yilai.log

if [[ `grep -c "001" /ql/yilai.log` = '0' ]]; then
  apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
  if [[ $? == 0 ]];then
    echo -e "\n001" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "002" /ql/yilai.log` = '0' ]]; then
  cd /ql && cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i && npm i -S ts-node typescript @types/node date-fns axios png-js canvas --build-from-source
  if [[ $? == 0 ]];then
    echo -e "\n002" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "003" /ql/yilai.log` = '0' ]]; then
  cd /ql && npm install -g typescript
  if [[ $? == 0 ]];then
    echo -e "\n003" >> /ql/yilai.log
    cd /ql
  fi
fi

if [[ `grep -c "004" /ql/yilai.log` = '0' ]]; then
  cd /ql && npm install axios date-fns
  if [[ $? == 0 ]];then
    echo -e "\n004" >> /ql/yilai.log
    cd /ql
  fi
fi

if [[ `grep -c "005" /ql/yilai.log` = '0' ]]; then
  cd /ql && npm install crypto -g
  if [[ $? == 0 ]];then
    echo -e "\n005" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "006" /ql/yilai.log` = '0' ]]; then
  cd /ql && npm install jsdom
  if [[ $? == 0 ]];then
    echo -e "\n006" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "007" /ql/yilai.log` = '0' ]]; then
  cd /ql && npm install png-js
  if [[ $? == 0 ]];then
    echo -e "\n007" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "008" /ql/yilai.log` = '0' ]]; then
  cd /ql && npm install -g npm
  if [[ $? == 0 ]];then
    echo -e "\n008" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "009" /ql/yilai.log` = '0' ]]; then
  cd /ql && pnpm i png-js
  if [[ $? == 0 ]];then
    echo -e "\n009" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "010" /ql/yilai.log` = '0' ]]; then
  cd /ql && pip3 install requests
  if [[ $? == 0 ]];then
    echo -e "\n010" >> /ql/yilai.log
  fi
fi

if [[ `grep -c "011" /ql/yilai.log` = '0' ]]; then
  cd /ql && apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
  if [[ $? == 0 ]];then
    echo -e "\n011" >> /ql/yilai.log
  fi
fi


if [[ `grep -c "012" /ql/yilai.log` = '0' ]]; then
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
fi


