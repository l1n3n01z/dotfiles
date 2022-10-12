# set xdg base directories if they are not defined
if [[ -z "$XDG_CONFIG_HOME" ]]
then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -z "$XDG_CACHE_HOME" ]]
then
  export XDG_CACHE_HOME="$HOME/.cache"
fi

if [[ -z "$XDG_DATA_HOME" ]]
then
  export XDG_DATA_HOME="$HOME/.local/share"
fi

if [[ -z "$XDG_STATE_HOME" ]]
then
  export XDG_STATE_HOME="$HOME/.local/state"
fi

# use ~/.config/zsh for all zsh files
if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en
export LC_TIME=en_AU.UTF-8

if [[ $(uname -s) = Darwin ]]; then
  # Override insanely low open file limits on macOS.
  ulimit -n 65536
  ulimit -u 1064

  # Mitigate: https://github.blog/2022-04-12-git-security-vulnerability-announced/
  export GIT_CEILING_DIRECTORIES=/Users
else
  export GIT_CEILING_DIRECTORIES=/home
fi

# path
# this removes the windows paths.
# unfortunately it disables a few things like win32yank
# path=( ${path[@]:#/mnt/c/*} )
path=('/opt/mssql-tools/bin' $path)
path=("$HOME/.cargo/bin" $path)
path=("$HOME/.poetry/bin" $path)
path=("$HOME/.local/bin" $path)

# PATH
typeset -U path                 # keep duplicates out of the path

