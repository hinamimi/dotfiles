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
function mark() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle $1
}
function delete-region() {
    zle kill-region
    CUTBUFFER=$killring[1]
    shift killring
}
zle -N delete-region

function backward-delete-char-or-region() {
    if [ $REGION_ACTIVE -eq 0 ]; then
        zle backward-delete-char
    else
        zle delete-region
    fi
}
zle -N backward-delete-char-or-region

function delete-char-or-list-or-region() {
    if [ $REGION_ACTIVE -eq 0 ]; then
        zle delete-char-or-list
    else
        zle delete-region
    fi
}
zle -N delete-char-or-list-or-region

mark-forward-char() mark forward-char
mark-backward-char() mark backward-char
mark-forward-word() mark forward-word
mark-backward-word() mark backward-word
zle -N mark-forward-char
zle -N mark-backward-char
zle -N mark-forward-word
zle -N mark-backward-word

# CTRL + RIGHT | LEFT
bindkey ";5C" forward-word
bindkey ";5D" backward-word
# SHIFT + RIGHT | LEFT
bindkey ";2C" mark-forward-char
bindkey ";2D" mark-backward-char
# CTRL + SHIFT + LEFT | RIGHT
bindkey ";6C" mark-forward-word
bindkey ";6D" mark-backward-word
# Delete | BackSpace
bindkey "\e[3~" delete-char-or-list-or-region
bindkey "^?" backward-delete-char-or-region

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
