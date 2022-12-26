![OpenWrt logo](include/logo.png)

OpenWrt Project is a Linux operating system targeting embedded devices. Instead
of trying to create a single, static firmware, OpenWrt provides a fully
writable filesystem with package management. This frees you from the
application selection and configuration provided by the vendor and allows you
to customize the device through the use of packages to suit any application.
For developers, OpenWrt is the framework to build an application without having
to build a complete firmware around it; for users this means the ability for
full customization, to use the device in ways never envisioned.

Sunshine!

 -------------------------------------------------------------------------------

警告！
本仓库仅供测试，不提供可靠性保证！

Warning!
This warehouse is for testing only and does not provide reliability guarantees!

 -------------------------------------------------------------------------------
 
## 编译准备

1. 选择 “最小安装” Ubuntu 22.04.1 Desktop (64-bit)

2. 使用普通用户登录 Ubuntu 系统，禁止使用 root 用户或权限进行编译操作。

3. 安装编译环境

```
sudo apt-get update
```

```
sudo apt install -y build-essential clang curl flex g++-multilib gawk \
gettext git libelf-dev libncurses5-dev libssl-dev python3-distutils
```

```
sudo apt-get clean
```

### 开始编译

4. 获取主源代码

```
git clone -b openwrt-21.02 https://github.com/ikghx/openwrt-life.git
```

5. 进入主源代码目录，更新并安装软件库

```
./scripts/feeds update -a
```

```
./scripts/feeds install -a
```

6. 打开编译菜单界面，按个人需要进行定制

```
make menuconfig
```

7. 开始编译

```
make
```

### 其它参考命令

多线程加速编译，例如系统配备了4核心处理器

```
make -j4
```

编译时显示详细信息，用于排查编译错误

```
make V=s
```

打开内核菜单界面，按需定制内核功能

```
make kernel_menuconfig
```

清除软件编译缓存目录，以便快速测试软件更改

```
make clean
```

清空整个编译缓存目录，以便开始全新编译

```
make dirclean
```

## Support Information

For a list of supported devices see the [OpenWrt Hardware Database](https://openwrt.org/supported_devices)

### Documentation

* [Quick Start Guide](https://openwrt.org/docs/guide-quick-start/start)
* [User Guide](https://openwrt.org/docs/guide-user/start)
* [Developer Documentation](https://openwrt.org/docs/guide-developer/start)
* [Technical Reference](https://openwrt.org/docs/techref/start)

### Support Community

* [Forum](https://forum.openwrt.org): For usage, projects, discussions and hardware advise.
* [Support Chat](https://webchat.oftc.net/#openwrt): Channel `#openwrt` on **oftc.net**.

### Developer Community

* [Bug Reports](https://bugs.openwrt.org): Report bugs in OpenWrt
* [Dev Mailing List](https://lists.openwrt.org/mailman/listinfo/openwrt-devel): Send patches
* [Dev Chat](https://webchat.oftc.net/#openwrt-devel): Channel `#openwrt-devel` on **oftc.net**.

## License

OpenWrt is licensed under GPL-2.0
