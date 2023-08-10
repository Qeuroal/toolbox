#!/bin/bash

source ${PWD}/scripts/utils.sh

function runOnLinux() {
    # echo "runOnLinux: "$@

    distro=`getLinuxDistro`
    colorPrint "info" "Linux distro: ${distro}"
    case "${distro}" in 
        "Ubuntu")
            # colorPrint "error" "not support ${distro}"
            bash ${PWD}/scripts/run_on_ubuntu.sh $@
            ;;
        "Deepin")
            colorPrint "error" "not support ${distro}"
            ;;
        "LinuxMint")
            colorPrint "error" "not support ${distro}"
            ;;
        "elementaryOS")
            colorPrint "error" "not support ${distro}"
            ;;
        "Debian")
            colorPrint "error" "not support ${distro}"
            ;;
        "Raspbian")
            colorPrint "error" "not support ${distro}"
            ;;
        "UOS")
            colorPrint "error" "not support ${distro}"
            ;;
        "Kali")
            colorPrint "error" "not support ${distro}"
            ;;
        "Parrot")
            colorPrint "error" "not support ${distro}"
            ;;
        "CentOS")
            colorPrint "error" "not support ${distro}"
            ;;
        "fedora")
            colorPrint "error" "not support ${distro}"
            ;;
        "openSUSE")
            colorPrint "error" "not support ${distro}"
            ;;
        "ArchLinux")
            colorPrint "error" "not support ${distro}"
            ;;
        "ManjaroLinux")
            colorPrint "error" "not support ${distro}"
            ;;
        "Gentoo")
            colorPrint "error" "not support ${distro}"
            ;;
        "Alpine")
            colorPrint "error" "not support ${distro}"
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
    colorPrint "info" "Platform type: "${type}


    if [ ${type} == "Darwin" ]; then
        colorPrint "error" "Not support now!!!"
        # installVimartOnMac
    elif [ ${type} == "FreeBSD" ]; then
        colorPrint "error" "Not support now!!!"
        # installVimartOnFreebsd
    elif [ ${type} == "Linux" ]; then
        tp=$(uname -a)
        if [[ $tp =~ "Android" ]]; then
            colorPrint "error" "Android isn't suppoted now!!!"
            # installVimartOnAndroid
        else
            runOnLinux $@
        fi
    else
        echo "Not support platform type: "${type}
    fi
}

main $@



