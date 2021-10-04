## Deploy

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
   -p 57100:5700 \
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

## Usage

#### 🚩 Login

> 确保你的设备放行了`5700`端口
> 上面的安装完毕，隔2分钟左右，用自己的`ip:5700`登录面板
>
> 点击安装青龙面板，然后按提示设置好账号、密码就可以了

#### 🎉 One-key configuration

> 科学网络环境

```sh
# > 宿主机

docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/custom.sh)"

# > 容器内

bash -c "$(curl -fsSL https://raw.githubusercontent.com/xtoys/Scripts/main/dragon/custom.sh)"
```

> 国内网络环境

```sh
# > 宿主机

docker exec -it qinglong bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/xtoys/Scripts@main/dragon/custom-cdn.sh)"

# > 容器内

bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/xtoys/Scripts@main/dragon/custom-cdn.sh)"
```

## Thanks

> [`互助研究院`](https://t.me/update_help)
