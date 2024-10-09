## for reference
## https://gist.github.com/smari/176b256c819ffe82e1d1fe07d1d49971
set -e

if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

apt install build-essential tmux pkg-config automake binutils

apt install ccze jp2a moreutils apt-file speedometer tree mosh whois avahi-utils
apt install git tig git-annex
apt install libsixel-bin
##install neovim
# requirement for add-apt-repository
apt-get install software-properties-common
# add repo
add-apt-repository -y ppa:neovim-ppa/stable
apt-get update
# install neovim itself
apt-get install neovim
# install python for plugins etc
apt-get install python-dev python-pip python3-dev python3-pip
#install nim
#curl -O https://nim-lang.org/somrthing
# then add to path. Best place is .profile?
# set as default
# not sure how to make this not ask me for confirmation after I've done it once
update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
update-alternatives --config vi
update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
update-alternatives --config vim
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
update-alternatives --config editor

sudo -u $real_user install_dotfiles.sh
sudo -u $real_user install_neovim_plugins.sh

