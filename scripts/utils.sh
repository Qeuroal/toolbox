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
    bgBlack="\033[40m"
    bgRed="\033[41m"
    bgGreen="\033[42m"
    bgYellow="\033[43m"
    bgBlue="\033[44m"
    bgPurple="\033[45m"
    bgCyan="\033[46m"
    bgWhite="\033[47m"

    fgBlack="\033[30m"
    fgRed="\033[31m"
    fgGreen="\033[32m"
    fgYellow="\033[33m"
    fgBlue="\033[34m"
    fgPurple="\033[35m"
    fgCyan="\033[36m"
    fgWhite="\033[37m"

    color=""
    setClear="\033[0m"
    setBold="\033[1m"
    setUnderline="\033[4m"
    setFlash="\033[5m"

    case "${mode}" in
        "finish")
            color="${bgBlack}${fgGreen}"
            ;;
        "begin")
            color="${fgBlack}${fgGreen}"
            ;;
        "opt")
            color="${fgBlack}${fgYellow}"
            ;;
        "error")
            color="${bgBlack}${fgRed}${setBold}"
            ;;
        "warning")
            color="${bgYellow}${fgBlack}"
            ;;
        "info")
            color="${bgBlack}${fgPurple}"
            ;;
        *)
            setClear=""
            ;;
    esac

    info="${color}===> $@${setClear}"
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
    normalColor="$(tput sgr0)"

    case "${mode}" in
        "finish")
            # color="${bgBlack}${fgGreen}"
            color="$(tput setaf 2)"
            ;;
        "begin")
            # color="${fgBlack}${fgGreen}"
            color="$(tput setaf 2)"
            ;;
        "opt")
            # color="${fgBlack}${fgYellow}"
            color="$(tput setaf 3)"
            ;;
        "error")
            # color="${bgBlack}${fgRed}${setBold}"
            color="$(tput setaf 1 bold)"
            ;;
        "warning")
            # color="${bgYellow}${fgBlack}"
            color="$(tput setab 3 setaf 0)"
            ;;
        "info")
            # color="${bgBlack}${fgPurple}"
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
        printf "${normalColor}"
    else
        echo "<=== }}}${normalColor}"
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
    userName=$(whoami)
}

# 获取本机 IP 地址
function get_ip() {
    ipAddr=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')
    if test "$ipAddr" = "" ; then
        ipAddr="127.0.0.1"
    fi
}

function get_passwd() {
    get_user_info
    read -s -p "[sudo] password for ${userName}:" passwd
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
    color_print "warn" "passwd: $passwd, run $cmd"
    if test "${cmd}" != ""; then
        echo "${passwd}" | bash -c "${cmd}"
    fi
}
# <}}}

# {{{> file and folder operation functions
# 判断文件是否存在
function is_exist_file()
{
    filename=$1
    if [ -f $filename ]; then
        echo 1
    else
        echo 0
    fi
}

# 判断目录是否存在
function is_exist_folder()
{
    dir=$1
    if [ -d $dir ]; then
        echo 1
    else
        echo 0
    fi
}

function backup_file() {
    while test $# -ne 0
    do
        fileName=$1
        if [ $(is_exist_file "${fileName}") -eq 1 ]; then
            color_print "info" "backup file: ${fileName}"
            cp -f ${fileName} ${fileName}.backup
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
    local fileName=$1
    shift 1

    echo $@

    local data=$(cat ${fileName})
    echo "$data"
    get_json_value "${data}" $@
}
# <}}}


