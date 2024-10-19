# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
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

parse_git_branch() {
  local branch=$(git branch 2> /dev/null | sed -n -e '/^\* /s///p')
  if [ -n "$branch" ]; then
    echo "($branch)"
  fi
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[00m\]\[\033[01;37m\]@\[\033[00m\]\[\033[0;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '
    
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
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
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

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

######################################################################################
# Personal aliases
######################################################################################
alias cdc='cd /mnt/c/Users/Zarif/Desktop'
alias cdd='cd /mnt/d'
alias gv='gvim'
alias home='cd ~'
alias od='cd /mnt/c/Users/Zarif/OneDrive'
alias update='sudo apt-get update -y && sudo apt-get upgrade -y && sudo aptitude full-upgrade -y && sudo apt-get autoremove -y'
alias find='find . -name'
alias cl='clear'
alias catv='cat -v'
alias nv='nvim'
alias yazi='/home/ubuntu24/yazi/target/release/yazi'
alias t='touch'
alias c='cat'
alias s='source'
alias v='vim'
alias g='gvim'
alias m='minikube'
alias k='kubectl'

[[ -s /usr/share/autojump/autojump.sh ]] && source /usr/share/autojump/autojump.sh

# Custom cd command
cd() {
    command cd "$@" && ls -alh
}

# Custum find command
findc() {
    find . -name "*$1*"
}

# Custom grep command
grepc() {
    grep "$1" * -srin --color
}
grepl() {
    grep "$1" * -sril --color
}

# Check if the line exists in /etc/sudoers and add it if not found
if ! sudo grep -Fxq "ubuntu24 ALL=(ALL) NOPASSWD: /bin/rm -rf /home/ubuntu24/.snapshot" /etc/sudoers; then
    #echo "Adding the setting to /etc/sudoers."
    echo "ubuntu24 ALL=(ALL) NOPASSWD: /bin/grep, /bin/rm -rf /home/ubuntu24/.snapshot" | sudo EDITOR='tee -a' visudo
fi


# Define the custom rm function
safe_rm() {
    # Snapshot directory
    local snapshot_dir="$HOME/.snapshot"
    mkdir -p "$snapshot_dir"

    # Extract options and files/directories
    local options
    local files
    while [[ $# -gt 0 ]]; do
        if [[ "$1" =~ ^- ]]; then
            options+="$1 "
        else
            files+="$1 "
        fi
        shift
    done

    # Process each file or directory argument
    for target in $files; do
        # Check if the target exists
        if [ ! -e "$target" ]; then
            echo "Error: $target does not exist."
            continue
        fi

        # Create a timestamped snapshot path
        local timestamp=$(date +"%Y%m%d%H%M%S")
        local snapshot_path="$snapshot_dir/$(basename "$target")_$timestamp"

        # Move the target to the snapshot directory
        #echo "Moving '$target' to '$snapshot_path'"
        mv "$target" "$snapshot_path"

        # Schedule the removal of the snapshot after 4 days
        (
            sleep 4d
            rm -rf "$snapshot_path"
        ) &

        #echo "'$target' has been moved to '$snapshot_path' and will be deleted after 4 days."
    done
}

# Override rm command with safe_rm
rm() {
    if [[ "$@" =~ ^-- ]]; then
        # Pass through if -- options are used
        command rm "$@"
    else
        # Call the safe_rm function with options
        safe_rm "$@"
    fi
}


######################################################################################
# Kali - Special aliases
######################################################################################
alias kex-win="kex --win -s"
alias kex="kex --esm --ip -s"
alias kex-sl="kex --sl -s"
