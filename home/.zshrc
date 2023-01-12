# Create directory for local ZSH data stuff
ZSH_DATA_HOME="${HOME}/.local/share/zsh"
ZSH_CACHE_HOME="${HOME}/.cache/zsh"
mkdir -p "${ZSH_DATA_HOME}" "${ZSH_CACHE_HOME}"

# Set completion options
autoload -Uz compinit
compinit -d "${ZSH_CACHE_HOME}/zcompdump"

# Set ZSH history options
setopt HIST_IGNORE_SPACE
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
HISTFILE="${ZSH_CACHE_HOME}/history"
LESSHISTFILE="$HOME/.local/share/less/history"

# Load ZSH version control system
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

# Enable prompt subsitution
setopt PROMPT_SUBST

# BEGIN aliases

alias echop='printf "%s\n"' # echo stuff using printf

# END   aliases

# Left prompt codes for beginning
p_l_b() {
    local COLOR_1=$1; shift
    local COLOR_2=$1; shift
    local TEXT=$1; shift

    echop "%F{$COLOR_2}▒▓%f%F{$COLOR_1}%K{$COLOR_2}${TEXT}%k%f%F{$COLOR_2}%K{$COLOR_1}%k%f"
}

# Left prompt codes for middle
p_l_m() {
    local COLOR_1=$1; shift
    local COLOR_2=$1; shift
    local TEXT=$1; shift

    echop "%F{$COLOR_1}%K{$COLOR_2} $TEXT%k%f%F{$COLOR_2}%K{$COLOR_1}%k%f"
}

# Left prompt codes for end
p_l_e() {
    local COLOR_1=$1; shift
    local COLOR_2=$1; shift
    local TEXT=$1; shift

    echop "%F{$COLOR_1}%K{$COLOR_2} $TEXT%k%f%F{$COLOR_2}%f"
}

generate_left_prompt() {
    local final_prompt=""
    local COLOR_1=$1; shift
    local COLOR_2=$1; shift
    local items=("$@")

    if [ "${#items[@]}" -eq 1 ]; then
	final_prompt+="$(p_l_e $COLOR_1 $COLOR_2 ${items[1]})"

    elif [ "${#items[@]}" -eq 2 ]; then
	final_prompt+="$(p_l_b $COLOR_1 $COLOR_2 ${items[1]})"
	final_prompt+="$(p_l_e $COLOR_2 $COLOR_1 ${items[2]})"

    else
	local FIRST=${items[1]}; items=("${items[@]:1}") # Get and shift first prompt item
        local LAST=${items[-1]}; items=("${items[@]:0:${#items[@]}-1}") # Get and pop last prompt item
        local COLOR_A=$COLOR_1
        local COLOR_B=$COLOR_2

	local swap_colors() {
	    read -r COLOR_A COLOR_B <<< "$COLOR_B $COLOR_A" # Dynamically swap variables containing color palette
	}

        final_prompt+="$(p_l_b $COLOR_A $COLOR_B $FIRST)"
	swap_colors
        for item in "${items[@]}"; do
            final_prompt+="$(p_l_m $COLOR_A $COLOR_B $item)"
	    swap_colors
        done
        final_prompt+="$(p_l_e $COLOR_A $COLOR_B $LAST)"

    fi

    final_prompt+=" "

    echop "${final_prompt}"

}

change_right_prompt() {
    # If in a git repo, set the right prompt to the current branch, otherwise set it to nothing
    git rev-parse --is-inside-work-tree &> /dev/null && RPROMPT_GIT="$(p_l_m $c1 $c2 ${vcs_info_msg_0_})" || RPROMPT_GIT=""
    RPROMPT="%~${RPROMPT_GIT}"
}

typeset -a precmd_functions
precmd_functions+=(change_right_prompt) # Change the right prompt before the prompt is displayed

local c1='#5D576B' # RGB color 1
local c2='#99E1D9' # RGB color 2
PROMPT="$(generate_left_prompt $c1 $c2 %n %m)"

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Source all zsh plugins in user's plugins folder
for f in "${ZSH_DATA_HOME}/plugins"/*; do
    repo_name="$(basename $f)"
    source "$f/${repo_name}.zsh"
done

