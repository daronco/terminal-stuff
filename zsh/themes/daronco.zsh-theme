# daronco
# strongly based on crunch (and others).

# TODO: user@machine when logged via ssh

# colors
BRACKET_COLOR="%{$fg[white]%}"
TIME_COLOR="%{$fg[white]%}"
DIRCOLOR="%{$fg[cyan]%}"
USERCOLOR="%{$fg[cyan]%}"
HOSTCOLOR="%{$fg[cyan]%}"
GIT_BRANCH_COLOR="%{$fg[green]%}"
GIT_CLEAN_COLOR="%{$fg_bold[green]%}"
GIT_DIRTY_COLOR="%{$fg_bold[red]%}"
GIT_UNTRACKED_COLOR="%{$fg_bold[cyan]%}"
RBENV_COLOR="%{$fg[yellow]%}"
ARROW_COLOR="%{$fg_bold[white]%}"

# git (used by oh-my-zsh git_prompt_info helper)
ZSH_THEME_GIT_PROMPT_PREFIX="$BRACKET_COLOR($GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}$BRACKET_COLOR)%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="$GIT_DIRTY_COLOR ±"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$GIT_UNTRACKED_COLOR ?"
#ZSH_THEME_GIT_PROMPT_CLEAN="$GIT_CLEAN_COLOR ✓"
ZSH_THEME_GIT_PROMPT_CLEAN="$GIT_CLEAN_COLOR ●"

# hour
# TIME="$BRACKET_COLOR$TIMECOLOR%T$BRACKET_COLOR%{$reset_color%}"
TIME="%(?.%{$fg[green]%}.%{$fg_bold[red]%})%*%{$reset_color%}"

# rvm/rbenv
if [ -e ~/.rvm/bin/rvm-prompt ]; then
  RVM="$BRACKET_COLOR"["$RBENV_COLOR\${\$(~/.rvm/bin/rvm-prompt i v g)#ruby-}$BRACKET_COLOR"]"%{$reset_color%}"
else
  if which rbenv &> /dev/null; then
    # RVM="$BRACKET_COLOR"["$RBENV_COLOR\${\$(rbenv version | sed -e 's/ (set.*$//' -e 's/^ruby-//')}$BRACKET_COLOR"]"%{$reset_color%}"
    RVM='$RBENV_COLOR$(current_ruby)%{$reset_color%}'
  fi
fi

# dir with git info
DIR="$DIRCOLOR%~\$(git_prompt_info)"
# dir without git info (faster when the dir is mounted from a vm)
# DIR="$DIRCOLOR%~"

# user name
if [ $UID -eq 0 ]; then NCOLOR="%{$fg_bold[magenta]%}"; else NCOLOR=$USERCOLOR; fi
USER='$NCOLOR%n%{$reset_color%}'
MYHOST="$HOSTCOLOR%m%{$reset_color%}"

# arrow at the end
# LIMITER="$TIMECOLOR➜%{$reset_color%}"
if [ $UID -eq 0 ]; then
  LIMITER="%{$fg_bold[magenta]%}#%{$reset_color%}"
else
  LIMITER="%{$fg_bold[white]%}$%{$reset_color%}"
fi

# put it all together
# PROMPT="$USER@$TIME $DIR $LIMITER %{$reset_color%}"

PROMPT="$TIME $USER@$MYHOST $DIR $LIMITER %{$reset_color%}"

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})"
return_code_disabled=
return_code=$return_code_enabled
RPS1='${return_code}'
function accept-line-or-clear-warning () {
        if [[ -z $BUFFER ]]; then
                time=$time_disabled
                return_code=$return_code_disabled
        else
                time=$time_enabled
                return_code=$return_code_enabled
        fi
        zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
