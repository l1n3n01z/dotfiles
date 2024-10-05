# this is a bit of a mess, but we need to do this for all shells
#
# the idea here is that in wsl we get way too much windows crud in the PATH
# and some of it is not very nice to have in the path

# echo $PATH
# echo ble
# echo $fish_user_path
# so let's rebuild the path by invert matching our current path and
# get rid of stuff from windows
set -gx PATH (string match -v '/mnt/c/*' $PATH)

# echo $PATH
# echo ble2
# echo $fish_user_path
# we do want winyank32 from scoop, but at the end 
# -a is for append and -P is for manipulating the PATH and not fish_user_path
fish_add_path -aP /mnt/c/Users/ori.jont/scoop/shims
# fish_add_path -aP /mnt/c/Users/ori.jont/scoop/shims/win32yank.exe
# and some windows stuff
fish_add_path -aP /mnt/c/Windows/System32

if status is-login
    echo "we are a login shell"

    if not set -q XDG_CONFIG_HOME
        set -gx XDG_CONFIG_HOME $HOME/.config
    end
    if not set -q XDG_CACHE_HOME
        set -gx XDG_CACHE_HOME $HOME/.cache
    end
    if not set -q XDG_DATA_HOME
        set -gx XDG_DATA_HOME $HOME/.local/share
    end
    if not set -q XDG_STATE_HOME
        set -gx XDG_STATE_HOME $HOME/.local/state
    end
    if not set -q XDG_BIN_HOME
        set -gx XDG_BIN_HOME $HOME/.local/bin
    end
    set -gx BROWSER firefox
    set -gx EDITOR nvim
    set -gx ZK_NOTEBOOK_DIR $HOME/vimwiki

    if string match -q -e microsoft (uname -r)
        # Override insanely low open file limits on WSL2
        ulimit -Sn 65536
        # Mitigate: https://github.blog/2022-04-12-git-security-vulnerability-announced/
        export GIT_CEILING_DIRECTORIES=/home

        # https://nickjanetakis.com/blog/install-docker-in-wsl-2-without-docker-desktop
        # start up docker on login
        # though this does seem a bit fragile tbh

        # if service docker status 2>&1 | grep -q "is not running"
        #     wsl.exe --distribution "$WSL_DISTRO_NAME" --user root --exec /usr/sbin/service docker start >/dev/null 2>&1
        # end
    else if test (uname -s) = Darwin
        # Override insanely low open file limits on macOS.
        ulimit -n 65536
        ulimit -u 1064

        export GIT_CEILING_DIRECTORIES=/Users
    else
        export GIT_CEILING_DIRECTORIES=/home
    end

    set -e APPDATA

    fish_add_path /opt/mssql-tools/bin
    fish_add_path -p $HOME/.dotnet/tools
    fish_add_path -p $HOME/.cargo/bin
    fish_add_path -p $HOME/.poetry/bin
    fish_add_path -p $XDG_BIN_HOME
    fish_add_path -p $HOME/.tmuxifier/bin
    # Set PATH, MANPATH, etc., for Homebrew.
    # is it sufficient to do this in a login shell?
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    eval ($HOME/.tmuxifier/bin/tmuxifier init - fish)
end


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/nonni/.opam/opam-init/init.fish' && source '/home/nonni/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true
# END opam configuration
