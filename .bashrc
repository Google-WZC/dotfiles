# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running non-interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias la='ls -A'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# -------------------------- Here is my customized configures ----------------------------------------
# delete 'icer@icer-VMware-Virtual-Platform:' command-reminder
export PS1='\[\e[1;34m\]\w\[\e[m\] $ '

# set env-variable for non-interactive and non-login
# export BASH_ENV=''

# set ${workspaceFolder} vscode configure(.json), you don't have to set the following PATH. You only need to open file on vscode GUI
# export workspaceFolder="~/ysyx/c/life"

# set for vscode-ssh-link the man command option, but even I don't add this, man function will work
if [[ $(echo $SSH_CONNECTION) != "" ]];then
    export LANG=C.UTF-8
fi


# for vscode-ssh-link proxy settings, which can show with command "env | grep -i proxy"
# when using linux directly with GUI, running clash-verge backgroundly will add them automatically, and shutdown clash will delete them
if [[ $(echo $SSH_CONNECTION) != "" ]];then
	export no_proxy=localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,172.29.0.0/16,::1
	export https_proxy=http://127.0.0.1:7897/
	export NO_PROXY=localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,172.29.0.0/16,::1
	export HTTPS_PROXY=http://127.0.0.1:7897/
	export HTTP_PROXY=http://127.0.0.1:7897/
	export http_proxy=http://127.0.0.1:7897/
	export ALL_PROXY=socks://127.0.0.1:7897/
	export all_proxy=socks://127.0.0.1:7897/
fi

# set ssh-agent for ssh-key silently, which is used for github and gitlab
eval $(ssh-agent -s | grep -v '^echo') > /dev/null
ssh-add ~/.ssh/id_github &> /dev/null


# for long commands, use editor, with hotkey Ctrl+x Ctrl+e
if [[ $(echo $SSH_CONNECTION) = "" ]];then
	export EDITOR="gedit --wait" 
else 
	export EDITOR="code --wait" 
fi

# for npm global packages(-g option) install path, the set command below is from https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
# mkdir ~/.npm-global
# npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH

# for pipx install path(such as: black)
export PATH=~/.local/bin:$PATH

# fd-find command 
alias fd=fdfind

# ripgrep command
alias rg=ripgrep

# vscode software
alias vscode=code

# update apt list(not upgrade) and install software
install(){
    if [[ -z "$VIRTUAL_ENV" ]];then
        sudo apt update && sudo apt install -y "$@"
    else
        pip install "$@"
    fi
}

# use default python env
alias python=python3

# override default command exit to quit python virtualenv
alias exit=deactivate

# activate python virtualenv
py(){
    command source "$1"/bin/activate
}

# create python virtualenv
alias pyc="command python3 -m venv"

# upgrade pip packages
alias pipup="pip install --upgrade"

# overwrite default command "mv"(may override existing file with renamed file)
alias mv="mv -i"

# overwrite default command "mkdir"(can't create new directory in new directory with only one command)
# alias mkdir="mkdir -p" 
# because it's customized below

# overwrite default command "rm"(remove one file without ensure)
alias rm='rm -i'

# overwrite customized command gedit ~/.bashrc
alias bashrc=gdbashrc

# switch to root account
alias su="sudo su"

# commonly used command for vague match
alias dc=cd
alias sl=ls
alias dg=gd
alias vm=mv

# let the root account inherit common account's env, mainly for proxy setting, because root will run in his only env not the comman-env
alias sudo="sudo -E"

# my git push habit
alias gitr="git rm"
alias gitrestore="git restore"
gitc () { git commit -m "$1" && git push; }
alias gitp="git push"
# other common git command
alias gitpull="git pull --rebase" # git pull(default is merge) used when collaborate with others, and --rebase option used license 
alias gitstatus="git status"
alias gitcheckout="git checkout"
alias gitbranch="git branch"
alias gitclone="git clone"
# init a new git repo and push to remote repo
gitinit(){ # gitinit <remote-repo-url> <file1> <file2> ... 
    git init &&
    git remote add origin "$1" &&
    git branch -m main &&
    git fetch origin &&
    shift &&
    git add "$@" &&
    git commit -m "first commit" &&
    git rebase origin/main &&
    git push --set-upstream origin main
}
# add files
gita(){ # gita <file1> <file2> ... <commit-message>
    git add "${@:1:$#-1}" &&
    git commit -m "${!#}" &&
    git push
}
# git function help
githelp(){
    echo 'gitinit() Usage:'
    echo 'gitinit <remote-repo-url> <file1> <file2> ... <fileN>'
    echo 'gita()    Usage:'
    echo 'gita <file1> <file2> ... <fileN> <commit-message>'
}

# fzf tool for Ctrl+R history command show
command source /usr/share/doc/fzf/examples/key-bindings.bash

# my customized commands
# cd to YSYX dictionary, and show all files' details(e.g. ctime) in this path and sort them with ctime by oldest-to-newest order, besides show file-size with non-humman-read format(unit:bit)
init(){
    figlet -f slant ysyx
    echo -e "\n"
    command cd ~/ysyx
    ls -lA -tcr --color=always | sed '1d'
}

# cd to GUI Trash
    cd_to_Trash(){
    cd ~/.local/share/Trash/files
    ls -lA -tcr
}

# open ~/.bashrc with gedit and source if shutdowm
    gdbashrc(){
    gdwait ~/.bashrc
    command source ~/.bashrc
}

# open ~/.profile with gedit and source if shutdowm
# gdprofile(){
# gd ~/.profile
# command source ~/.profile
# }

# which means my note
gdman(){
    gd ~/..mynote
}

# customized terminal hotkey
gdinputrc(){
    if [[ $(echo $SSH_CONNECTION) = "" ]];then
        gedit ~/.inputrc 
    else 
        code ~/.inputrc --wait
    fi
    bind -f ~/.inputrc
}

# open current path with terminal command
# the command to insure which open is 'echo $XDG_CURRENT_DESKTOP'
if [[ $(echo $SSH_CONNECTION) = "" ]];then
	open(){
        nautilus . &
    }
fi

# use gedit in child-process
# vscode for window11 ssh-link
gd(){
    if [[ $(echo $SSH_CONNECTION) = "" ]];then
        gedit "$@" &
    else 
        code "$@" 
    fi
}
# wait for gedit or code to finish
gdwait(){
    if [[ $(echo $SSH_CONNECTION) = "" ]];then
        gedit "$@" 
    else 
        code "$@" --wait
    fi
}

# use vim
vi(){
    vim "$@" 
}

# command for software below
# download "*.deb"
software_install_deb(){
    sudo apt install ./$1
}

# periodly clean .deb software cache with this safe command
software_cache_periodly_clean(){
    sudo apt clean
}

# uninstall .deb downloaded software totally
software_uninstall_deb_software(){
    sudo apt purge $@       # remove all config files
    # sudo apt remove $@      # not remove config files, but only remove software
    sudo apt autoremove
}

# show .deb sofeware's detail information
software_show_deb_software_details(){
    echo '-------------------文件体积-------------------'
    echo '.deb文件体积'
    apt show $1 2>/dev/null | grep 'Installed-Size'
    echo '安装体积'
    apt show $1 2>/dev/null | grep 'Download-Size'
    echo '-------------------文件路径-------------------'
    echo '启动路径'
    which $1
    echo '启动路径是否有指向'
    ls -l $(which $1)
    echo '启动路径的所有路径（主要包含了mannul）'
    whereis $1
    echo '所有安装路径的目录'
    grep -Po "/usr/share/.*?/" codeL | sort -u
}

# customized tmux command
tmux(){
    # alias default command "tmux new -s $1"(create a new session named $1) with command "tmux -name $1" or "tmux -n $1"
    if [[ $1 = '-name' || $1 = '-n' ]];then
        command tmux new -s $2
    # alias default command "tmux rename-session -t $1 $2"(rename an existing session named $1 to $2) with command "tmux -rename $1" or "tmux -r $1"
    elif [[ $1 = '-rename' || $1 = '-r' ]];then
        command tmux rename-session -t $2 $3
    # alias default command "tmux attach -t $1"(attach to existing session named $1) with command "tmux a $1" or "tmux attach $1" 
    elif [[ ($1 = 'attach' || $1 = 'a') && $2 != '' ]];then
        command tmux attach -t $2
    # alias default command "tmux kill-session -t $1"(kill an existing session named $1) with command "tmux kill $1" or "tmux k $1" 
    elif [[ ($1 = 'kill' || $1 = 'k') && $2 != '' ]];then
        command tmux kill-session -t $2
    # if tmux command isn't my customized, return obvious command
    else
        command tmux $@
    fi
}

# ls with format the same with init
ll(){
    ls -lA -tcr --color=always "$@" | sed 1d
}

# overwrite default cd, cd to another directory and show
cd(){
    command cd $1
    ll
}

# # make directory and cd to this new directory
function mkdir(){
    if [ -z "$1" ]; then
        echo "Error: You must provide a directory name."
        return 1
    fi
    command mkdir -p "$1"
    command cd "$1"
    ll # if the directory exists, the command will cd to it and ll
}

# make c with GNU essential-build, and test with Valgrind
test_c(){
    # make $1
    # ./$1
    valgrind ./$1
}

# test proxy in usr and root
internat(){
    echo 'curl google.com'
    curl google.com
    echo ' '
    echo 'sudo curl google.com'
    sudo curl google.com
    echo ' '
    echo 'ssh -T git@github.com'
    ssh -vT git@github.com 2>&1 | awk '
        /Connecting to/ {
            gsub(/\./, "", $NF)
            print "Port Used:", $NF
        }
        /Hi/ {
            gsub(/!/, "", $2)
            print "Auth Status:", $2
        }
    '
}

# modify dotfiles env PATH and add them in $HOME/gits/dotfiles
confPATH(){
    command cd $HOME/gits/dotfiles
    gdwait ./env_path
    ./add_env
    ll
}

# gedit Makefile in current path
gdmakefile(){
    gd ./Makefile
}

# source ~/.bashrc without thinking hh
source(){
    if [[ -z $1 ]];then
        command source ~/.bashrc
    else
        command source $1
    fi
}

# This is ysyx PATH generated by ysyx-workbench/init.sh
export NPC_HOME=/home/icer/ysyx/ysyx-workbench/npc
