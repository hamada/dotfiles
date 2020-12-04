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

# Start tmux session at zsh login
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

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
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # loads nvm

# for zsh-autosuggestions
# ref: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#4169e1"

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
