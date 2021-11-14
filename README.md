
## 第一步
- 脚本适用于（ubuntu、debian、centos、openwrt）
- 一键安装青龙，包括（docker、任务、依赖安装，一条龙服务）
- 自动检测docker，有则跳过，无则执行安装
- openwrt请编译之时加入docker,然后挂载好盘
- 如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装
- 如果您以前青龙文件在root/ql或opt/ql，[环境变量文件]又符合要求，就会继续使用
- 
#### 🚩 一键安装青龙面板命令
```sh
wget -O ql.sh https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/ql.sh && bash ql.sh
```

## 第二步

#### 🚩 如果上面的命令运行成功会有提示，按提示操作登录面板
```sh

# > 登录面板后，在‘ 环境变量 ’项添加 WSKEY 或者 PT_KEY

# > 添加 wskey 或者 pt_key 都要注意KEY里面的分号，英文分号，记得别省略了，格式如下

名称
JD_WSCK

值
pin=您的账号;wskey=您的wskey值



# > 或者添加PT_KEY，注意：WSKEY和PT_KEY二选一即可

名称
JD_COOKIE

值
pt_key=您的pt_key值;pt_pin=您的账号;
```


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
