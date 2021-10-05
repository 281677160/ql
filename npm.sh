#!/usr/bin/env bash
#
echo "安装依赖，所需时间比较长，请耐心等待..."

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

echo "所有依赖安装完毕"
