# Sensible, short .zshrc
# Gist page: git.io/vSBRk  
# Raw file:  curl -L git.io/sensible-zshrc
# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
# for profiling
# zmodload zsh/zprof
typeset -A __NONNI
# GNU and BSD (macOS) ls flags aren't compatible
ls --version &>/dev/null
if [ $? -eq 0 ]; then
  lsflags="--color --group-directories-first -F"
else
  lsflags="-GF"
  export CLICOLOR=1
fi

# Aliases
alias ls="ls ${lsflags}"
alias ll="ls ${lsflags} -l"
alias la="ls ${lsflags} -la"
alias h="history"
alias hg="history -1000 | grep -i"
# alias ,="cd .."
alias m="less"

# GIT
# Do this: git config --global url.ssh://git@github.com/.insteadOf https://github.com
alias gd="git diff"
alias gs="git status 2>/dev/null"
# function gc() { git clone ssh://git@github.com/"$*" }
# function gg() { git commit -m "$*" }

# Maybe more suitable for .zshenv
EDITOR=vim
PROMPT='%n@%m %3~%(!.#.$)%(?.. [%?]) '

# Having APPDATA set in WSL will wreak havoc with at lot of dotnet stuff
unset APPDATA

# History settings
# HISTFILE=~/.history-zsh
HISTSIZE=10000
SAVEHIST=10000

mkdir -p "$XDG_STATE_HOME"/zsh

HISTFILE="$XDG_STATE_HOME"/zsh/history

setopt append_history           # allow multiple sessions to append to one history
setopt bang_hist                # treat ! special during command expansion
setopt extended_history         # Write history in :start:elasped;command format
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_space        # prefix command with a space to skip it's recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt inc_append_history       # Write to history file immediately, not when shell quits
setopt share_history            # Share history among all sessions

# set compdump in XDG_CACHE_HOME
mkdir -p "$XDG_CACHE_HOME"/zsh

# zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

# Tab completion
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses
setopt autocd                   # cd to a folder just by typing it's name
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&' # These "eat" the auto prior space after a tab complete

# MISC
setopt interactive_comments     # allow # comments in shell; good for copy/paste
unsetopt correct_all            # I don't care for 'suggestions' from ZSH
export BLOCK_SIZE="'1"          # Add commas to file sizes

# BINDKEY
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' '  magic-space

autoload -U add-zsh-hook

# Remember each command we run.
function -record-command() {
  __NONNI[LAST_COMMAND]="$2"
}

# preexec runs after enter, before actually running
add-zsh-hook preexec -record-command

function nonni_git_status() {
  nonni_git_info_msg_="sdf"
}
# Update vcs_info (slow) after any command that probably changed it.
function -maybe-show-vcs-info() {
  local LAST="$__NONNI[LAST_COMMAND]"

  # In case user just hit enter, overwrite LAST_COMMAND, because preexec
  # won't run and it will otherwise linger.
  __NONNI[LAST_COMMAND]="<unset>"

  # Check first word; via:
  # http://tim.vanwerkhoven.org/post/2012/10/28/ZSH/Bash-string-manipulation
  case "$LAST[(w)1]" in
    cd|cp|git|rm|touch|mv)
      nonni_git_status
      ;;
    *)
      ;;
  esac
}

add-zsh-hook precmd nonni_git_status
#
# Prompt
#

autoload -U colors
colors

RPROMPT_BASE='${nonni_git_info_msg_}%F{blue}%~%f'
setopt PROMPT_SUBST

# Anonymous function to avoid leaking variables.
# Anonymous functions are executed right away and are used to define scopes
function () {
  # Check for tmux by looking at $TERM, because $TMUX won't be propagated to any
  # nested sudo shells but $TERM will.
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    # In a a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 1))
  elif [ -n "$XAUTHORITY" ]; then
    # Probably in X on Linux.
    local LVL=$(($SHLVL - 2))
  else
    # Either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$SHLVL
  fi
  local SUFFIX='%(!.%F{yellow}%n%f.)%(!.%F{yellow}.%F{red})'$(printf '\u276f%.0s' {1..$LVL})'%f'

  export PS1="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b%F{blue}%B%1~%b%F{yellow}%B%(1j.*.)%(?..!)%b%f %B${SUFFIX}%b "
  if [[ -n "$TMUXING" ]]; then
    # Outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}

export RPROMPT=$RPROMPT_BASE
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# unsure about this
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# export JIRA_API_TOKEN=MTE0NzkwNjg1OTYyOlwRgehCqO6ekLW2irRwnClZh903
# export JIRA_AUTH_TYPE=bearer

# eval "$(fasd --init auto)"

# for some reason eval was very slow. So I ran it and created this cache instead
# eval "$(zoxide init zsh)"
[ -f ~/.config/zsh/zoxide_functions.zsh ] && source ~/.config/zsh/zoxide_functions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# zprof