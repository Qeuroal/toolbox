#!/bin/bash

# {{{> case conversion
function to_upper() {
    echo "$@" | tr '[:lower:]' '[:upper:]'
}

function to_lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}
# <}}}

# {{{> color print functions
function color_print() {
    mode="$1"
    # 左移一位
    shift 1

    # colors
    bg_black="\033[40m"
    bg_red="\033[41m"
    bg_green="\033[42m"
    bg_yellow="\033[43m"
    bg_blue="\033[44m"
    bg_purple="\033[45m"
    bg_cyan="\033[46m"
    bg_white="\033[47m"

    fg_black="\033[30m"
    fg_red="\033[31m"
    fg_green="\033[32m"
    fg_yellow="\033[33m"
    fg_blue="\033[34m"
    fg_purple="\033[35m"
    fg_cyan="\033[36m"
    fg_white="\033[37m"

    color=""
    set_clear="\033[0m"
    set_bold="\033[1m"
    set_underline="\033[4m"
    set_flash="\033[5m"

    case "${mode}" in
        "finish")
            color="${bg_black}${fg_green}"
            ;;
        "begin")
            color="${fg_black}${fg_green}"
            ;;
        "opt")
            color="${fg_black}${fg_yellow}"
            ;;
        "error")
            color="${bg_black}${fg_red}${set_bold}"
            ;;
        "warning")
            color="${bg_yellow}${fg_black}"
            ;;
        "info")
            color="${bg_black}${fg_purple}"
            ;;
        *)
            set_clear=""
            ;;
    esac

    info="${color}===> $@${set_clear}"
    if test "${mode}" == "opt"; then
        echo -e -n "${info}"
    else
        echo -e "${info}"
    fi
}

function block_color_print() {
    mode="$1"
    mode=$(to_lower "${mode}")
    # 左移一位
    shift 1

    color="$(tput sgr0)"
    normal_color="$(tput sgr0)"

    case "${mode}" in
        "finish")
            # color="${bg_black}${fg_green}"
            color="$(tput setaf 2)"
            ;;
        "begin")
            # color="${fg_black}${fg_green}"
            color="$(tput setaf 2)"
            ;;
        "opt")
            # color="${fg_black}${fg_yellow}"
            color="$(tput setaf 3)"
            ;;
        "error")
            # color="${bg_black}${fg_red}${set_bold}"
            color="$(tput setaf 1 bold)"
            ;;
        "warning")
            # color="${bg_yellow}${fg_black}"
            color="$(tput setab 3 setaf 0)"
            ;;
        "info")
            # color="${bg_black}${fg_purple}"
            color="$(tput setaf 5)"
            ;;
        *)
            ;;
    esac

    echo "${color}"

    if test "${mode}" == "opt"; then
        echo "===> $1"
        shift 1
    else
        # echo "===> $(echo "${mode}" | tr '[:lower:]' '[:upper:]') {{{"
        echo "===> $(to_upper "${mode}") {{{"
    fi

    while test $# -ne 0
    do
        echo "  $1"
        shift 1
    done

    if test "${mode}" == "opt"; then
        printf "${normal_color}"
    else
        echo "<=== }}}${normal_color}"
        echo ''
    fi
}

function opt_print() {
    opt="$1"
    val="$2"
    
    if test -z ${opt} ; then
        return
    elif test ${#opt} -le 24; then
        printf "  %-24s%-s\n" "${opt}" "${val}"
    else
        printf "  %-24s\n    %24s%s\n" "${opt}" " " "${val}"
    fi
    
    if test $# -ge 2; then
        shift 2
    fi

    while [ $# -ne 0 ]
    do
        printf "    %24s%s\n" " " "$1"
        shift
    done
}
# <}}}

# {{{> get functions
# 获取用户信息
function get_user_info() {
    user_name=$(whoami)
}

# 获取本机 IP 地址
function get_ip() {
    ip_addr=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')
    if test "$ip_addr" = "" ; then
        ip_addr="127.0.0.1"
    fi
}

function get_passwd() {
    get_user_info
    read -s -p "[sudo] password for ${user_name}:" passwd
    echo ""
}

# 获取linux发行版名称 
# use: distro=`get_linux_distro`
function get_linux_distro() {
    if grep -Eq "Ubuntu" /etc/*-release; then
        echo "Ubuntu"
    elif grep -Eq "Deepin" /etc/*-release; then
        echo "Deepin"
    elif grep -Eq "Raspbian" /etc/*-release; then
        echo "Raspbian"
    elif grep -Eq "uos" /etc/*-release; then
        echo "UOS"
    elif grep -Eq "LinuxMint" /etc/*-release; then
        echo "LinuxMint"
    elif grep -Eq "elementary" /etc/*-release; then
        echo "elementaryOS"
    elif grep -Eq "Debian" /etc/*-release; then
        echo "Debian"
    elif grep -Eq "Kali" /etc/*-release; then
        echo "Kali"
    elif grep -Eq "Parrot" /etc/*-release; then
        echo "Parrot"
    elif grep -Eq "CentOS" /etc/*-release; then
        echo "CentOS"
    elif grep -Eq "fedora" /etc/*-release; then
        echo "fedora"
    elif grep -Eq "openSUSE" /etc/*-release; then
        echo "openSUSE"
    elif grep -Eq "Arch Linux" /etc/*-release; then
        echo "ArchLinux"
    elif grep -Eq "ManjaroLinux" /etc/*-release; then
        echo "ManjaroLinux"
    elif grep -Eq "Gentoo" /etc/*-release; then
        echo "Gentoo"
    elif grep -Eq "alpine" /etc/*-release; then
        echo "Alpine"
    else
        echo "Unknown"
    fi
}
# <}}}

# {{{> cmd relation
# 以 sudo 运行命令
function sudo_run() {
    cmd="$1"
    # color_print "warn" "passwd: $passwd, run $cmd"
    if test "${cmd}" != ""; then
        echo "${passwd}" | bash -c "${cmd}"
    fi
}
# <}}}

# {{{> file and folder operation functions
# 判断文件是否存在
function is_exist_file()
{
    local filename=$1
    if [ -f $filename ]; then
        echo 1
    else
        echo 0
    fi
}

# 判断目录是否存在
function is_exist_folder()
{
    local folder_name=$1
    if [ -d ${folder_name} ]; then
        echo 1
    else
        echo 0
    fi
}

function backup_file() {
    while test $# -ne 0
    do
        local filename=$1
        if [ $(is_exist_file "${filename}") -eq 1 ]; then
            color_print "info" "backup file: ${filename}"
            cp -f ${filename} ${filename}.backup
        fi

        shift 1
    done
}
# <}}}

# {{{> json file relation
function get_json_value() {
    local json=$1
    local key=$2

    if [[ -z "$3" ]]; then
    local num=1
    else
    local num=$3
    fi

    local value=$(echo "${json}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'${key}'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p)

    echo ${value}
}

function get_json_file_value() {
    local filename=$1
    shift 1

    echo "$@"

    local data=$(cat ${filename})
    echo "$data"
    get_json_value "${data}" "$@"
}
# <}}}


