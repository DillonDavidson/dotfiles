# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz zmv

setopt glob_dots
setopt no_auto_menu
setopt autocd

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt hist_ignore_all_dups
setopt share_history
setopt inc_append_history
export GPG_TTY=$(tty)

# Basic auto/tab complete
autoload -U compinit promptinit
compinit
promptinit

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/fzf-tab/fzf-tab.zsh

autoload -U select-word-style
select-word-style bash

# vi mode
# https://dougblack.io/words/zsh-vi-mode.html
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select () {
	case $KEYMAP in
		vicmd) echo -ne '\e[1 q';;      # block
		viins|main) echo -ne '\e[5 q';; # beam
	esac
}
zle -N zle-keymap-select
zle-line-init() {
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
	echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=('background_jobs' 'root_indicator' 'context' 'dir_writable' 'dir' 'vcs')
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=('vi_mode' 'command_execution_time' 'status' 'todo' 'time' 'ssh')

# source <(fzf --zsh)

# Aliases for the standard stuff
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias cd="z"
alias ls="lsd -hN --color=auto --group-directories-first"
alias ll="ls -Alh"
alias grep="grep -n"
alias gs="git status"
alias gp="git push origin HEAD"
alias gc="git clone"
alias gcr="git clone --recursive"
alias gbr='git branch | grep -v "master" | xargs git branch -D'
alias gd="git diff -w"
alias cat="bat"
alias find="fd"
alias tree='tree -a -I .git'

# My Aliases
alias ytaudio="yt-dlp --extract-audio --format bestaudio/best"
alias yt="cd -- /home/dillon/Downloads/YouTube"
alias down="cd -- /home/dillon/Downloads"
alias dotfiles="cd -- /home/dillon/dotfiles"
alias drop="cd -- /home/dillon/Dropbox"
alias subs="cd -- /home/dillon/Documents/Subtitles"
alias update-mirrors="sudo reflector --protocol https --download-timeout 60 --verbose --age 6 --latest 100 --fastest 10 --sort rate --country \"$(curl -Ls \"ifconfig.co/country\")\" --save /etc/pacman.d/mirrorlist"
alias anime="cd -- /home/dillon/Videos/"
alias desk="cd -- ~/Desktop"
alias vid="cd -- ~/Videos"
alias c="clear"
alias code="cd -- ~/Code"
alias ff="clear && fastfetch"
alias alass="alass-cli"
alias 144hz="wlr-randr --output DP-1 --mode 1920x1080@143.852"
alias all-cm="cm ftogg && cm ftswebp"
alias time="/usr/bin/time"
alias t="/usr/bin/time -f \"Max memory: %M KB\""
alias nin="ninja -C build"
alias b="cd -"
alias make="bear -- make -j"

# My Keybindings
bindkey -s '^o' '^ulf\n' # Ctrl + O to launch LF
bindkey -s '^f' '^ucd -- "$(dirname -- "$(fzf)")"\n' # Ctrl + F to search directory with fzf
bindkey -s '^k' '^uclear\n' # Ctrl + K to clear the terminal
bindkey -s '^n' '^unvim\n' # Ctrl + N for neovim

# Vi bindings
bindkey -M viins '^[[F' autosuggest-accept
bindkey -M viins '^a' beginning-of-line   # Ctrl+A
bindkey -M viins '^e' end-of-line         # Ctrl+E
# bindkey -M viins '^W' backward-kill-word

# My exports
export CMAKE_GENERATOR=Ninja
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

export EDITOR="nvim"
export TERMINAL="foot"
export TERM="foot"
export LANG=ja_JP.UTF-8
export LC_MESSAGES=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH=/usr/lib/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib/openmpi/lib:$LD_LIBRARY_PATH
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH

# Emacs LOL
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"
export EMACSDIR="$HOME/.config/emacs"
export DOOMDIR="$HOME/.config/doom"

export CUDAToolkit_ROOT=/opt/cuda
export CUDACXX=/opt/cuda/bin/nvcc
export PATH="$HOME/go/bin:$PATH"
export PYTHONPATH=/usr/lib/python3.13/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export CMAKE_CUDA_COMPILER=/opt/cuda/bin/nvcc
export PIPEWIRE_LATENCY=128/48000
export MPD_HOST=/run/user/1000/mpd/socket
# export LDFLAGS="-fuse-ld=mold"

# Nix stuff
# >>> Nix shell integration >>>
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
# <<< Nix shell integration <<<

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

eval "$(zoxide init zsh)"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
