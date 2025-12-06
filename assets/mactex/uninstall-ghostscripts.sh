uninstall_ghostscript () {
    bom_usr_local=$(pkgutil --bom $1 | grep -F Ghostscript)
    lsbom -s -f $bom_usr_local | grep -F -v ghostscript | sed 's_^\.__' | while read filename; do

	if [[ -e $filename ]]; then
	    command mv - "$filename" ~/.Trash
	else
	    echo "$filename is alreday removed."
	fi
    done
	if [[ -e "/usr/local/share/ghostscript" ]]; then
        command mv -v /usr/local/share/ghostscript ~/.Trash
	fi
}

uninstall_ghostscript $1
