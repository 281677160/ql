## 第一步

> 将青龙安装docker里，复制下面所有代码运行

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

#### 🚩 设置好KEY
```sh

# > 上面的安装完毕后，确保你的设备放行了`5700`端口，隔2分钟左右，用自己的`ip:5700`进入页面

# > 进入页面后，点击安装青龙面板，然后按提示设置好账号、密码就可以了

# > 信息推送不需要填写，直接跳过就好了，任务运行后在配置文件添加就可以

# > 面板安装成功后，登录面板，然后在‘ 环境变量 ’项添加 WSKEY

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

#### 🎉 KEY设置好后，执行以下命令安装脚本，二选一即可

```sh
-


- #### 如果在宿主机,复制以下命令执行

docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"


- #### 如果在容器内,复制以下命令执行

bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"


-
```

## 第四步

#### 🚩 脚本好后，执行以下命令安装依赖，二选一即可（最好在翻墙网络状态下进行）

> 依赖还是有必要安装的，个别任务要有依赖才可以进行，当然不安装也影响不大吧，自己考虑

> 安装依赖时候或许看到显示ERR!错误提示的，那些都不用管，只要依赖能从头到尾的下载运行完毕就好了

```sh
-


- #### 如果在宿主机,复制以下命令执行

docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/npm.sh)"


- #### 如果在容器内,复制以下命令执行

bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/npm.sh)"


-
```

## 感谢！

> [`feverrun`](https://github.com/feverrun/my_scripts)
