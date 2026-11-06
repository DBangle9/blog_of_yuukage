---
title: "教大家如何安装Arch Linux"
slug: "install-arch"
date: 2026-09-12T00:00:00+08:00
description: "【干货】，如何从零开始构建出archlinux"
categories: ["技术相关"]
tags: ["Linux", "软件"]
---

在我用习惯了centos之后，我的手就伸向了Arch。如今我已经安装过很多次Arch了，今天我就以UEFI引导双系统为例，教大家如何安装Arch。如果你是legacy（BIOS）模式，emm，我以后教你捏

## 在Windows上安装双系统前的准备

如果你想要安装双系统，就需要先在Windows下准备安装空间

在Windows左下角搜索栏搜索“创建并格式化硬盘分区”，或者右键Windows图标，选择“磁盘管理”，在里面找到你想安装arch的硬盘（推荐选择剩余空间多的），右键它，选择“压缩”，输入你想压缩的大小（单位mb，如果你想压缩大约100GB，就输入100000。接下来出现一片显示为黑色的区域就成功了。另外，如果你开启了bitlocker，建议关闭，你也不想安装一次系统就输一次解锁密钥吧ww。还有一个容易被忽略的：在 控制面板 → 电源选项 → 选择电源按钮的功能 里，取消勾选“启用快速启动”，否则 Windows 关机时其实是半休眠状态，Linux 访问 NTFS 分区可能出问题，双系统时间也更容易乱
完成压缩后，我们下载archlinux镜像文件，推荐使用清华源。浏览器搜索tuna，进入清华源官网，在里面找到archlinux，进入，点击iso/文件夹，下载一个最新的，再在浏览器搜索Rufus，下载x86_64版本（如果你的电脑是其他架构，请选择对应架构）
准备一个8GB以上的u盘，提前备份里面的文件，因为刷启动盘会格式化u盘。下载好所有东西以后打开Rufus，在选择镜像的一栏选择你刚刚下载的archlinux的ISO文件，设备选择你的u盘（千万不要选错了，如果你有很多u盘，请全部拔掉只留下你要刷的那一个，防止误格式化丢失数据）。点击开始，如果 Rufus 弹窗问用 ISO 模式还是 DD 模式，选 DD 模式（Arch Wiki 推荐），等待刷完

刷完后重启电脑，按对应的键进入BIOS（常见的有del，F2等，你可以搜索你的笔记本或者主板型号来确定），找到security选项，关闭secure boot，再找到启动项（一般写着start或者boot），把第一启动项改为你的u盘（一般写着uefi，usb等字）
重启会进入一个黑色的启动菜单（新版 Arch 镜像在 UEFI 下是 systemd-boot 的菜单，旧版或部分机器是 GRUB），选择第一个选项 Arch Linux install medium，进入安装环境

## 在macOS上安装双系统的准备（以macOS 12 monterey为例，仅限Intel芯片，m芯片可安装asahi Linux）

打开“磁盘工具”，点左上角“显示”→“显示所有设备”，选中整块物理磁盘（不是下面的宗卷），点“分区”，再点“+”，选择“添加分区”（注意不是“添加宗卷”，APFS 宗卷共享同一个容器，分不出独立空间），大小选你认为合适的，格式选 ExFAT，与APFS的其他宗卷作区分。准备ISO镜像的步骤参照Windows，u盘刷写软件可以使用balenaetcher，当然如果你是Linux大佬，你也可以使用Mac终端的dd命令，因为这俩系统都是类UNIX，指令是互通的。
刷写完毕后重启Mac，按住键盘上的option键，会进入启动选项，选择黄色的，写着uefi和USB device的选项，进入即可

**特别提醒**：如果安装完Linux，grub无法找到macOS的启动项，你可以在开机时按住option键，找到macOS的启动选项并进入（一般是一个机械硬盘的图像，如果有efi boot就不要选，选择另一个）

## 开始安装

在一切开始之前，我们必须先连上网。这里有一个懒人方法，首先，用你的手机连接WiFi，然后找一根数据线，最好是手机原厂的，插在电脑的USB上，在手机上选择“USB网络共享”。然后在archiso里ping www.bilibili.com，能连上就OK
如果你的电脑只有一个USB口，并且已经被启动盘占用，也可以试着直接连接WiFi，首先输入

```sh
iwctl
```

这时候你的终端提示符会变成"[iwd]#"，输入

```sh
device list
```

查看你的网卡名称，一般是wlan0，接下来扫描并列出附近的WiFi（下面都以wlan0为例，换成你自己的网卡名）

```sh
station wlan0 scan
station wlan0 get-networks
```
最后找到你的WiFi

```sh
station wlan0 connect "你的WiFi名"  # 最好是英文名，因为终端里中文会变成方块
```

按提示输入密码即可，输入exit退出联网

## 硬盘分区

接下来开始硬盘分区，你的Linux系统将会安装在压缩出来的空闲空间内
首先确认空闲空间的位置：

```sh
lsblk
```

根据磁盘大小找到那个你压缩过的硬盘（可能会显示/dev/sda，/dev/sdb（SATA硬盘），/dev/nvme0n1，/dev/nvme1n1（m2硬盘）等等，根据硬盘和分区大小，确定你压缩的那块盘）
找到对应的硬盘后，cfdisk你的磁盘，比如是/dev/nvme0n1，选中整块盘，不要具体到nvme0n1p几

```sh
cfdisk /dev/nvme0n1
```

进入看到有绿色的空闲空间就成功了。在这个界面里，按↑ ↓ ← →选择，enter确认。

**如果是macOS**：这一步会没有free space，但是可以看到你创建的exfat分区，将那个分区删除，它就会变为free space

首先创建efi分区，你可以新建一个512MB的fat32分区，也可以和Windows共用。

**注意**：如果选择和Windows共用EFI分区，就跳过下面新建EFI分区这一步，后面也**千万不要**对它执行 mkfs.fat，格式化会把Windows的引导一起删掉，直接挂载它就行。另外Windows自带的EFI分区常常只有100MB，空间比较紧张，新手更推荐自己新建一个512MB的。

选择free space，选择new，输入大小512m，回车。选中你刚刚创建的512MB分区，选择type选项，将其改为EFI System

建议创建swap分区，在内存紧张时，swap可以分担内存的压力。大小建议为8GB-16GB。
选中剩下的free space，选择new，大小输入8g，type选择Linux swap

最后创建根分区。新手期只创建一个根分区就完全够了，之后你也可以尝试单独创建/home，把根目录和home目录放入不同分区。我们先演示单个根分区：
选中剩余的free space，选择new，回车选择剩下的所有空间，类型选择Linux filesystem
选择write选项，输入yes确认，选择quit退出。

## 格式化并挂载分区

**重要！如果你的电脑安装了不止一块m2硬盘，请一定要注意nvme0n1p1和nvme1n1p1的区别，这是不同m2硬盘的不同分区，我之前手残打错数字mkfs过我的E盘，导致我的《AliceInCradle》存档丢失，《崩坏星穹铁道》也得重新下载，血的教训**

首先再次执行

```sh
lsblk
```

找到你刚刚创建的分区，具体到nvme0n1p几（下面用X、Y、Z代替，换成你自己的分区号）
先格式化EFI分区：

```sh
mkfs.fat -F 32 /dev/nvme0n1pX  # 512MB的EFI分区；和Windows共用EFI的话不要执行这一行！
```

初始化Swap分区（若创建了）：依次执行 

```sh
mkswap /dev/nvme0n1pY  # 你的swap分区，如果你按照本手册来安装，就是EFI的后一个分p
swapon /dev/nvme0n1pY
```

格式化并挂载根分区：

```sh
mkfs.ext4 /dev/nvme0n1pZ  # 你的根分区，如果你按照本手册来安装，就是swap的后一个分p
mount /dev/nvme0n1pZ /mnt
```

挂载EFI分区：先创建目录再挂载：

```bash
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1pX /mnt/boot/efi  # X是EFI分区，和上面mkfs.fat的是同一个
```

至此，おめでとう~ 硬盘分区已经完成，接下来就可以往硬盘分区里安装Linux了

## 安装基础系统

1. 安装前检查

```bash
ping -c 3 archlinux.org
```

看看能不能连上archlinux的服务器，如果下载慢，可以先编辑 /etc/pacman.d/mirrorlist，把中国镜像源放到前面。

```bash
nano /etc/pacman.d/mirrorlist
```

在最上面一行加上

```text
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

添加后，执行

```bash
pacman -Syy
```

接下来执行 pacstrap

Intel CPU 用这个：

```bash
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers intel-ucode networkmanager wpa_supplicant nano sudo grub efibootmgr os-prober dosfstools mtools
```

AMD CPU 把 intel-ucode 换成 amd-ucode：

```bash
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers amd-ucode networkmanager wpa_supplicant nano sudo grub efibootmgr os-prober dosfstools mtools
```

base linux linux-firmware是必需的基础系统、内核、固件，base-devel和linux-headers是常用编译环境，建议保留。intel-ucode / amd-ucode是CPU 微码，按你的 CPU 选。networkmanager和wpa_supplicant是网络管理器。nano是文本编辑器，如果你信仰vim，你也可以用vim。sudo是超级用户，验证身份即可以root权限执行命令。grub efibootmgr：UEFI 引导。os-prober：双系统检测 Windows。dosfstools mtools：维护FAT/EFI分区

**如果提示 -K 参数无效，去掉 -K 再执行即可。**

安装完成后生成fstab，这里面记录了各个分区的uuid，在启动Linux时，会根据这个挂载分区

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

检查输出里有没有你的根分区、EFI 分区和 swap。有的话就可以进入新系统力（喜）

```bash
arch-chroot /mnt
```

进去之后就可以设置时区，locale，主机名，root密码，用户，以及启用NetworkManager和设置GRUB了。

## chroot到系统中并修改配置文件

执行"arch-chroot /mnt"以后，命令提示符会由红色变为灰色

首先我们设置时区与硬件时钟，创建一个软链接这里的ln就相当于Windows的快捷方式：

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc --localtime
```

可以看到我这里加了--localtime，这是因为Linux和Windows双系统时间冲突：Windows默认把主板时间当作本地时间（北京时间），Linux默认把主板时间当作UTC再+8小时显示，切换双系统时两边会互相把时间改乱，差整整8小时。加上--localtime就是让Linux也按本地时间来，和Windows保持一致。

接下来进行本地化

```bash
nano /etc/locale.gen
```

取消中文和英文两行前面的 #：

```text
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
```

保存后执行：

```bash
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```

先设 en_US.UTF-8 避免TTY中文乱码，可以等安装桌面后再改中文

可以选键盘布局，我这里选择America的English布局：

```bash
echo 'KEYMAP=us' > /etc/vconsole.conf
```

设置主机名与hosts

```bash
echo '你想给计算机起的名字' > /etc/hostname
nano /etc/hosts
```

写入：

```
127.0.0.1   localhost
::1         localhost
127.0.1.1   计算机名字.localdomain 计算机名字
```
Ctrl+O保存，Ctrl+X退出

接下来设置root密码，别急，就快了，马上就能安装完了

```bash
passwd
```

输入两次密码，如果输入之后什么都没有发生是正常现象，密码是不显示的，连星号都不会显示，盲打即可

接下来创建普通用户并配置 sudo

```bash
useradd -m -G wheel -s /bin/bash 你的用户名
passwd 你的用户名 #设置密码，再次输入两次密码，如果输入之后什么都没有发生是正常现象，密码是不显示的，连星号都不会显示，盲打即可。
EDITOR=nano visudo
```

这里会进入编辑器，在里面找到并取消这行注释：

```
%wheel ALL=(ALL:ALL) ALL
```

默认使用nano编辑器，编辑后Ctrl+O保存，Ctrl+X退出，如果启动的是vim或者vi，先按I进入编辑模式，修改完后按esc退出编辑模式，然后直接打字，输入“:wq”，意思是“保存并退出”，这也是一行最短的悼念词，不过这就是另外一个故事了...

设置完管理员用户后，我们启用NetworkManager来管理网络

```bash
systemctl enable NetworkManager
```

接下来安装 GRUB 引导

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

双系统想自动检测 Windows，先编辑 /etc/default/grub

```bash
nano /etc/default/grub
```

找到 #GRUB_DISABLE_OS_PROBER=false 这一行，去掉前面的 #，保存后再运行一次：

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

输出里出现 Found Windows Boot Manager 就说明检测到了。如果Windows装在另一块硬盘、用的是另一个EFI分区，在chroot里可能检测不到，没关系，重启进入Arch后，先把Windows的EFI分区挂载上（比如 sudo mount /dev/nvme1n1p1 /mnt），再 sudo grub-mkconfig -o /boot/grub/grub.cfg 一次就好。

至此，基础的Arch Linux已经安装完成，退出并重启

```bash
exit
umount -R /mnt
reboot
```

如果umount提示忙，先 swapoff -a 再试。重启前记得拔掉安装U盘，因为你现在BIOS设置的第一启动项仍然是U盘。

重启后用root或刚建的sudo用户登录，连接 WiFi：

```bash
nmcli device wifi list
nmcli device wifi connect "你的WiFi名" password "你的密码"
```
接下来我们安装桌面

## 安装桌面

装好基础系统并重启后，接下来就可以安装桌面环境了。这里以最主流的GNOME和KDE Plasma为例，当然你可以根据自己的喜好和电脑配置来选，比如许多Arch用户很喜欢美化做得很好的niri平铺式桌面，尽管我完全用不习惯，你可以在b站找到教程。

介绍一下我比较推荐的桌面环境

**KDE Plasma**：功能丰富、高度可定制，外观华丽，可以自定义各种东西，我最喜欢的桌面，但是有点吃资源。

**GNOME**：设计简洁，注重效率和触控体验，适合喜欢开箱即用的用户，也是Linux原神Ubuntu的默认桌面，相比KDE不那么吃资源。

**XFCE**：轻量级，资源占用少，适合配置较老的电脑，我的服务器使用的是XFCE桌面，最不吃资源，4GB内存也能流畅运行。

**安装前的关键准备**

先安装一个AUR助手，这个东西非常有用，配置一下archlinuxcn：

```bash
nano /etc/pacman.conf
```

在文件末尾添加以下两行（建议选一个国内镜像），注意保留 $arch 变量：

```text
[archlinuxcn]
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
```

常用镜像替换地址：
中科大：https://mirrors.ustc.edu.cn/archlinuxcn/$arch
清华：https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
阿里云：https://mirrors.aliyun.com/archlinuxcn/$arch

随后导入 GPG 密钥：保存后执行以下命令。第一行是在本地信任 archlinuxcn 维护者的签名（不执行的话，新版 keyring 可能会因为签名不受信任而装不上），第二行安装 archlinuxcn-keyring 以信任仓库签名：

```bash
sudo pacman-key --lsign-key "farseerfc@archlinux.org"
sudo pacman -Sy archlinuxcn-keyring
```

密钥导入后，就可以直接用 pacman 安装 yay 了：

```bash
sudo pacman -S yay
```

注意 yay 要用普通用户运行，不要在 root 下或者 sudo yay，它会自己在需要的时候问你要 sudo 密码。

archlinuxcn 仓库也包含许多常用中文软件、字体和工具（如 google-chrome、visual-studio-code-bin、wps-office 等），直接 pacman -S 即可。

还有还有，在安装桌面环境之前，建议先装好显卡驱动，否则重启后可能无法进入图形界面。
确认显卡型号：执行 

```bash
lspci -k | grep -A 2 -E "(VGA|3D)"
```


如果是NVIDIA显卡，请根据卡型安装驱动。**不要**去NVIDIA官网下载 .run 安装包来装，它会绕过pacman，以后内核一更新就容易黑屏，Arch上直接用仓库里的包就好：

较新的卡（GTX 16系、RTX 20/30/40/50系）用官方的开源内核模块版驱动：

```bash
sudo pacman -S nvidia-open nvidia-utils  # 如果你装的不是linux内核（比如linux-lts、linux-zen），把nvidia-open换成nvidia-open-dkms
```

较老的卡（GTX 900系、GTX 10系）新版驱动已经不支持了，用AUR里的旧版分支：yay -S nvidia-580xx-dkms ；再老的卡（GTX 600/700系，Kepler架构）考虑 nvidia-470xx-dkms。

装完 NVIDIA 驱动后，编辑 /etc/default/grub，在 GRUB_CMDLINE_LINUX_DEFAULT 里添加 nvidia-drm.modeset=1（新版驱动默认已经开启，加上也没坏处），然后重新生成配置 sudo grub-mkconfig -o /boot/grub/grub.cfg，重启后生效。

AMD / Intel 用户：通常使用开源驱动即可，无需额外手动安装。

**So NVIDIA, fuck you（Linus竖中指）**


如果你要安装 KDE Plasma 桌面环境

1. 安装 Plasma 和 KDE 应用：
   ```bash
   sudo pacman -S plasma kde-applications sddm
   ```
   plasma 是核心桌面，kde-applications 是应用合集，sddm 是 KDE 的登录管理器。

2. 启用登录管理器并设置图形启动：
   ```bash
   sudo systemctl enable sddm
   sudo systemctl set-default graphical.target
   ```

3. 重启系统：
   ```bash
   reboot
   ```

如果你要安装 GNOME 桌面环境

1. 安装基础图形服务和 GNOME：
   ```bash
   sudo pacman -S xorg gnome gnome-extra gdm
   ```
   xorg 是显示服务器，gnome-extra 包含常用应用，gdm 是 GNOME 的登录管理器。
2. 启用登录管理器并设置图形启动：
   ```bash
   sudo systemctl enable gdm
   sudo systemctl set-default graphical.target
   ```
3. 重启系统：
   ```bash
   reboot
   ```
其他桌面的我就不教了捏，自己找教程去吧

这时候你可能会发现，你的终端和其他位置都不能显示中文，中文显示出来全是口口口，别慌，打开终端（KDE里可以按Ctrl+Alt+T打开Konsole，GNOME里在应用列表里找“终端”或“Console”），我们在这里安装字体就好了

```bash
sudo pacman -S noto-fonts-cjk noto-fonts-emoji
```

## 安装中文输入法

Linux通常不自带中文输入法，除了最轮椅的Ubuntu，所以我们必须自己安装输入法，这里推荐fcitx5

1. 安装
```bash
sudo pacman -S fcitx5-im fcitx5-chinese-addons
```
fcitx5-chinese-addons 提供了拼音、双拼、五笔等常用中文输入方案。如果需要更强大的词库和联想，可以额外安装 fcitx5-pinyin-zhwiki。

2. 配置环境变量

为了让各种程序都能调用Fcitx5，我们需要设置环境变量。推荐直接编辑 /etc/environment，这种方法对所有用户和大多数桌面环境（包括 Wayland 和 X11）都生效。

```bash
sudo nano /etc/environment
```

在文件中添加以下内容（如果已存在相同行，修改其值即可）：

```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
```

最后一行写 ibus 不是写错了，GLFW 只认 ibus 这个值，fcitx5 是兼容它的。保存退出即可。

**如果你用的是 KDE Plasma（Wayland）**：前两行 GTK_IM_MODULE 和 QT_IM_MODULE 可以不写，写了反而可能出问题。改为在 系统设置 → 键盘 → 虚拟键盘 里选择 Fcitx 5 即可。

3. 设置开机自启动

大多数桌面环境（如 KDE、GNOME、Xfce）会自动识别并启动 Fcitx5，通常无需手动配置。如果重启后输入法未自动运行，可以手动添加自启动。我们将自启动文件复制到用户目录：

```bash
mkdir -p ~/.config/autostart
cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
```

完成上述步骤后，重启系统使环境变量生效。然后运行配置工具：

```bash
fcitx5-configtool
```

在弹出的窗口中，取消勾选“仅显示当前语言”，在左侧列表中找到 “拼音” (PinYin)，点击中间的 “添加” 按钮将其移到右侧。可以按需添加“双拼”或“五笔”。配置完成后，通常按 Ctrl + 空格 即可切换中英文输入。

**至此，你已经成功安装了一个可以用的Arch Linux，恭喜你，熬夜这么晚，终于可以睡觉了**
