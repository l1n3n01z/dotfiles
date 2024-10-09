## for reference
## https://gist.github.com/smari/176b256c819ffe82e1d1fe07d1d49971
set -e

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

apt install ccze

echo $real_user
