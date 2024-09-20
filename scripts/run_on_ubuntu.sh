#!/bin/bash

source ${PWD}/scripts/utils.sh

proxyPath="/opt/proxy.sh"
# {{{> set global variable
function set_global_variable() {
    # 软件个数
    software_count=36
    software_install_keys=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" \
        "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
    # echo "software_install_keys${#software_install_keys[@]}: ${software_install_keys[@]}"

    # 软件安装标识数组
    declare -gA software_install_opts
    for((i=0;i<${software_count};i++))
    do
        key=${software_install_keys[${i}]}
        software_install_opts[$key]=0
    done

    # 当前目录
    root_folder=${PWD}
    color_print "info" "project root dir: $root_folder"

    # proxy ip
    proxy_ip_addr="127.0.0.1"
    # user passwd
    passwd=""
}
# <}}}

# {{{> 获取选项
function get_user_opts() {
    while getopts ":i:hao:" opt; do
        case "${opt}" in
            "i")
                # sudo_run "sudo -S rm -rf /etc/profile.d/proxy.h"
                proxy_ip_addr="${OPTARG}"
                ;;
            "a")
                color_print "warning" "install all software"
                for((i=0;i<${software_count};i++))
                do
                    key=${software_install_keys[${i}]}
                    software_install_opts[${key}]=1
                done
                ;;
            "o")
                softwareStr="${OPTARG}"
                # set opt
                for((i=0;i<${#softwareStr};i++))
                do
                    installOpt="${softwareStr:$i:1}"
                    software_install_opts[${installOpt}]=1
                done
                ;;
            "h"|*)
                echo "Options:"
                opt_print "-i" "set proxy IP address, default: 127.0.0.1"
                opt_print "-a" "install all necessary software"
                opt_print "-o" "choose to install software" \
                    "0: necessary" \
                    "1: vim" \
                    "2: zsh" \
                    "3: docker" \
                    "4: vagrant and virtualbox" \
                    "a: anaconda config" \
                    "c: clash" \
                    "f: fonts" \
                    "v: valgrind" \
                    "t: tmux"
                opt_print "-h" "display this help"
                color_print "warning" "Using opt -h and canceling all operation..."
                exit 0
                ;;
        esac
    done
}
# <}}}

function set_proxy() {
    # judge exist proxy file
    if test "$(is_exist_file "$proxyPath")" = 1 -a "${proxy_ip_addr}" = "127.0.0.1"; then
        color_print "warning" "canceling to add proxy.sh"
        return
    else
        color_print "info" "adding proxy.sh"
    fi

    # {{{> generate proxy file
    filename="proxy_$(date +%s).sh"
    echo "rm -rf ${filename}"
    
    echo "export HTTP_PROXY=\"http://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export HTTPS_PROXY=\"http://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export FTP_PROXY=\"http://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export ALL_PROXY=\"socks://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export NO_PROXY=\"localhost,127.0.0.0/8,::1\"" >> ./${filename}

    echo "export http_proxy=\"http://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export https_proxy=\"http://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export ftp_proxy=\"http://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export all_proxy=\"socks://${proxy_ip_addr}:7890/\"" >> ./${filename}
    echo "export no_proxy=\"localhost,127.0.0.0/8,::1\"" >> ./${filename}

    chmod +x ${filename}
    echo "${passwd}" | sudo -S mv ${filename} $proxyPath
    # sudo_run "chmod +x $proxyPath"
    # <}}}

    source $proxyPath
}

function get_require_info() {
    # get passwd
    get_passwd

    # get user info
    get_user_info
    color_print "info" "user_name: ${user_name}"

    # get ip
    get_ip
    color_print "info" "ip: ${ip_addr}"
}

function set_require_info() {
    # set proxy
    set_proxy
}

function install_vim() {
    git clone https://github.com/Qeuroal/vimart.git ~/vimart
    cd ~/vimart
    # yes y | bash scripts/install.sh
    bash scripts/install.sh
    color_print "warning" "If you choose to install YouCompleteMe, please run:\n\tpython3 ~/.vim/plugged/YouCompleteMe/install.py --all --verbose"
    cd ${root_folder}

    # 设置国内代理
    # go env -w GOPROXY=https://goproxy.cn

    # 安装 YouCompleteMe-all
    # python3 ~/.vim/plugged/YouCompleteMe/install.py --all --verbose
}

function install_zsh() {
    sudo_run "sudo -S apt update"
    sudo_run "sudo -S apt -y install zsh autojump"
    sudo_run "chsh -s /bin/zsh"

    # yes y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	source $proxyPath

    installOpt=n
    read -n1 -p "Would you like to install oh-my-zsh? [y/n]" installOpt
    echo ""
    if [ "${installOpt}" = 'y' -o "${installOpt}" = 'Y' ]; then
        # echo -e "\033[31m===> Canceling install ycm...\033[0m"
        color_print "Info" "Installing oh-my-zsh..."

        curl -JL -o install_oh_my_zsh.sh  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
        yes y | bash install_oh_my_zsh.sh \
            && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k \
            && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
            && git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
            && rm -rf install_oh_my_zsh.sh
    else
        color_print "Info" "Installing zim..."
        curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

        if test `cat ~/.zimrc | grep -c 'zmodule romkatv/powerlevel10k'` = 0
        then
            echo "" | tee -a ~/.zimrc > /dev/null
            echo 'zmodule romkatv/powerlevel10k' | tee -a ~/.zimrc > /dev/null
        fi
    fi

    # config
    if test `cat ${HOME}/.zshrc | grep -c "# import aliases"` = 0
    then
        echo "" | tee -a ${HOME}/.zshrc > /dev/null
        echo '# import aliases' | tee -a ${HOME}/.zshrc > /dev/null
        # echo 'if [[ -f ~/.aliases ]]; then {source ~/.aliases}; fi'
        echo '[[ -f ~/.aliases ]] && source ~/.aliases' | tee -a ${HOME}/.zshrc > /dev/null
        echo "" | tee -a ${HOME}/.zshrc > /dev/null
    fi

    # copy config
    if [[ ! -f ~/.aliases ]]; then
        ln -s ${PWD}/assets/aliases/.aliases ~/.aliases
    else
        overlayOpt=n
        read -n1 -p 'Would you like to overlay ~/.aliases? [y/n]' installOpt
        echo ""
        if [ "${installOpt}" = 'y' -o "${installOpt}" != 'Y' ]; then
            rm -f ~/.aliases
            ln -s ${PWD}/assets/aliases/.aliases ~/.aliases
        fi
    fi
}

function install_docker() {
    sudo_run "sudo -S apt update"
    sudo_run "yes y | sudo -S apt remove docker docker-engine docker.io"

    # ##  使用 APT 安装
    # # 添加使用 HTTPS 传输的软件包以及 CA 证书
    # sudo_run "yes y | sudo -S apt install apt-transport-https ca-certificates curl gnupg lsb-release"

    # # 设置国内源
    # # curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # # 向 sources.list 中添加 Docker 软件源
    # # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # # 向 sources.list 中添加 Docker 软件源
    # filename="docker_tmp_$(date +%s)"
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee ./${filename}.list > /dev/null
    # sudo_run "sudo -S mv ./${filename}.list /etc/apt/sources.list.d/docker.list"

    # # 安装 docker
    # sudo_run "sudo -S apt update"
    # sudo_run "yes y | sudo -S apt install docker-ce docker-ce-cli containerd.io"

    ## 脚本自动安装 docker
    curl -fsSL get.docker.com -o get-docker.sh
    # sudo sh get-docker.sh --mirror Aliyun
    sudo_run "sudo -S bash get-docker.sh"

    # 启动 Docker
    sudo_run "sudo -S systemctl enable docker"
    sudo_run "sudo -S systemctl start docker"

    # 建立 docker 用户组
    sudo_run "sudo -S groupadd docker"
    sudo_run "sudo -S usermod -aG docker $USER"

    # 测试 Docker 是否安装正确
    # docker run --rm hello-world
}

function install_anaconda() {
    echo "手动配置anaconda环境:"
    echo "- 设置conda的base环境不自动激活: conda config --set auto_activate_base false"
    echo "- 设置bash或zshSHELL环境下的conda配置: eval \"\$(<YOUR_ANACONDA_PATH>/bin/conda shell.<YOUR_SHELL_NAME> hook)\""
    echo "    如: eval \"\$(/home/qeuroal/anaconda3/bin/conda shell.zsh hook)\""
    echo "- 运行: conda init zsh (recommand) 或 conda init (not recommand: default modify .bashrc)"
}

function install_vagrant_and_virtualbox() {
    # 安装 virtualbox
    sudo_run "sudo -S apt -y install virtualbox"

    # 安装 vagrant
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo_run "sudo -S apt update"
    sudo_run "sudo -S apt -y install vagrant"

}

function install_clash() {
    chmod +x ${root_folder}/assets/clash
    sudo_run "sudo -S mv ${root_folder}/assets/clash /usr/local/bin/"

    color_print "warning" "Please do following steps:"
    echo " 1. 执行 clash 进行初始化"
    echo " 2. 生成配置文件 ~/.config/clash/config.yaml 后, 使用 ctrl + c 退出clash"
    echo " 3. 基于订阅地址下载配置: curl -L <订阅地址> -o ~/.config/clash/config.yaml"
    echo " 4. 打开网址: yacd.haishan.me 修改节点等信息"
}

function install_tmux() {
    # install software
    sudo_run "sudo -S apt update"
    sudo_run "sudo -S apt -y install tmux"

    ## mehthod 1
    # set conf
    backup_file "${HOME}/.tmux.conf"
    backup_file "${HOME}/.tmux.conf.local"
    rm -rf ~/.tmux.conf
    rm -rf ~/.tmux.conf.local
    cp -f ${root_folder}/assets/tmux/tmux.conf ~/.tmux.conf
    # cp -f ${root_folder}/assets/tmux/tmux.conf.local ~/.tmux.conf.local
    yes y | tmux kill-server -a

    ## method 2
    # git clone https://github.com/gpakosz/.tmux.git ~/.tmux
    # rm -rf ~/.tmux.conf
    # rm -rf ~/.tmux.conf.local
    # ln -sf "${HOME}/.tmux/.tmux.conf" ~/.tmux.conf
    # ln -sf "${HOME}/.tmux/.tmux.conf.local" ~/.tmux.conf.local
}

function install_valgrind()
{

    echo "install_valgrind"
    # return
    # install software
    sudo_run "sudo -S apt update"

    # download valgrind
    filename="valgrind-3.21.0"
    wget https://sourceware.org/pub/valgrind/${filename}.tar.bz2
    if test "$(is_exist_file "${filename}.tar.bz2")" = 0
    then
        return
    fi

    # tidy
    mkdir valgrind_tmp
    mv valgrind-*.tar.bz2 valgrind_tmp
    cd valgrind_tmp
    color_print "info" "$PWD"

    # unzip
    bzip2 -d ${filename}.tar.bz2
    tar -xf ${filename}.tar
    cd ${filename}

    # install
    ./configure && make
    sudo_run "sudo -S make install"

    # remove folder unused
    cd ${root_folder}
    color_print "info" "$PWD"
    rm -rf valgrind_tmp
}

function install_specified_software() {
    case "$1" in
        "0")
            color_print "info" "installing necessary software"
            sudo_run "sudo -S apt update"
            sudo_run "sudo -S apt -y install git curl wget vim"
            ;;
        "1")
            # vim
            color_print "info" "installing Vim"
            install_vim
            ;;
        "2")
            # zsh
            color_print "info" "installing Zsh"
            install_zsh
            ;;
        "3")
            # docker
            color_print "info" "installing Dokcer"
            install_docker
            ;;
        "4")
            color_print "info" "installing vagrant and virtualbox"
            ;;
        "a")
            color_print "info" "configuring anaconda environment"
            install_anaconda
            ;;
        "c")
            color_print "info" "installing clash"
            install_clash
            ;;
        "f")
            color_print "info" "installing fonts"
            install_fonts
            ;;
        "v")
            color_print "info" "installing valgrind"
            install_valgrind
            ;;
        "t")
            color_print "info" "installing tmux"
            install_tmux
            ;;
        *)
            color_print "error" "not support key \"${key}\""
            ;;
    esac
}

# install software
function install_software() {
    for((i=0;i<${software_count};i++))
    do
        key=${software_install_keys[${i}]}
        if test "${software_install_opts[${key}]}" = "1"; then
            install_specified_software ${key}
        fi
    done
}

function install_fonts() {

    mkdir -p ~/.local/share/fonts

    cd ${root_folder}/assets

    # install Droid Sans Mono Nerd Font Complete
        # rm -rf ~/.local/share/fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf
        # cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/.local/share/fonts
    rm -rf ~/.local/share/fonts/droid_sans_mono
    cp -rf ./fonts/droid_sans_mono ~/.local/share/fonts/

    # install MesloLGS
        # rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf
        # rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Bold.ttf
        # rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Italic.ttf
        # rm -rf ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf

        # cp -f ./fonts/MesloLGS\ NF\ Bold\ Italic.ttf ~/.local/share/fonts
        # cp -f ./fonts/MesloLGS\ NF\ Bold.ttf ~/.local/share/fonts
        # cp -f ./fonts/MesloLGS\ NF\ Italic.ttf ~/.local/share/fonts
        # cp -f ./fonts/MesloLGS\ NF\ Regular.ttf ~/.local/share/fonts
    rm -rf ~/.local/share/fonts/meslolgs
    cp -rf ./fonts/meslolgs ~/.local/share/fonts/

    # git clone https://github.com/abertsch/Menlo-for-Powerline.git ~/.local/share/fonts

    # install JetBrainsMono
        # rm -rf ~/.local/share/fonts/JetBrainsMono\-Regular.ttf
        # rm -rf ~/.local/share/fonts/JetBrainsMonoNL\-Regular.ttf

        # cp -f ./fonts/JetBrainsMonoNL\-Regular.ttf ~/.local/share/fonts
        # cp -f ./fonts/JetBrainsMono\-Regular.ttf ~/.local/share/fonts
    rm -rf ~/.local/share/fonts/jetbrainsmono
    cp -rf ./fonts/jetbrainsmono ~/.local/share/fonts/

    sudo_run "sudo -S apt update"
    sudo_run "sudo -S apt -y install fontconfig"
    fc-cache -vf ~/.local/share/fonts
    # sudo fc-cache -f -v

    cd ${root_folder}
}

function main() {
    color_print "info" "ubuntu main params: $@"

    set_global_variable

    get_user_opts "$@"

    get_require_info
    set_require_info

    install_software
}

main "$@"



