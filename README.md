
## 第一步
- 脚本适用于（ubuntu、debian、centos、openwrt）
- 一键安装青龙，包括（docker、任务、依赖安装，一条龙服务）
- N1或者其他晶晨系列盒子安装在root文件夹，其他设备都安装在opt文件夹内
- 除OPENWRT外，自动检测docker，有则跳过，无则执行安装
- openwrt请[编译](https://github.com/281677160/build-actions)之时加入docker,然后挂载好盘
- 如果您以前安装有青龙的话，则自动删除您的青龙容器和镜像，全部推倒重新安装
- 如果安装的当前文件夹里有青龙文件存在，[环境变量文件]又符合要求，就会继续使用
- nvjdc面板作用就是手机验证自动生成pt_key，免除抓包烦恼，如果您是外网安装青龙跟nvjdc面板的话，您把nvjdc面板网址给人家，人家也可以手机验证到您的青龙挂机

#### 🚩 一键安装青龙面板命令
#
- 为防止系统没安装curl，使用不了一键命令，使用一键安装青龙面板命令之前先执行一次安装curl命令

- 安装curl请注意区分系统，openwrt千万别另外安装curl，openwrt本身自带了，另外安装还会用不了
#

- 使用root用户登录ubuntu或者debian系统，后执行以下命令安装curl
```sh
apt -y update && apt -y install curl
```

- 使用root用户登录centos系统，后执行以下命令安装curl
```sh
yum install -y curl
```
#

- 安装完curl后，执行下面一键命令安装青龙+依赖+任务（安装完毕后再次使用命令可以对应用进行升级）
```sh
bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/ql.sh)"
```
#

## 第二步

#### 🚩 如果上面的命令运行成功会有提示，按提示操作登录面板


- 登录面板后，在‘ 环境变量 ’项添加 WSKEY 或者 PT_KEY

- 添加 wskey 或者 pt_key 都要注意KEY里面的分号，英文分号，记得别省略了，WSKEY和PT_KEY二选一即可

- 格式如下：

```sh
# > 添加 wskey

名称
JD_WSCK

值
pin=您的账号;wskey=您的wskey值;



# > 添加PT_KEY

名称
JD_COOKIE

值
pt_key=您的pt_key值;pt_pin=您的账号;
```

#
#### 🚩 青龙面板安装依赖方法
- ####  依赖管理 --> 添加依赖 --> 依赖类型(NodeJs) --> 自动拆分(是) --> 名称(把下面依赖名称全复制粘贴) --> 确定 
```sh
date-fns
axios
ts-node
typescript
png-js
crypto-js
md5
dotenv
got
ts-md5
tslib
@types/node
requests
tough-cookie
jsdom
download
tunnel
fs
ws
js-base64
jieba
canvas
```
#
#### 🚩 单独安装某项的一键脚本


- 一键单独安装docker
```sh
bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/docker.sh)"
```

- 一键安装单独青龙的依赖
```sh
docker exec -it qinglong bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/ql/main/npm.sh)"
```
## 感谢！

> [`whyour`](https://github.com/whyour/qinglong)
> [`NolanHzy`](https://github.com/NolanHzy/nvjdcdocker)
#
- # 捐赠
- 如果你觉得此项目对你有帮助，请请我喝一杯82年的凉白开，感谢！

-微信-
# <img src="https://github.com/danshui-git/shuoming/blob/master/doc/weixin4.png" />
#
