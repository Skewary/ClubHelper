# 本地配置说明

## 流程

### 首先git clone

```bash
git clone git@gitlab.questionor.cn/your_repository.git
```

### 安装bundler

```bash
gem install bundler -v "~>1"
```

### 安装依赖

```bash
bundle install
```

### 部署配置文件

#### config/database.yml

拷贝sample文件

```bash
cp config/database.yml.sample config/database.yml
```

然后修改`config/database.yml`，里面是数据库配置，改development下的即可

以及，如果本地还没有对应的数据库的话，需要

```bash
mysql -u user_name -p
```

登录数据库进行创建

```mysql
CREATE DATABASE my_database_name;
```

没有用户的话，同理，可以自行百度，不过需要保证权限正常。

#### config/redis.yml

拷贝sample文件

```bash
cp config/redis.yml.sample config/redis.yml
```

然后视情况修改`config/redis.yml`。

实际上，对于默认的安装情况，即

```bash
sudo apt-get install redis-server
```

不需要修改此类配置文件（一般只有使用远程redis或者设置了密码的才需要）

#### config/system.yml

拷贝sample文件

```bash
cp config/system.yml.sample config/system.yml
```

目前阶段暂时用不着进行修改，直接使用即可。

#### config/secrets.yml

同样，拷贝sample文件

```bash
cp config/secrets.yml.sample config/secrets.yml
```

development环境下暂时不需要修改，直接使用即可。

## 测试配置

### redis连接测试

进入console

```bash
rails console
```

然后输入命令

```ruby
$redis_cache.get("key")
```

看看是否会返回一个值（可能为`nil`），如果返回一个值则连接正常。报错则说明连接错误。

### mysql连接测试

#### 方法一：rails db连接

输入命令

```bash
rails db
```

然后输入你的密码（数据库配置中写的密码）

看看是否能够正常登录。

（本方法只能用于检查密码是否正确，无法检查权限是否齐全）

#### 方法二：沙箱法

输入命令，以沙箱模式进入console

```bash
rails console --sandbox
```

然后在里面对于现有的数据模型进行各种操作（增删查改都可以试试）

然后退出。

（本方法只能用于已经有数据模型存在的情况）

### 服务测试

启动服务

```bash
rails server -b 0.0.0.0 -p 3000
```

然后用浏览器访问3000端口，看是否有欢迎界面出来。

## 常见问题

### bundle install时安装mysql2出错

如果你还没有安装mysql服务端（适用于使用本地mysql的情况）

```bash
sudo apt-get install mysql-server
```

如果你还没有安装mysql客户端（适用于使用远程mysql的情况）

```bash
sudo apt-get install mysql-client
```

如果gem依赖安装过程出错

```bash
sudo apt-get install libmysqlclient-dev 
```