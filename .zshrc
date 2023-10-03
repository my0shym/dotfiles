# prompt(git branch)
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{green}"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}"
zstyle ':vcs_info:*' formats "%F{yellow} %c%u<%b>%f"
zstyle ':vcs_info:*' actionformats '%B%F{yellow} [%b|%a]%f%b'
PROMPT=$'%F{196}%f%U%c$vcs_info_msg_0_%u'$'%B%F{196}%#%f%b '
precmd(){ vcs_info }

alias d='docker'
alias ll='ls -l'
alias la='ls -al'
alias llssh='cat ~/.ssh/config| grep "Host "'
alias dc='docker compose'
alias pn='pnpm'
alias av='aws-vault'
alias ave='aws-vault exec'
alias da='direnv allow'
alias tf='terraform'
alias tfw='terraform workspace'

# エディタで開く
alias vs='open $1 -a "/Applications/Visual Studio Code.app"'

# historyを100件表示
HISTSIZE=1000
alias h='history -100'

# シェルをハイライト表示する
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"

# anyenv
eval "$(anyenv init -)"

# brew
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# goのbinのパス
export PATH=$PATH:~/go/bin
export PATH="$PATH:$(go env GOPATH)/bin"

# peco
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

## 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# direnv
eval "$(direnv hook zsh)"
export PATH="/opt/homebrew/bin:$PATH"

# pecoのキーバインドと設定を有効にする
[ -f ~/.peco.zsh ] && source ~/.peco.zsh
function custom_command_search() {
  BUFFER=$(\cat ~/.custom_commands | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N custom_command_search
bindkey '^t' custom_command_search
# 直前の実行コマンドを~/.custom_commandsに追記する関数
function append_last_command() {
  echo "$(fc -ln -1)" >> ~/.custom_commands
  echo "Added last command to ~/.custom_commands"
}

# append_last_command関数を呼び出すエイリアス
alias addcmd="append_last_command"

# git branchをpecoで
# Pecoでgitブランチを検索してチェックアウトする関数
function peco-select-git-branch() {
    local selected_branch
    selected_branch=$(git branch 2> /dev/null | sed 's/.* //; s#remotes/[^/]*/##' | sort -u | peco --query "$LBUFFER")
    if [ -n "$selected_branch" ]; then
        BUFFER="git checkout $selected_branch"
        zle accept-line
    fi
    zle reset-prompt
}

# キーバインドの設定
zle -N peco-select-git-branch
bindkey "^b" peco-select-git-branch

# docker psしてexecでshでコンテナに入る
alias dpe='docker exec -it $(docker ps |peco|awk "{print \$1}") /bin/sh'
