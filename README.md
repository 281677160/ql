## 第一步

#### 💻 Server

```sh
docker run -dit \
   -v /opt/ql/config:/ql/config \
   -v /opt/ql/log:/ql/log \
   -v /opt/ql/db:/ql/db \
   -v /opt/ql/scripts:/ql/scripts \
   -v /opt/ql/jbot:/ql/jbot \
   -v /opt/ql/raw:/ql/raw \
   -v /opt/ql/repo:/ql/repo \
   -p 5700:5700 \
   --name qinglong \
   --hostname qinglong \
   --restart always \
   whyour/qinglong:latest
```

#### 🚀 OpenWrt

```sh
docker run -dit \
  -v /opt/ql/config:/ql/config \
  -v /opt/ql/log:/ql/log \
  -v /opt/ql/db:/ql/db \
  -v /opt/ql/scripts:/ql/scripts \
  -v /opt/ql/jbot:/ql/jbot \
  -v /opt/ql/raw:/ql/raw \
  -v /opt/ql/repo:/ql/repo \
  --net host \
  --name qinglong \
  --hostname qinglong \
  --restart always \
  whyour/qinglong:latest
```

## 第二步

#### 🚩 Login
```sh

# > 上面的安装完毕后，确保你的设备放行了`5700`端口，隔2分钟左右，用自己的`ip:5700`进入页面

# > 进入页面后，点击安装青龙面板，然后按提示设置好账号、密码就可以了

# > 面板安装成功后，登录面板，然后在环境变量项添加 WSKEY

名称
JD_WSCK

值
pin=您的账号;wskey=XXXXXX
```

```sh

# > 您也可以使用 JD_COOKIE，WSKEY和JD_COOKIE二选一即可

名称
JD_COOKIE

值
pt_key=XXXXXX;pt_pin=您的账号;
```

## 第三步

#### 🎉 WSKEY设置好后，执行以下命令，二选一即可


- #### 如果在宿主机执行命令，如下
```sh
docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/custom.sh)"
```

- #### 如果在容器内执行命令，如下
```sh
bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/custom.sh)"
```

## 第四步

> 因为要安装依赖，所以要花点时间，请耐心等待，命令运行完毕后，你的脚本就正常运行了


## Thanks

> [`互助研究院`](https://t.me/update_help)
