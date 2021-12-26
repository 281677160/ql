#!/usr/bin/env bash

## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx
## 安装python依赖使用 pip3 install xxx

## 拉取faker仓库
ql repo ${GithubProxyUrl}https://github.com/shufflewzc/faker2.git "jd_|jx_|gua_|jddj_|getJDCookie" "activity|backUp|jd_disable.py|jd_get_share_code.js|jd_clean_car.js|jd_jdfactory.js" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql"
## 拉取青蛙仓库
ql repo ${GithubProxyUrl}https://github.com/smiek2121/scripts.git "jd_|gua_" "gua_cleancart.js|gua_wealth_island_help.js|jd_sign_graphics.js|gua_ddworld.js|jd_joy_steal.js|jd_sendBeans.js|gua_wealth_island.js|jd_joy.js" "ZooFaker_Necklace.js|JDJRValidator_Pure.js|sign_graphics_validate.js|cleancart_activity.js|jdCookie.js|sendNotify.js"
## 拉取小小仓库（去掉下面代码的 ## 为开启）
## ql repo ${GithubProxyUrl}https://github.com/Aaron-lv/sync.git "jd_|jx_|getJDCookie" "activity|backUp|jd_get_share_code.js|getJDCookie.js|jd_bean_change.js|Coupon" "^jd[^_]|USER|utils|Notify" "jd_scripts"
## 拉取樱花仓库助力脚本
ql repo ${GithubProxyUrl}https://github.com/JDHelloWorld/jd_scripts.git "jd_fruit|jd_plantBean|jd_jdfactory|jd_dreamFactory|jd_pet|jd_health|jd_sgmh|jd_jxmc|jd_cfd|jd_88hb|jd_api_test" "activity|backUp|Coupon|enen|update|collect|game|shell|stock|getCoin|moreTask|jd_jxmc.js" "^jd[^_]|^USER|^TS|^JS|jdCookie|sendNotify|tools|utils|package|jd_validate_Worker"

## 禁用重复任务（去掉下面代码的 ## 为开启）
## task disableDuplicateTasksImplement.py
