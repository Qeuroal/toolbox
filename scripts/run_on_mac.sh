#!/bin/bash

source ${PWD}/scripts/utils.sh


function set_global_variable() {
    # count for uninstalled software
    uninstalled_software_count=36
    # mark for uninstalled software
    uninstalled_software_keys=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" \
        "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
    # define associative array
    declare -gA uninstalled_software_opts
    for((i=0;i<${uninstalled_software_count};i++))
    do
        key=${uninstalled_software_keys[${i}]}
        uninstalled_software_opts[$key]=0
    done
    # root_folder: current folder
    root_folder=${PWD}
    color_print "info" "project root dir: $root_folder"
    # proxy ip
    proxy_ip_addr="127.0.0.1"
    # user passwd
    passwd=""
}

# {{{> 获取选项
function get_user_opts() {
    while getopts ":i:hd:" opt; do
        case "${opt}" in
            "i")
                proxy_ip_addr="${OPTARG}"
                ;;
            "d")
                softwareStr="${OPTARG}"
                # set opt
                for((i=0;i<${#softwareStr};i++))
                do
                    installOpt="${softwareStr:$i:1}"
                    uninstalled_software_opts[${installOpt}]=1
                done
                ;;
            "h"|*)
                echo "Options:"
                opt_print "-i" "set proxy IP address, default: 127.0.0.1"
                opt_print "-d" "choose to install software" \
                    "v: vscode"
                opt_print "-h" "display this help"
                color_print "warning" "Using opt -h and canceling all operation..."
                exit 0
                ;;
        esac
    done
}
# <}}}

function get_require_info() {
    get_passwd
}

function set_require_info() {
    echo "set_require_info"
}

function uninstall_specified_software() {
    case "$1" in
        "v")
            color_print "warning" "uninstalling vscode and clearning vscode config"
            # sudo rm -rf $HOME/Library/Application\ Support/Code
            # sudo rm -rf $HOME/Library/Application\ Support/Code\ -\ Insiders/
            # sudo rm -rf $HOME/.vscode
            # sudo rm -rf $HOME/.vscode-insiders/
            ;;
        *)
            color_print "error" "not support key \"${key}\""
            ;;
    esac
}

function uninstall_software() {
    for((i=0;i<${uninstalled_software_count};i++))
    do
        key=${uninstalled_software_keys[${i}]}
        if test "${uninstalled_software_opts[${key}]}" = "1"; then
            uninstall_specified_software ${key}
        fi
    done

}

function install_software() {
    echo "install_software"
}


function main() {
    color_print "info" "mac main params: $@"

    set_global_variable
    get_user_opts "$@"

    get_require_info
    set_require_info

    uninstall_software
    install_software
}

main "$@"




