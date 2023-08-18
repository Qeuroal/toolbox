#!/bin/bash

source ${PWD}/scripts/utils.sh


function set_global_variable() {
    # 软件个数
    software_uninstall_count=36
    software_uninstall_keys=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" \
        "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
    # echo "software_install_keys${#software_install_keys[@]}: ${software_install_keys[@]}"

    # 当前目录
    root_folder=${PWD}
    declare -A software_install_opts
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

function uninstall_software() {
    for((i=0;i<${software_uninstall_count};i++))
    do
        key=${software_uninstall_keys[${i}]}
        if test ${software_uninstalled_opts[${key}]} -eq 1; then
            install_specified_software ${key}
        fi
    done
}
