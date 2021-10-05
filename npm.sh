#!/usr/bin/env bash
#
echo "456安装依赖，所需时间比较长，请耐心等待..."
rm -rf npm.sh
npm install -g typescript
npm install axios date-fns
npm install crypto -g
npm install jsdom
npm install png-js
npm install -g npm
pnpm i png-js
pip3 install requests
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i && npm i -S ts-node typescript @types/node date-fns axios png-js canvas --build-from-source

echo "所有依赖安装完毕"
