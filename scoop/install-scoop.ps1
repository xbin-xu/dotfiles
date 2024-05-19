# https://github.com/ScoopInstaller/Install
# 检查版本: PowerShell >= 5.1
if (!($PSVersionTable.PSVersion.Major -ge 5 -and
      $PSVersionTable.PSVersion.Minor -ge 1)) {
    Write-Error "Error: PowerShell 5.1 or later is required"
    exit 1
}

# 更改执行策略，以允许执行本地脚本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 默认安装 Scoop，默认路径: C:\Users\<YOUR USERNAME>\scoop
# irm get.scoop.sh | iex
# # You can use proxies if you have network trouble in accessing GitHub, e.g.
# irm get.scoop.sh -Proxy 'http://<ip:port>' | iex

# 自定义安装
# 下载安装脚本
# irm get.scoop.sh -outfile 'install.ps1'
# irm scoop.201704.xyz -outfile 'install.ps1'

# 安装
$SCOOP_DIR="D:\Software\Scoop"
[Environment]::setEnvironmentVariable('SCOOP',$SCOOP_DIR,'User')
.\install.ps1 -RunAsAdmin -ScoopDir $SCOOP_DIR

# $SCOOP_GLOBAL_DIR="D:\Software\GlobalScoopApps"
# [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $SCOOP_GLOBAL_DIR, 'Machine')
# .\install.ps1 -RunAsAdmin -ScoopGlobalDir  $SCOOP_GLOBAL_DIR
