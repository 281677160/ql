#!/usr/bin/env bash

if [[ `grep -c "01" /ql/yilai.log` = '0' ]]; then
  cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i && npm i -S ts-node typescript @types/node date-fns axios png-js canvas --build-from-source
  if [[ $? == 0 ]];then
    echo -e "01" >> /ql/yilai.log
    cd /ql
  fi
fi


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
