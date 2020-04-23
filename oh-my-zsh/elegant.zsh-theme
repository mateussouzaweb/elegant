# Elegant theme for oh-my-zsh
# Colors: black|red|blue|green|yellow|magenta|cyan|white

local black=$fg[black]
local red=$fg[red]
local blue=$fg[blue]
local green=$fg[green]
local yellow=$fg[yellow]
local magenta=$fg[magenta]
local cyan=$fg[cyan]
local white=$fg[white]

local black_bold=$fg_bold[black]
local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]
local white_bold=$fg_bold[white]

local highlight_bg=$bg[red]

# Git info
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$yellow_bold%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$green_bold%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%}"

# Git status
ZSH_THEME_GIT_PROMPT_ADDED="%{$green_bold%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$red_bold%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$magenta_bold%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$blue_bold%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$cyan_bold%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$yellow_bold%}?"

# Git sha
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[%{$yellow%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

# The indicator
function _get_indicator {
    if [[ $? -eq 0 ]]; then
        echo "%{$yellow_bold%}❱/%{$reset_color%}"
    else
        echo "%{$red_bold%}❱/%{$reset_color%}"
    fi
}

# Time info
function _get_timestamp {
    echo "%{$blue%}%*%{$reset_color%}"
}

# Machine name info
function _get_hostname {
    echo "%{$blue%}$HOST%{$reset_color%}"
}

# User name info
function _get_username {
    if [[ "$USER" == 'root' ]]; then
        echo "%{$cyan_bold%}%n%{$reset_color%}"
    else
        echo "%{$blue%}%n%{$reset_color%}"
    fi
}

function _get_context {
    echo "at $(_get_username)%{$blue_bold%}@%{$reset_color%}$(_get_hostname)"
}

# Directory info
function _get_current_dir {
    echo "%{$yellow_bold%}$(basename "${PWD/#$HOME/~}")%{$reset_color%}"
}

# Git prompt info
function _get_git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="($git_status%{$reset_color%})"
        fi
        echo $(git_prompt_info)$git_status
    fi
}

# Prompt head line on left
function print_prompt_left {
    echo "$(_get_indicator) $(_get_current_dir) $(_get_context)"
}

# Prompt head line on right
function print_prompt_right {
    echo "$(_get_git_prompt) $(_get_timestamp)"
}

# Prompt head line space between texts
function print_prompt_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=""
    while [[ $size -gt 0 ]]; do
        space="$space "
        let size=$size-1
    done
    echo $space
}

function print_prompt_head {
    local l=$(print_prompt_left)
    local r=$(print_prompt_right)
    print -rP "$l$(print_prompt_space $l $r)$r"
}

autoload -U add-zsh-hook
add-zsh-hook precmd print_prompt_head
setopt PROMPT_SUBST;

PROMPT='$(_get_indicator) '
RPROMPT='%(?..%F{red}%B%S  $?  %s%b%f)'