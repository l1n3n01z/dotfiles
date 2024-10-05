function winfirefox
    # push the c directory because cmd.exe does not support linux paths
    set url (string replace -a '&' '^&' $argv[1])
    pushd /mnt/c >/dev/null
    cmd.exe /c start firefox $url >/dev/null
    popd >/dev/null
end
