#!/usr/bin/env bash
cat > ${Config}/Config.json << EOF
{
  ///浏览器最多几个网页
  "MaxTab": "8",
  //回收时间分钟 不填默认3分钟
  "Closetime": "3",
  //网站标题
  "Title": "NolanJDCloud",
  //网站公告
  "Announcement": "本项目脚本收集于互联网。为了您的财产安全，请关闭京东免密支付。",
  ///XDD PLUS Url  http://IP地址:端口/api/login/smslogin
  "XDDurl": "",
  ///xddToken
  "XDDToken": "",
  "AutoCaptchaCount": "5",
  ///## 8. Push Plus官方网站：http: //www.pushplus.plus 
  ///下方填写您的Token，微信扫码登录后一对一推送或一对多推送下面的token，只填" "PUSH_PLUS_TOKEN",
  "PUSH_PLUS_TOKEN": "${PUSHPLUS}",
  //下方填写您的一对多推送的 "群组编码" ，（一对多推送下面->您的群组(如无则新建)->群组编码）
  "PUSH_PLUS_USER": "",

  ///开启打印等待日志卡短信验证登陆 可开启 拿到日志群里回复
  "Debug": "1",
  ///青龙配置 注意 如果不要青龙  Config :[]
  "Config": [
    {
      //序号必填从1 开始
      "QLkey": 1,
      //服务器名称
      "QLName": "qinglong",
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
