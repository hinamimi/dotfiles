### Set Prompt ###

## prompt表示
# --example
# usr-name_Green:curent-directory_Cian (git-branch)_Purple yy/mm/dd HH:MM:SS_Yellow
# $ cmd

WHITE='\[\e[m\]'
WHITE_BOLD='\[\e[1;m\]'
RED='\[\e[31m\]'
RED_BOLD='\[\e[1;31m\]'
GREEN='\[\e[32m\]'
GREEN_BOLD='\[\e[1;32m\]'
YELLOW='\[\e[33m\]'
YELLOW_BOLD='\[\e[1;33m\]'
BLUE='\[\e[34m\]'
BLUE_BOLD='\[\e[1;34m\]'
PURPLE='\[\e[35m\]'
PURPLE_BOLD='\[\e[1;35m\]'
CYAN='\[\e[36m\]'
CYAN_BOLD='\[\e[1;36m\]'
GLAY='\[\e[37m\]'
GLAY_BOLD='\[\e[1;37m\]'

PS_HEAD="${GREEN_BOLD}\u${WHITE_BOLD}:${CYAN_BOLD}\w"
PS_TAIL="${YELLOW_BOLD}\D{%y/%m/%d %H:%M:%S}\n ${WHITE}$ "
PS1="${PS_HEAD} ${PS_TAIL}"

if [ -f ${HOME}/dotfiles/git/git-completion.bash ]; then
    source ${HOME}/dotfiles/git/git-completion.bash
fi
if [ -f ${HOME}/dotfiles/git/git-prompt.sh ]; then
    source ${HOME}/dotfiles/git/git-prompt.sh

    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUPSTREAM=auto

    PS1=${PS_HEAD}${PURPLE}'$(__git_ps1 " (%s)") '${PS_TAIL}
fi

### ALIASES
if [ -f ${HOME}/.aliases ]; then
    source ${HOME}/.aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
    PATH="${HOME}/bin:${PATH}"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.local/bin" ] ; then
    PATH="${HOME}/.local/bin:${PATH}"
fi
