# Set a fancy prompt with exit code

# Function to get the current git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^* /s///'
}

# Function to generate the prompt
build_prompt() {
  local exit_code=$?
  local branch=$(parse_git_branch)

  # Start of the prompt
#  PS1="\[\e[38;5;15m\][\u@\h \W" # Username@Hostname Current Directory
PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\u@\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \W"

  # Git branch (if in a git repository)
  if [[ ! -z "$branch" ]]; then
    PS1+="\[\e[38;5;10m\]($branch)\[\e[38;5;15m\]"
  fi

  # Exit code (if not 0)
  if [[ $exit_code -ne 0 ]]; then
    PS1+="\[\e[38;5;9m\][$exit_code]\[\e[38;5;15m\]"
  fi

  PS1+="\[\e[0m\]\$ " # End of prompt, reset colors, and add a dollar sign
}

# Set the prompt to be rebuilt before each command
PROMPT_COMMAND=build_prompt

# Some common aliases (optional)
alias la='ls -la'
alias ll='ls -l'
alias grep='grep --color=auto'

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi


# automatically search the official repositories, when entering an unrecognized command
source /usr/share/doc/pkgfile/command-not-found.bash
#  Auto "cd" when entering just a path
shopt -s autocd

