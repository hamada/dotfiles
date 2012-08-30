#alias
alias dt='cd ~/desktop'
alias rm='rm -i'
alias ..='cd ..'
alias finder='open .'
alias path='echo -e ${PATH//:/\\n}'
alias ht='cd /Applications/MAMP/htdocs'
alias jokers='cd /Applications/MAMP/htdocs/jokers-dbc.org'
#coloring ls output
export CLICOLOR='true'
export LSCOLORS="gxfxcxdxbxegedabagacad"
#setting shell prompt
export PS1='\[\033[32m\][\h: \w]\n\$\[\033[37m\] '
#setting command history
export HISTIGNORE="ls:cd:ls *:"
export HISTCONTROL=erasedups 
#setting the path
PATH="$PATH":~/bin
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"
#setting bash with vi mode
set -o vi
#adding shell var
dt=~/Desktop/
dropbox=~/Desktop/Dropbox/
mini=/Volumes/macmini_hdd/
