# Path to your oh-my-zsh installation.
export ZSH=/home/$USER/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="husjon"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux zsh-syntax-highlighting)

# User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/home/$USER/bin:/home/$USER/.local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_GB.UTF-8


alias gs='git status'
alias gg='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias upgrade='for c in update upgrade autoremove autoclean; do sudo apt $c; done'
alias :q=exit
alias ra=ranger
alias settings="export XDG_CURRENT_DESKTOP=\"Unity\"; gnome-control-center"
alias reset="reset; cat ~/.cache/wal/sequences"
alias music="mpsyt set show_video false, set search_music true, q; mpsyt"
alias yt="mpsyt set show_video true, set search_music false, q; mpsyt"
alias vw="vi ~/vimwiki/index.wiki"


export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
export GPG_TTY=$(tty)
export LPASS_AGENT_TIMEOUT=300

source /usr/local/bin/virtualenvwrapper_lazy.sh

[ -f ~/.cache/wal/sequences ] && cat ~/.cache/wal/sequences
