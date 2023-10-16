# Variables
export DOTFILES="$HOME/.dotfiles"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=40960
export HISTIGNORE=":pwd:id:uptime:resize:ls:clear:history"
export HISTSIZE=10000
export PATH=$PATH:/usr/sbin:$HOME/.local/bin:/usr/local/go/bin
export ZPLUG_HOME="$HOME/.zplug"

if command -v rustup &> /dev/null; then
    export CARGO_HOME="$HOME/.cargo"
    export PATH=$PATH:$CARGO_HOME/bin
    export RUSTUP_HOME="$HOME/.rustup"

    source $CARGO_HOME/env
fi

if command -v go &> /dev/null; then
    export GOBIN="$(go env GOPATH)/bin"
    export GOPATH="$(go env GOPATH)"
    export PATH=$PATH:$GOBIN
fi

if command -v nvim &> /dev/null; then
    export EDITOR="$(which nvim)"
elif command -v vim &> /dev/null; then
    export EDITOR="$(which vim)"
else
    export EDITOR="$(which vi)"
fi

export VISUAL="$EDITOR"

# Options (man zshoptions)
setopt AUTO_CD # auto cd when a command is a directory name
setopt CD_SILENT # never print directory when cd -
setopt CORRECT # try to correct command spelling
setopt CORRECT_ALL # try to correct argument spelling
setopt EXTENDED_HISTORY # save command timestamps
setopt HIST_IGNORE_DUPS # don't add duplicate commands to history
setopt HIST_EXPIRE_DUPS_FIRST # remove oldest duplicates first when trimming
setopt HIST_NO_STORE # remove history command from list when invoked
setopt NO_CASE_GLOB # case-insensitive glob
unsetopt BEEP

# Aliases
alias df='df -h'
alias dtfs='cd $DOTFILES; vim .'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias la='ls -AFho --color --group-directories-first'
alias ll='ls -Fho --color --group-directories-first'
alias ls='ls -1F --color --group-directories-first'
alias trail='<<<${(F)path}'
alias vi=$EDITOR
alias vim=$EDITOR

# dark mode
export CLR_COMMENT="#91A2B0"
export CLR_ERROR="#ff9aa0"

# light mode
# export CLR_COMMENT="#6B6A64"
# export CLR_ERROR="#c1002f"

# custom prompt
PROMPT="%(?.%F{$CLR_COMMENT}%m%f.%F{$CLR_ERROR}[%?]%f %F{$CLR_COMMENT}%m%f) %2~ %# "

# prepend new-line to prompt
precmd() $funcstack[1]() echo

# Git prompt integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats "%F{$CLR_COMMENT} %b%f" # '%F{245}%r (%b)%f'
zstyle ':vcs_info:*' enable git


# Remove $PATH duplicates
typeset -U path

# Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

function hgrep() {
  fc -Dlim "*$@*" 1
}

# # Plugins
source $ZPLUG_HOME/init.zsh

zplug 'le0me55i/zsh-extract'
zplug 'plugins/git', from:oh-my-zsh
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-history-substring-search'

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

# Other
fpath=(~/.zsh $fpath)
autoload -Uz compinit
compinit -u

# command completion bindings
bindkey '^N' autosuggest-accept  # ctrl+n
bindkey '^T' autosuggest-toggle  # ctrl+t
bindkey '^Y' autosuggest-execute # ctrl+y

# Case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 
