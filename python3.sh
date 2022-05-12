#!/usr/bin/env bash
#
echo -e "\033[32;1m 开始安装程序 \033[0m"
echo
cd /ql/data/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev
cd /ql
apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev
cd /ql
python3 -m pip install --upgrade telethon
cd /ql
