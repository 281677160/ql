
## 第一步

#### 执行以下命令


# > 脚本适用于（ubuntu、debian、centos、openwrt）
# > 一键安装青龙，包括（docker、任务、依赖安装，一条龙服务）
# > 自动检测docker，有则跳过，无则执行安装
# > openwrt请编译之时加入docker,然后挂载好盘
# > 如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装
# > 如果您以前青龙文件在root/ql或opt/ql，[帐号密码文件]和[环境变量文件]又符合要求，就会继续使用，免除第二、三步骤
---

```sh
wget -O ql.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/ql.sh && bash ql.sh
```

## 第二步

#### 🚩 如果上面的命令运行成功会有提示，按提示操作
```sh

# > 确保你的设备放行了`5700`端口，用自己的`ip:5700`或者您修改的端口进入页面

# > 点击[开始安装]，[通知方式]跳过，设置好[用户名]跟[密码],然后点击[提交]，然后点击[去登录]，输入帐号密码完成登录!

# > 登录面板后，在‘ 环境变量 ’项添加 WSKEY 或者 PT_KEY

# > 添加 wskey 或者 pt_key 都要注意KEY里面的分号，英文分号，记得别省略了

名称
JD_WSCK

值
pin=您的账号;wskey=XXXXXX
```

```sh

# > 或者添加PT_KEY，WSKEY和PT_KEY二选一即可

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


一键单独安装docker
wget -O docker.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/docker.sh && bash docker.sh


一键单独安装任务（青龙安装好后，登录页面后，可以用这个单独安装任务）
docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/feverrun.sh)"


一键安装单独青龙的依赖
docker exec -it qinglong bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/npm.sh)"


```

## 感谢！

> [`whyour`](https://github.com/whyour/qinglong)
> [`feverrun`](https://github.com/feverrun/my_scripts)
