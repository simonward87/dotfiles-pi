# Variables
export DOTFILES="$HOME/.dotfiles"
export EDITOR="/usr/bin/vim"
export VISUAL="$EDITOR"
export ZPLUG_HOME="$HOME/.zplug"

# Options (man zshoptions)
setopt NO_CASE_GLOB
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL
setopt EXTENDED_HISTORY
unsetopt BEEP

# Aliases
alias df='df -h'
alias dtfs='cd $DOTFILES; vim .'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias la='ls -AFho --color --group-directories-first'
alias ll='ls -Fho --color --group-directories-first'
alias ls='ls -F --color --group-directories-first'
alias ts='tmux new -s "${PWD##*/}"'
alias trail='<<<${(F)path}'

# Customised prompt
# PROMPT='
# %(?.%F{green}%m%f.%F{red}[%?] %m%f) %1~ %# '
PROMPT='
%(?.%F{245}%m%f.%F{red}[%?]%f %F{245}%m%f) %1~ %# '
# Git integration
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
