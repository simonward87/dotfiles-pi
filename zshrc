# Variables
export DOTFILES="$HOME/.dotfiles"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=40960
export HISTIGNORE=":pwd:id:uptime:resize:ls:clear:history"
export HISTSIZE=10000
export PATH=$PATH:/usr/sbin:/usr/local/go/bin
export VISUAL="$EDITOR"

if command -v cargo &> /dev/null; then
    export CARGO_HOME="$HOME/.cargo"
    export PATH=$PATH:$CARGO_HOME/bin
fi

if command -v go &> /dev/null; then
    export GOBIN="$(go env GOPATH)/bin"
    export GOPATH="$(go env GOPATH)"
    export PATH=$PATH:$GOBIN
fi

if command -v zplug &> /dev/null; then
    export ZPLUG_HOME="$HOME/.zplug"
fi

if command -v vim &> /dev/null; then
    export EDITOR="$(which vim)"
else
    export EDITOR="$(which vi)"
fi

# Options (man zshoptions)
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL
setopt EXTENDED_HISTORY
setopt NO_CASE_GLOB
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

# Customised prompt
if [ $HOST = "MacBook-Air.localdomain" ]; then
    PROMPT="%(?..%F{red}[%?] %f)%2~ %# "
else
    # Shows hostname in prompt when using remote machines
    PROMPT="%(?.%F{245}%m%f.%F{red}[%?]%f %F{245}%m%f) %2~ %# "
fi

# prepend new-line to prompt
precmd() $funcstack[1]() echo

# Git prompt integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{245}(%b) %r%f'
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
source $CARGO_HOME/env

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

# Case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 
