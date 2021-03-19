zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt no_complete_aliases
export LANG=ja_JP.UTF-8

setopt auto_cd
setopt auto_pushd #use cd -<TAB>
setopt pushd_ignore_dups

export LSCOLORS="gxfxcxdxbxegedabagacad"


setopt hist_ignore_space
setopt hist_ignore_dups

setopt nobeep
setopt correct

eval "$(/opt/homebrew/bin/brew shellenv)"

# Start tmux session at zsh login
# You can select a session if any tmux session already exists.
#   ref: https://qiita.com/ssh0/items/a9956a74bff8254a606a
export PERCOL="peco"
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | $PERCOL | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :  # Start terminal normally
  fi
fi

bindkey -v #keybind vi like
export EDITOR=vi

#setting the path
PATH="$PATH":~/bin
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

#set prompt
PROMPT=%F{green}'$ '%f

#alias
alias rm='rm -i'
alias ls=' ls -G' #ls with coloring
alias pr='powder restart; powder applog'

# git alias
alias g="git"
alias gl="git log --pretty='medium-reverse' --graph --name-status"
alias ga="git add ."
alias gc="git commit"
alias gch="git checkout"
alias gnb="git checkout -b"
alias gb="git branch"
alias gdb="git branch -d"
alias gm="git merge"
alias gpull="git pull origin master; growlnotify -m Done!;"
alias gph="git push heroku master; growlnotify -m Done!;"
alias gps="git push staging master; growlnotify -m Done!;"
alias gst="git status"
alias gd="git diff"
alias gdc="git diff --cached"

# tmux alias
alias tn="tmux new -t"

# docker, kubernetes alias
alias k="kubectl"

# gpo() {
	# local branch=$*;
  # if [ -n "$branch" ]; then
	# git push origin $branch;
	# growlnotify -m "git push origin $branch";
  # fi
# }

# rake alias
alias rdm="echo rake db:migrate; rake db:migrate; growlnotify -m Done!; echo next rdtp;"
alias rdtp="echo rake db:test:prepare; rake db:test:prepare; growlnotify -m Done!; echo next rdp;"
alias rdp="echo rake db:populate; rake db:populate; growlnotify -m Done!; echo next rds;"
alias rds="echo rake db:seed; rake db:seed; growlnotify -m Done!; echo next gnb;"

# add Path to my pivotaltracker commands
PATH="$PATH":~/commands

# etc alias
alias music="mkdir /Volumes/contents; mount_afp afp://10.0.1.5/contents /Volumes/contents; open /Applications/iTunes.app"
alias eject="killall iTunes; hdiutil eject /Volumes/contents"

#display current dir in tab title
precmd () {
  echo -ne "\e]2;${PWD}\a"
  echo -ne "\e]1;${PWD:t}\a"
}

#for autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

#for growl
growl() { echo -e $'\e]9;'${1}'\007' ; return  ; }

export PATH=/usr/local/bin:$PATH
#PATH=/opt/local/bin:/opt/local/sbin:$PATH
#MANPATH=/opt/local/man:$MANPATH

# for nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh" # loads nvm

# for gatsby
# ref: https://qiita.com/yudwig/items/c533f676b7b8015da723
export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"

# for zsh-autosuggestions
# ref: https://formulae.brew.sh/formula/zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#0099ff"

#-------------------------------------------------------
# peco commands
#-------------------------------------------------------
# execute git command with selected commit
#   @example
#     $ gpeco show # git show selected commit
#     $ gpeco checkout # checkout to selected commit
function gpeco() {
  local commit_id
  commit_id=$(git log --oneline | peco | cut -d ' ' -f 1)
  git $1 $commit_id
}

# execute some command to selected gem (installed with gem-src)
#   @example
#     $ gempeco ls # ls (selected gem)
#     $ gempeco cd # cd (selected gem)
function gempeco() {
  local gems_dir gem
  gems_dir=~$(cat $HOME/.gemrc | cut -d '~' -f 2)
  gem=$(ls $gems_dir| peco)

  $1 $gems_dir/$gem
}

#-------------------------------------------------------
# .zshrc for this machine
#-------------------------------------------------------
if [ -f $HOME/.zshrc_machine_specific ]; then
    . $HOME/.zshrc_machine_specific
fi
