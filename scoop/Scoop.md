# Windows 重装系统

<!--toc:start-->
- [Windows 重装系统](#windows-重装系统)
  - [1. Scoop](#1-scoop)
    - [1.1 添加到右键菜单：找到对应的安装目录，然后运行 `install-context.reg`](#11-添加到右键菜单找到对应的安装目录然后运行-install-contextreg)
    - [1.2 IDM](#12-idm)
    - [1.3 Chrome 更改个人资料路径](#13-chrome-更改个人资料路径)
    - [1.4 oh-my-posh](#14-oh-my-posh)
  - [2. WSL](#2-wsl)
    - [2.1 迁移至非系统盘符](#21-迁移至非系统盘符)
    - [2.2 必要工具](#22-必要工具)
<!--toc:end-->

> 激活[HEU_KMS_Activator](https://zhizhi.lanzoue.com/b00qgpgc)

## 1. Scoop

> Scoop：[Scoop](https://scoop.sh/) | [GitHub](https://github.com/ScoopInstaller/Install) | [Gitee](https://gitee.com/glsnames/scoop-installer)
> 代理：[scoop-proxy-cn](https://github.com/lzwme/scoop-proxy-cn)
> 参考：[Scoop 包管理器](https://blog.csdn.net/omaidb/article/details/129286772) | [Scoop 的安装与使用&常用软件推荐](https://blog.xqh.ma/posts/2020-03-09-Windows%E5%8C%85%E7%AE%A1%E7%90%86%E5%99%A8-Scoop%E7%9A%84%E5%AE%89%E8%A3%85%E4%B8%8E%E4%BD%BF%E7%94%A8&%E5%B8%B8%E7%94%A8%E8%BD%AF%E4%BB%B6%E6%8E%A8%E8%8D%90/)

```powershell
# 0. 更改执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 1. 安装 Scoop
# 用户安装的路径
$env:SCOOP='D:\Software\Scoop'
[Environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')
# 全局安装的路径--需要以管理员身份运行 PowerShell
$env:SCOOP_GLOBAL='D:\Software\ScoopGlobal'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
# 安装
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
# cd ~\Desktop
# irm get.scoop.sh -outfile 'install.ps1'
# .\install.ps1 -RunAsAdmin
```

```bash
# 2. 安装 7-zip Git
scoop install 7zip git

# 3. 更换 Scoop 镜像源
scoop config SCOOP_REPO https://gitee.com/glsnames/scoop-installer
scoop update

# 4. 添加 Bucket 软件源
scoop bucket known
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts
scoop bucket add spc https://ghproxy.com/github.com/lzwme/scoop-proxy-cn
scoop update

# 5. Aria2 加速下载
scoop install aria2                                 # 安装 Aria2
scoop config aria2-max-connection-per-server 16     # 设置 16 线程下载
scoop config aria2-split 16                         # 设置 16 线程下载分块
scoop config aria2-min-split-size 1M                # 设置每个分块的最小体积
scoop config aria2-enabled true                     # 启用 Aria2 下载，默认启用

# 6. 安装应用 git-bash
# scoop export > scoop_apps.json
scoop install scoop_apps.json
```

### 1.1 添加到右键菜单：找到对应的安装目录，然后运行 `install-context.reg`

### 1.2 IDM

[破解 IDM](https://github.com/lstprjct/IDM-Activation-Script)

### 1.3 Chrome 更改个人资料路径

```cmd
# chrome://version/
mklink /d "C:\Users\Bin\AppData\Local\Google\Chrome\User Data" "D:\Software\Scoop\persist\googlechrome\User Data"
```

### 1.4 oh-my-posh

```powershell
# 安装 oh-my-posh
scoop install oh-my-posh
# 查看所有主题
Get-PoshThemes

# 将下面一行添加到 $PROFILE, `notepad $PROFILE`
oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH\material.omp.json | Invoke-Expression
```

```bash
# 将下来两行添加到 ~/.bashrc
set POSH_THEMES_PATH "~/AppData/Local/Programs/oh-my-posh/themes"
eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/material.omp.json)"
```

## 2. WSL

> [如何使用 WSL 在 Windows 上安装 Linux](https://learn.microsoft.com/zh-cn/windows/wsl/install)
> [设置 WSL 开发环境](https://learn.microsoft.com/zh-cn/windows/wsl/setup/environment)

```powershell
# 启用 “适用于 Linux 的 Windows 子系统”
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# 启用 “虚拟机平台”
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# 安装 WSL 命令
wsl --install
# 安装指定的 Linux 发行版 `wsl --install -d <Distro>`
# wsl --install -d Ubuntu
```

### 2.1 迁移至非系统盘符

```bash
# 查看发行版的名称
wsl --list -v
# 导出系统 `wsl --export <Distro> <FileName>`
wsl --export Ubuntu D:/WSL/Ubuntu.tar
# 注销并删除根文件系统 `wsl --unregister <Distro>`
wsl --unregister Ubuntu
# 重新导入系统 `wsl --import <Distro> <InstallLocation> <FileName> [Options]`
wsl --import Ubuntu D:/WSL/Ubuntu D:/WSL/Ubuntu.tar
# 进入 wsl 创建一个用户
sudo addusr xbin
# 添加到 sudo 用户组
usermode -aG sudo xbin
# [option] sudo 免密: 在 /etc/sudoers 最后添加下面命令
sudo vim /etc/sudoers
xbin ALL=(ALL) NOPASSWD:ALL
# 设置默认用户名 `ubuntu config --default-user <usrname>`
ubuntu config --default-user xbin
```

### 2.2 必要工具

```bash
# nodejs
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
# vim: install vim-gtk to support clipboard
sudo add-apt-repository ppa:jonathonf/vim
# fish
sudo apt-add-repository ppa:fish-shell/release-3

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y \
    vim-gtk fish git ssh tmux neofetch tree net-tools \
    exa fd-find ripgrep zoxide \
    clang cmake ninja-build \
    python3 python3-pip python3-venv nodejs cargo

# neovim: version to low in `apt`
sudo snap install nvim --classic

# tldr
pip install tldr

# qemu
sudo apt-get install -y qemu-system

# docker: https://docs.docker.com/engine/install/ubuntu/
# 将当前用户添加到 docker 用户组，以省去 sudo
sudo usermod -aG docker $USER

# lazygit: can not use `apt` to install
sudo snap install lazygit

# fzf: version to low in `apt`
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
