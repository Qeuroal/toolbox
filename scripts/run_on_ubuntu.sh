#!/bin/bash

source ${PWD}/scripts/utils.sh

# 软件个数
softwareCount=36
softwareInstallKeys=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" \
    "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
# echo "softwareInstallKeys${#softwareInstallKeys[@]}: ${softwareInstallKeys[@]}"
# 当前目录
rootDir=${PWD}
colorprint "info" "project root dir: $rootDir"

function setProxy() {
    # judge exist proxy file
    if [ $(isExistFile "/etc/profile.d/proxy.sh") == 1 ]; then
        colorprint "warning" "canceling to add proxy.sh"
        return
    else
        colorprint "info" "adding proxy.sh"
    fi

    # generate proxy file
    filename="proxy_$(date +%s).sh"
    echo "rm -rf ${filename}"
    
    echo "export HTTP_PROXY=\"http://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export HTTPS_PROXY=\"http://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export FTP_PROXY=\"http://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export ALL_PROXY=\"socks://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export NO_PROXY=\"localhost,127.0.0.0/8,::1\"" >> ./${filename}

    echo "export http_proxy=\"http://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export https_proxy=\"http://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export ftp_proxy=\"http://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export all_proxy=\"socks://${proxyIpAddr}:7890/\"" >> ./${filename}
    echo "export no_proxy=\"localhost,127.0.0.0/8,::1\"" >> ./${filename}

    chmod +x ${filename}
    echo "${passwd}" | sudo -S mv ${filename} /etc/profile.d/proxy.sh
    # sudorun "chmod +x /etc/profile.d/proxy.sh"
    source /etc/profile.d/proxy.sh
}

function installVim() {
    git clone https://github.com/Qeuroal/vimart.git ~/vimart
    cd ~/vimart
    yes y | bash install.sh
    cd ${rootDir}

    # 设置国内代理
    # go env -w GOPROXY=https://goproxy.cn

    # 安装 YouCompleteMe-all
    python3 ~/.vim/plugged/YouCompleteMe/install.py --all --verbose
}


function installZsh() {
    sudorun "sudo -S apt update"
    sudorun "sudo -S apt -y install zsh autojump"
    sudorun "chsh -s /bin/zsh"

    # yes y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	source /etc/profile.d/proxy.sh
    # sudorun "yes y | sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
	curl -JL -o install_oh_my_zsh.sh  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	yes y | bash install_oh_my_zsh.sh \
        && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k \
        && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
        && git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
        && rm -rf install_oh_my_zsh.sh
}

function installDocker() {
    sudorun "sudo -S apt update"
    sudorun "yes y | sudo -S apt remove docker docker-engine docker.io"

    # ##  使用 APT 安装
    # # 添加使用 HTTPS 传输的软件包以及 CA 证书
    # sudorun "yes y | sudo -S apt install apt-transport-https ca-certificates curl gnupg lsb-release"

    # # 设置国内源
    # # curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # # 向 sources.list 中添加 Docker 软件源
    # # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # # 向 sources.list 中添加 Docker 软件源
    # filename="docker_tmp_$(date +%s)"
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee ./${filename}.list > /dev/null
    # sudorun "sudo -S mv ./${filename}.list /etc/apt/sources.list.d/docker.list"

    # # 安装 docker
    # sudorun "sudo -S apt update"
    # sudorun "yes y | sudo -S apt install docker-ce docker-ce-cli containerd.io"

    ## 脚本自动安装 docker
    curl -fsSL get.docker.com -o get-docker.sh
    # sudo sh get-docker.sh --mirror Aliyun
    sudorun "sudo -S bash get-docker.sh"

    # 启动 Docker
    sudorun "sudo -S systemctl enable docker"
    sudorun "sudo -S systemctl start docker"

    # 建立 docker 用户组
    sudorun "sudo -S groupadd docker"
    sudorun "sudo -S usermod -aG docker $USER"

    # 测试 Docker 是否安装正确
    # docker run --rm hello-world
}

function prepare() {
    # get passwd
    getPasswd

    # get user info
    getUserInfo
    colorprint "info" "userName: ${userName}"

    # get ip
    getIp
    colorprint "info" "ip: ${ipAddr}"

    # set proxy
    setProxy
}

function installVagrantAndVirtualbox() {
    # 安装 virtualbox
    sudorun "sudo -S apt -y install virtualbox"

    # 安装 vagrant
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudorun "sudo -S apt update"
    sudorun "sudo -S apt -y install vagrant"

}

function installClash() {
    chmod +x ${rootDir}/resource/clash
    sudorun "sudo -S mv ${rootDir}/resource/clash /usr/local/bin/"

    colorprint "warning" "Please do following steps:"
    echo " 1. 执行 clash 进行初始化"
    echo " 2. 生成配置文件 ~/.config/clash/config.yaml 后, 使用 ctrl + c 退出clash"
    echo " 3. 基于订阅地址下载配置: curl -L <订阅地址> -o ~/.config/clash/config.yaml"
    echo " 4. 打开网址: yacd.haishan.me 修改节点等信息"
}

function installTmux() {
    # install software
    sudorun "sudo -S apt update"
    sudorun "sudo -S apt -y install tmux"

    ## mehthod 1
    # set conf
    backupFile "${HOME}/.tmux.conf"
    backupFile "${HOME}/.tmux.conf.local"
    rm -rf ~/.tmux.conf
    rm -rf ~/.tmux.conf.local
    cp -f ${rootDir}/resource/tmux.conf ~/.tmux.conf
    cp -f ${rootDir}/resource/tmux.conf.local ~/.tmux.conf.local
    yes y | tmux kill-server

    ## method 2
    # git clone https://github.com/gpakosz/.tmux.git ~/.tmux
    # rm -rf ~/.tmux.conf
    # rm -rf ~/.tmux.conf.local
    # ln -sf "${HOME}/.tmux/.tmux.conf" ~/.tmux.conf
    # ln -sf "${HOME}/.tmux/.tmux.conf.local" ~/.tmux.conf.local
}

function installSpecifiedSoftware() {
    case "$1" in
        "0")
            colorprint "info" "installing necessary software"
            sudorun "sudo -S apt update"
            sudorun "sudo -S apt -y install git curl wget vim"
            ;;
        "1")
            # vim
            colorprint "info" "installing Vim"
            installVim

            # zsh
            colorprint "info" "installing Zsh"
            installZsh
            ;;
        "2")
            # docker
            colorprint "info" "installing Dokcer"
            installDocker
            ;;
        "3")
            colorprint "info" "installing vagrant and virtualbox"
            ;;

        "c")
            colorprint "info" "installing clash"
            installClash
            ;;
        "f")
            colorprint "info" "installing fonts"
            installFonts
            ;;
        "t")
            colorprint "info" "installing tmux"
            installTmux
            ;;
        *)
            colorprint "error" "not support key \"${key}\""
            ;;
    esac
}

# install software
function installSoftware() {
    for((i=0;i<${softwareCount};i++))
    do
        key=${softwareInstallKeys[${i}]}
        if test ${softwareInstallOpts[${key}]} -eq 1; then
            installSpecifiedSoftware ${key}
        fi
    done
}

function installFonts() {

    mkdir -p ~/.local/share/fonts
    rm -rf ~/.local/share/fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf

    cd ${rootDir}/resource
    cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/.local/share/fonts

    # rm MesloLGS
    rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf
    rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Bold.ttf
    rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Italic.ttf
    rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf

    # cp MesloLGS to fonts
    cp -f ./fonts/MesloLGS\ NF\ Bold\ Italic.ttf ~/.local/share/fonts
    cp -f ./fonts/MesloLGS\ NF\ Bold.ttf ~/.local/share/fonts
    cp -f ./fonts/MesloLGS\ NF\ Italic.ttf ~/.local/share/fonts
    cp -f ./fonts/MesloLGS\ NF\ Regular.ttf ~/.local/share/fonts

    # git clone https://github.com/abertsch/Menlo-for-Powerline.git ~/.local/share/fonts
    
    sudorun "sudo -S apt update"
    sudorun "sudo -S apt -y install fontconfig"
    fc-cache -vf ~/.local/share/fonts
    # sudo fc-cache -f -v

    cd ${rootDir}
}

function main() {
    colorprint "info" "ubuntu main params: $@"

    ## define variable
    proxyIpAddr="127.0.0.1"
    passwd=""
    # 软件安装标识数组
    declare -A softwareInstallOpts
    for((i=0;i<${softwareCount};i++))
    do
        key=${softwareInstallKeys[${i}]}
        softwareInstallOpts[$key]=10
    done

    while getopts ":i:hao:" opt; do
        case "${opt}" in
            "i")
                sudorun "sudo -S rm -rf /etc/profile.d/proxy.h"
                proxyIpAddr="${OPTARG}"
                ;;
            "a")
                colorprint "warning" "install all software"
                for((i=0;i<${softwareCount};i++))
                do
                    key=${softwareInstallKeys[${i}]}
                    softwareInstallOpts[${key}]=1
                done
                ;;
            "o")
                softwareStr="${OPTARG}"
                # set opt
                for((i=0;i<${#softwareStr};i++))
                do
                    installOpt="${softwareStr:$i:1}"
                    softwareInstallOpts[${installOpt}]=1
                done
                ;;
            "h"|*)
                echo "Options:"
                optPrint "-i" "set proxy IP address, default: 127.0.0.1"
                optPrint "-a" "install all necessary software"
                optPrint "-o" "choose to install software" \
                    "0: necessary" \
                    "1: vim and zsh" \
                    "2: docker" \
                    "3: vagrant and virtualbox" \
                    "c: clash" \
                    "f: fonts" \
                    "t: tmux"
                optPrint "-h" "display this help"
                colorprint "warning" "Using opt -h and canceling all operation..."
                exit 0
                ;;
        esac
    done

    prepare
    installSoftware
}

main $@



