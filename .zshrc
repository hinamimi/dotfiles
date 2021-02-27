autoload -U compinit
compinit -i

## prompt display
# --example
# usr-name_Green:curent-directory_Cian (git-branch)_Purple yy/mm/dd HH:MM:SS_Yellow
# $ cmd

# %B...%b <= Bold font
# %F{color}...%f <= Foreground(Character) color
# %K{color}...%k <= Backgrount color
PS_HEAD='%B%F{green}%n%f%F{white}:%f%F{cyan}%~%f%b'
PS_TAIL='%B%F{yellow}%D{%y/%m/%d %H:%M:%S} %f%b'
PROMPT="${PS_HEAD} ${PS_TAIL}
 $ "
RPROMPT='return:[%?]'

## Default install
# if not in `tree` then install `tree`
for CMD in tree git; do
    type ${CMD} > /dev/null 2>&1 || sudo apt-get install -y ${CMD}
done

## git setup
# completion
if [ -f ${HOME}/dotfiles/git/_git ]; then
    fpath=(~/.zsh $fpath)
    zstyle ':completion:*:*:git:*' script ~/dotfiles/git-completion.bash
    autoload -Uz compinit && compinit
fi
# git-prompt
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

## set keybind
# CTRL + <RIGHT>
bindkey ";5C" forward-word
# CTRL + <LEFT>
bindkey ";5D" backward-word

## set Alert mode
setopt no_beep

## load aliases
if [ -f ${HOME}/.aliases ]; then
    source ${HOME}/.aliases
fi

## add PATH
if [ -d "${HOME}/bin" ] ; then
    PATH="${HOME}/bin:${PATH}"
fi

if [ -d "${HOME}/.local/bin" ] ; then
    PATH="${HOME}/.local/bin:${PATH}"
fi
