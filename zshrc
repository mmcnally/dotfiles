# Path to your oh-my-zsh installation.
export ZSH=/Users/Matt/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="robbyrussell"

plugins=(chucknorris brew)

################################################
## ALIASES
################################################

# for full list of aliases, run 'alias'

# general
alias zshconf="emacs ~/.zshrc && source ~/.zshrc"
alias drp="cd ~/Dropbox"
alias startserver="sudo python -m SimpleHTTPServer 80"
alias edlab='ssh -X -l mgmcnally elnux.cs.umass.edu'
alias l='clear && ls'
alias dotfiles='cd ~/Dropbox/dotfiles'

# emacs
alias econf='emacs ~/.emacs.d/init.el'
alias e='emacsclient -t -a ""'
alias killemacs='emacsclient --eval "(progn (save-some-buffers t t) (kill-emacs))"'

# classes
alias 585="cd ~/Dropbox/585"
alias 377="cd ~/Dropbox/377"
alias 383="cd ~/Dropbox/383"
alias gamedev="cd ~/Dropbox/397"
alias 150="cd ~/Dropbox/150"

# tmux
alias tm="tmux attach || tmux new"
alias tconf="emacs ~/.tmux.conf"
alias tka="killall tmux"
alias tls="tmux ls"
alias ta="tmux attach"
alias td="tmux detach"

# git
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gp="git push"
alias gc="git commit -m"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdeleteall="git stash save --keep-index --include-untracked && git stash drop"


dots() {
    # copy current versions into dotfiles directory
    echo "copying..."
    echo ""
    cp ~/.zshrc ~/Dropbox/dotfiles/zshrc
    cp ~/.tmux.conf ~/Dropbox/dotfiles/tmux.conf
    cp ~/.emacs.d/init.el ~/Dropbox/dotfiles/init.el

    cd ~/Dropbox/dotfiles
    git status
    cd -
}


export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/Matt/Documents/scala-2.11.2/bin:/usr/texbin:/Library/Tex/texbin"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='emacs'
