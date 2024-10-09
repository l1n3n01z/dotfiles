# TODO why is this commented out?
# maybe easier to just use win32yank?
# clipcopy () {
#   clip.exe < "${1:-/dev/stdin}"
# }
#
clippaste () {
  powershell.exe -noprofile -command Get-Clipboard
}


firefox () {
    pushd /mnt/c >/dev/null
    cmd.exe /c start "firefox" "$1" > /dev/null
    popd >/dev/null
}

wsl-open () {
#note, does not support international URIs
#note, using the firefox function is so much faster as it bypasses powershell
#only open http(s) url in firefox
    regex='https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    if [[ $1 =~ $regex ]]
    then 
        firefox $1
    else
        wslview $1 > /dev/null
    fi
}

#timestamp minutes
tsm () {
    date +'%Y-%m-%d %H:%M'
}

urlencode() {
  python3 -c "import sys, urllib.parse as u;print(u.quote_plus(sys.argv[1]))"  "$*"
}

# lazynvm() {
#   unset -f nvm node npm
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# }
#
# nvm() {
#   lazynvm 
#   nvm $@
# }
#
# node() {
#   lazynvm
#   node $@
# }
#
# npm() {
#   lazynvm
#   npm $@
# }
#
# npx() {
#   lazynvm
#   npx $@
# }
#
# yarn() {
#   lazynvm
#   yarn $@
# }
