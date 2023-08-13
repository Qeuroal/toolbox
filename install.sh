#!/bin/bash

source ${PWD}/scripts/utils.sh

function run_on_linux() {
    # echo "run_on_linux: $@"

    distro=`get_linux_distro`
    color_print "info" "Linux distro: ${distro}"
    case "${distro}" in 
        "Ubuntu")
            # color_print "error" "not support ${distro}"
            bash ${PWD}/scripts/run_on_ubuntu.sh "$@"
            ;;
        "Deepin")
            color_print "error" "not support ${distro}"
            ;;
        "LinuxMint")
            color_print "error" "not support ${distro}"
            ;;
        "elementaryOS")
            color_print "error" "not support ${distro}"
            ;;
        "Debian")
            color_print "error" "not support ${distro}"
            ;;
        "Raspbian")
            color_print "error" "not support ${distro}"
            ;;
        "UOS")
            color_print "error" "not support ${distro}"
            ;;
        "Kali")
            color_print "error" "not support ${distro}"
            ;;
        "Parrot")
            color_print "error" "not support ${distro}"
            ;;
        "CentOS")
            color_print "error" "not support ${distro}"
            ;;
        "fedora")
            color_print "error" "not support ${distro}"
            ;;
        "openSUSE")
            color_print "error" "not support ${distro}"
            ;;
        "ArchLinux")
            color_print "error" "not support ${distro}"
            ;;
        "ManjaroLinux")
            color_print "error" "not support ${distro}"
            ;;
        "Gentoo")
            color_print "error" "not support ${distro}"
            ;;
        "Alpine")
            color_print "error" "not support ${distro}"
            ;;
        *)
            echo "Not support linux distro: "${distro}
            ;;
    esac
}

function main() {
    # echo "main: $@"

    # 平台类型
    type=$(uname)
    color_print "info" "Platform type: "${type}


    if [ ${type} == "Darwin" ]; then
        color_print "error" "Not support now!!!"
        # installVimartOnMac
    elif [ ${type} == "FreeBSD" ]; then
        color_print "error" "Not support now!!!"
        # installVimartOnFreebsd
    elif [ ${type} == "Linux" ]; then
        tp=$(uname -a)
        if [[ $tp =~ "Android" ]]; then
            color_print "error" "Android isn't suppoted now!!!"
            # installVimartOnAndroid
        else
            run_on_linux "$@"
        fi
    else
        echo "Not support platform type: "${type}
    fi
}

main "$@"



