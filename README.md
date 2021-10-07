
## 第一步

#### 执行以下命令

```sh
脚本适用于（ubuntu的docker、debian的docker、openwrt的docker）
一键安装青龙，包括（docker、任务、依赖安装，一条龙服务）
自动检测docker，有则跳过，无则执行安装，如果是openwrt则不会自动安装docker
如果您以前安装有青龙的话，则自动删除您的青龙，全部推倒重新安装
如果有条件的话，最好使用翻墙网络来安装，要不然安装依赖的时候你会急死的


wget -O ql.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/ql.sh && bash ql.sh


---
```

## 第二步

#### 🚩 如果上面的命令运行成功会有提示，登录页面，设置好KEY
```sh

# > 上面的安装完毕后，确保你的设备放行了`5700`端口，用自己的`ip:5700`进入页面

# > 进入页面后，点击安装青龙面板，然后按提示设置好账号、密码，登录管理页面就可以了

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

#
## 第三步，设置好KEY后，回到命令窗，输入Y或者y回车继续安装脚本，如果拉取脚本途中出现错误，可以使用单独“一键单独安装任务”和“一键安装单独青龙的依赖”继续安装
#



#### 🚩 全部一键脚本

```sh

一键安装青龙，包括（docker、任务、依赖安装，一条龙服务）
wget -O ql.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/ql.sh && bash ql.sh


一键单独安装任务（青龙安装好后，登录页面后，可以用这个单独安装任务）
docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"


一键单独安装docker
wget -O docker.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/docker.sh && bash docker.sh


一键安装单独青龙的依赖
docker exec -it qinglong bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/npm.sh)"


```

## 感谢！

> [`feverrun`](https://github.com/feverrun/my_scripts)
