# iPacker

> 用 Packer 自动化构建基础镜像

## 如何使用？

- 目录介绍
  - `builds`：用于存放 Packer 打包后的 Box 文件
  - `centos`：用于构建 `Centos` 镜像所需的 Packer 配置文件以及脚本文件
  - `_common`：用于存放一些公共文件
  - `ubuntu`: 用于构建 ubuntu 镜像所需的 Packer 配置文件以及脚本文件
- 修改点东西

  - 将 `centos/http/sshkey` 里的 `id_rsa_vagrant.pub` 替换为你自己的 `sshkey` 文件
  - 修改 `centos/variables-centos7.9.json` 里的 `ssh_username`、 `ssh_password` 以及 `ssh_pubkey`
  - 修改 `centos/http/7/ks.cfg` 里的 `rootpw --iscrypted` 后面的值为加密后的 root 密码，可通过 `openssl passwd -6 -stdin <<< "vagrant"` 得到加密后的密码
  - 修改 `centos/http/7/ks.cfg` 里的 `user --groups=vagrant --name=vagrant --password=$1$CLP8Fsi9$G2YnFrW34CLu16058XzPv0 --iscrypted --gecos="vagrant"` 里的用户名和密码，通过 `openssl passwd -6 -stdin <<< "vagrant"` 得到加密后的密码
  - `openssl passwd -6 -stdin <<< PASSWORD` 可用来加密 ubuntu 的密码
  - 替换 `centos/http/7/ks.cfg` 里的所有 vagrant 用户名为你自己定义的用户名，默认用户名为 vagrant ，密码为 vagrant
  - 修改 `centos/scripts/base.sh` --- `设置 vagrant 账号无密码且拥有 sudo 权限` 里的 vagrant 为你的用户名
  - 替换 `centos/scripts/cleanall.sh` 里的 vagrant 为你的用户名
  - 替换 `centos/scripts/vboxguest.sh` 里的 vagrant 为你的用户名

- 操作步骤（需要安装 Packer、`KVM/Virtualbox/VMware`）
  - 先进入到 `Centos` 目录下
  - 然后执行 `packer build -var-file variables-centos7.9.json centos-qemu.json`
  - 待打包完成后在 builds 目录下找到生成的 Box 文件，然后可用 `vagrant box add xxxx.box` 添加使用
  - 如果是打包 ubuntu，一定要设置 export TMPDIR=~/workfiles 添加到 ~/.bashrc，不然会导致构建失败
  - **windows 中使用 packer 时报错：“ could not find a supported CD ISO creation command (the supported commands are: xorriso, mkisofs, hdiutil, oscdimg)”**
    - 需要在 win11 中安装 oscdimg,去 https://learn.microsoft.com/zh-tw/windows-hardware/get-started/adk-install 选择 “下載適用于 Windows 11 22H2 版的 ADK” 下载 windows ADK 然后安装，安装中只选择“部署工具”即可，因为它包含了我们需要的 oscdimg
    - 将 `D:\Program Files\windowsADK\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg` 添加进环境变量中，不然无法识别到 oscdimg 程序
