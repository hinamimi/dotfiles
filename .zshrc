## prompt表示
# --example
# usr-name_Green:curent-directory_Cian (git-branch)_Purple yy/mm/dd HH:MM:SS_Yellow
# $ cmd

# %B...%b <= ボールド体
# %F{color}...%f <= 文字色
# %K{color}...%k <= 背景色
PS_HEAD='%B%F{green}%n%f%F{white}:%f%F{cyan}%~%f%b'
PS_TAIL='%B%F{yellow}%D{%y/%m/%d %H:%M:%S} %f%b'
PROMPT="${PS_HEAD} ${PS_TAIL}
 $ "
RPROMPT='return:[%?]'

# git setup
if [ -f ${HOME}/dotfiles/git/_git ]; then
    fpath=(~/.zsh $fpath)
    zstyle ':completion:*:*:git:*' script ~/dotfiles/git-completion.bash
    autoload -Uz compinit && compinit
fi
if [ -f ${HOME}/dotfiles/git/git-prompt.sh ]; then
    source ${HOME}/dotfiles/git/git-prompt.sh

    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUPSTREAM=auto

    setopt prompt_subst
    PROMPT=${PS_HEAD}'%F{magenta}$(__git_ps1 " (%s)")%f '${PS_TAIL}"
 $ "
fi

### ALIASES
if [ -f ${HOME}/.aliases ]; then
    source ${HOME}/.aliases
fi

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
    PATH="${HOME}/bin:${PATH}"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.local/bin" ] ; then
    PATH="${HOME}/.local/bin:${PATH}"
fi