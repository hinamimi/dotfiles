## -----------------------------------------------------------------------------
### Initializing

# 保管機能を有効にして、実行する
autoload -Uz compinit && compinit -i

## -----------------------------------------------------------------------------
### Setting up HISTORY FILE

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history
setopt hist_no_store
setopt extended_history

zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    [[ ${#line} -ge 5
        && ${cmd} != cd
        && ${cmd} != ls
        && ${cmd} != ll
        && ${cmd} != la
        && ${cmd} != which
    ]]
}

## -----------------------------------------------------------------------------
### Setting up Z-shell options

# ビープを出さない
setopt no_beep
# コマンド名が無い場合はその名前でcdを試みる
setopt auto_cd
# ディレクトリが見つからない場合に先頭に~をつけて試行する
setopt cdable_vars

## -----------------------------------------------------------------------------
### Setting up PROMPT

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## -----------------------------------------------------------------------------
### Setting up PROMPT
# --example
# usr-name_Green:curent-directory_Cian (git-branch)_Purple yy/mm/dd HH:MM:SS_Yellow
# $ cmd

# %B...%b <= Bold font
# %F{color}...%f <= Foreground(Character) color
# %K{color}...%k <= Backgrount color

# PS_HEAD='%B%F{green}%n%f%F{white}:%f%F{cyan}%~%f%b'
# PS_TAIL='%B%F{yellow}%D{%y/%m/%d %H:%M:%S} %f%b'
# PROMPT="${PS_HEAD} ${PS_TAIL}
#  $ "
# RPROMPT='return:[%?]'

## -----------------------------------------------------------------------------
### Default install
# e.g. if not in `tree` then install `tree`
for CMD in curl tree git; do
    type ${CMD} > /dev/null 2>&1 || sudo apt-get install -y ${CMD}
done

## -----------------------------------------------------------------------------
### Setting up GIT

# # completion
# if [ -f ${HOME}/dotfiles/git/_git ] && [ -f ${HOME}/dotfiles/git/git-completion.bash ]; then
#     fpath=(~/.zsh $fpath)
#     zstyle ':completion:*:*:git:*' script ~/dotfiles/git/git-completion.bash
#     autoload -Uz compinit && compinit
# fi
# # git-prompt
# if [ -f ${HOME}/dotfiles/git/git-prompt.sh ]; then
#     source ${HOME}/dotfiles/git/git-prompt.sh

#     GIT_PS1_SHOWDIRTYSTATE=true
#     GIT_PS1_SHOWUNTRACKEDFILES=true
#     GIT_PS1_SHOWSTASHSTATE=true
#     GIT_PS1_SHOWUPSTREAM=auto

#     setopt prompt_subst
#     PROMPT=${PS_HEAD}'%F{magenta}$(__git_ps1 " (%s)")%f '${PS_TAIL}"
#  $ "
# fi

## -----------------------------------------------------------------------------
### Setting up KEYBIND

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

## -----------------------------------------------------------------------------
### EXPORT EDITOR
if type code > /dev/null 2>&1; then
    export EDITOR=code
elif type vi > /dev/null 2>&1; then
    export EDITOR=vi
fi

## -----------------------------------------------------------------------------
### ADD PATH

## load aliases
if [ -f "${HOME}/.aliases" ] ; then
    source ${HOME}/.aliases
fi

if [ -d "${HOME}/bin" ] ; then
    PATH="${HOME}/bin:${PATH}"
fi

if [ -d "${HOME}/.local/bin" ] ; then
    PATH="${HOME}/.local/bin:${PATH}"
fi

## -----------------------------------------------------------------------------
### Zinit installzation -> https://github.com/zdharma-continuum/zinit
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"
# zinit self-update

### Added by Zinit's installer
if [[ ! -f ${HOME}/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "${HOME}/.zinit" && command chmod g-rwX "${HOME}/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "${HOME}/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${HOME}/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

## -----------------------------------------------------------------------------
### zinitによる拡張機能をインストールする
### zinit ice wait'0': 非同期でプラグインを読み込むことができる -> 起動が早くなる
### zinit ice wait'0!': ロードが終わったというログを表示しない

# zsh-users         : Zsh community projects -> repository:  https://github.com/zsh-users
# zdharma-continuum : Contributer of zinit -> https://github.com/zdharma-continuum 
# romkatv           : https://github.com/romkatv/powerlevel10k 

## 補完
# こいつがないと困るので非同期ロードすら拒否しておく
zinit ice; zinit light zsh-users/zsh-autosuggestions
zinit ice wait'!0'; zinit light zsh-users/zsh-completions
# シンタックスハイライト
zinit ice wait'!0'; zinit light zdharma-continuum/fast-syntax-highlighting
# # Ctrl+r でコマンド履歴を検索
zinit ice wait'!0'; zinit light zdharma-continuum/history-search-multi-word
# ZshのツヨツヨテーマであるPowerlevel10kを使う
zinit ice depth=1; zinit light romkatv/powerlevel10k

## -----------------------------------------------------------------------------
### ローカル専用のコンフィグはこっちに書く
[ -f ${HOME}/.zshrc_local ] && source ${HOME}/.zshrc_local
