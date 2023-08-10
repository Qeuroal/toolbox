#!/bin/bash

source ${PWD}/scripts/utils.sh

function runOnLinux() {
    # echo "runOnLinux: "$@

    distro=`getLinuxDistro`
    colorprint "info" "Linux distro: ${distro}"
    case "${distro}" in 
        "Ubuntu")
            # colorprint "error" "not support ${distro}"
            bash ${PWD}/scripts/run_on_ubuntu.sh $@
            ;;
        "Deepin")
            colorprint "error" "not support ${distro}"
            ;;
        "LinuxMint")
            colorprint "error" "not support ${distro}"
            ;;
        "elementaryOS")
            colorprint "error" "not support ${distro}"
            ;;
        "Debian")
            colorprint "error" "not support ${distro}"
            ;;
        "Raspbian")
            colorprint "error" "not support ${distro}"
            ;;
        "UOS")
            colorprint "error" "not support ${distro}"
            ;;
        "Kali")
            colorprint "error" "not support ${distro}"
            ;;
        "Parrot")
            colorprint "error" "not support ${distro}"
            ;;
        "CentOS")
            colorprint "error" "not support ${distro}"
            ;;
        "fedora")
            colorprint "error" "not support ${distro}"
            ;;
        "openSUSE")
            colorprint "error" "not support ${distro}"
            ;;
        "ArchLinux")
            colorprint "error" "not support ${distro}"
            ;;
        "ManjaroLinux")
            colorprint "error" "not support ${distro}"
            ;;
        "Gentoo")
            colorprint "error" "not support ${distro}"
            ;;
        "Alpine")
            colorprint "error" "not support ${distro}"
            ;;
        *)
            echo "Not support linux distro: "${distro}
            ;;
    esac
}

function main() {
    # echo "main: "$@

    # 平台类型
    type=$(uname)
    colorprint "info" "Platform type: "${type}


    if [ ${type} == "Darwin" ]; then
        colorprint "error" "Not support now!!!"
        # installVimartOnMac
    elif [ ${type} == "FreeBSD" ]; then
        colorprint "error" "Not support now!!!"
        # installVimartOnFreebsd
    elif [ ${type} == "Linux" ]; then
        tp=$(uname -a)
        if [[ $tp =~ "Android" ]]; then
            colorprint "error" "Android isn't suppoted now!!!"
            # installVimartOnAndroid
        else
            runOnLinux $@
        fi
    else
        echo "Not support platform type: "${type}
    fi
}

main $@



