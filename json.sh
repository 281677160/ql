#!/usr/bin/env bash
cat > ${Config}/Config.json << EOF
{
  ///最大支持几个网页
  "MaxTab": "4",
  //网站标题
  "Title": "${NVJDCNAME}",
  //网站公告
  "Announcement": "本项目脚本收集于互联网，为了您的财产安全，请关闭京东免密支付。",
  ///多青龙配置
  "Config": [
    {
      //序号必填从1 开始
      "QLkey": 1,
      //服务器名称
      "QLName": "${MANEID}",
      //青龙地址
      "QLurl": "${QLurl}",
      //青龙2,9 OpenApi Client ID
      "QL_CLIENTID": "${CLIENTID}",
      //青龙2,9 OpenApi Client Secret
      "QL_SECRET": "${CLIENTID_SECRET}",
      //CK最大数量
      "QL_CAPACITY": ${CAPACITY},
      //消息推送二维码
      "QRurl": ""
    }
  ]
}
EOF
