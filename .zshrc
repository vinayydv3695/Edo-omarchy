# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load completions
autoload -Uz compinit && compinit

# Add in zsh plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions


# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=500000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Core Utils Aliases
alias l='eza -lh  --icons=auto'
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias mkdir='mkdir -p'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias ssh='kitten ssh'
alias watch='watch -n 1 acpi -b'
alias tree='tree -a -I .git'
alias cat='bat'
alias c='clear' # clear terminal
alias e='exit'
alias mkdir='mkdir -p'
alias vim='nvim'
alias v='nvim'
alias t='tmux'
alias grep='rg --color=auto'
alias ssn='sudo shutdown now'
alias srn='sudo reboot now'
alias vol120='for SINK in $(pactl list short sinks | awk '{print $2}'); do
  pactl set-sink-volume "$SINK" 120%
done'
alias vol150='for SINK in $(pactl list short sinks | awk '{print $2}'); do
  pactl set-sink-volume "$SINK" 150%
done'
alias vol160='for SINK in $(pactl list short sinks | awk '{print $2}'); do
  pactl set-sink-volume "$SINK" 160%
done'
alias vol130='for SINK in $(pactl list short sinks | awk '{print $2}'); do
  pactl set-sink-volume "$SINK" 130%
done'
alias vol200='for SINK in $(pactl list short sinks | awk '{print $2}'); do
  pactl set-sink-volume "$SINK" 200%
done'

# Git Aliases
alias gac='git add . && git commit -m'
alias gs='git status'
alias gpush='git push origin'
alias lg='lazygit'
alias upscale='VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json upscayl-bin -h
'
# Nixos Aliases
alias rebuild='sudo nixos-rebuild switch --flake ~/rudra/.#default'
alias recats='sudo nix flake lock --update-input nixCats && sudo nixos-rebuild switch --flake ~/rudra/.#default'

# Downloads Aliases
alias yd='yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K'
alias ydm='yt-dlp -f "bestvideo[height<=720][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=720][vcodec^=avc1]/best[height<=720]" --merge-output-format mp4 --embed-chapters --recode-video mp4 --external-downloader aria2c'
alias td='yt-dlp --external-downloader aria2c -o "%(title)s."'
alias download='aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none'

# VPN Aliases
alias vu='sudo tailscale up --exit-node=raspberrypi --accept-routes'
alias vd='sudo tailscale down'
warp ()
{
    sudo systemctl "$1" warp-svc
}

# Other Aliases
alias apps-space='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'
alias files-space='echo "🔹 Analyzing root filesystem (/)..."; sudo ncdu -x / --exclude /.snapshots --exclude /home/.snapshots; echo -e "\n🔹 Analyzing home directory (/home)..."; sudo ncdu -x /home --exclude /home/.snapshots'
alias ld='lazydocker'
alias docker-clean='docker container prune -f && docker image prune -f && docker network prune -f && docker volume prune -f'
alias crdown='mpv --yt-dlp-raw-options=cookies-from-browser=brave'
alias cr='cargo run'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias y='yazi'
lsfind ()
{
    ll "$1" | grep "$2"
}

# X11 Clipboard Aliases `xsel`
# alias pbcopy='xsel --input --clipboard'
# alias pbpaste='xsel --output --clipboard'

# Wayland Clipboard Aliases `wl-clipboard`
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'
alias hashtag='echo "#" | wl-copy'


# Function to mount rd
rd() {
  case "$1" in
    start) sudo systemctl start rclone-debrid-mount.service ;;
    stop)  sudo systemctl stop rclone-debrid-mount.service ;;
    restart) sudo systemctl restart rclone-debrid-mount.service ;;
    status) sudo systemctl status rclone-debrid-mount.service ;;
    *) echo "Usage: rd {start|stop|restart|status}" ;;
  esac
}

# Update and Upgrade Arch
function up() {
  echo ":: Checking Arch Linux PGP Keyring..."
  local installedver="$(LANG= sudo pacman -Qi archlinux-keyring 2>/dev/null | grep -Po '(?<=Version         : ).*')"
  local currentver="$(LANG= sudo pacman -Si archlinux-keyring 2>/dev/null | grep -Po '(?<=Version         : ).*')"
  if [[ "$installedver" != "$currentver" ]]; then
    echo " Arch Linux PGP Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -Sy --needed --noconfirm archlinux-keyring
  else
    echo " Arch Linux PGP Keyring is up to date."
  fi

  echo ":: Checking Chaotic AUR Keyring..."
  local chaotic_installedver="$(LANG= sudo pacman -Qi chaotic-keyring 2>/dev/null | grep -Po '(?<=Version         : ).*')"
  local chaotic_currentver="$(LANG= sudo pacman -Si chaotic-keyring 2>/dev/null | grep -Po '(?<=Version         : ).*')"
  if [[ "$chaotic_installedver" != "$chaotic_currentver" ]]; then
    echo " Chaotic AUR Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -Sy --needed --noconfirm chaotic-keyring
  else
    echo " Chaotic AUR Keyring is up to date."
  fi

  echo ":: Checking Arch News for manual interventions..."
  if command -v checkupdates-archnews &>/dev/null; then
    checkupdates-archnews
  else
    echo " (Install 'pacman-contrib' to automatically check Arch News)"
  fi

  echo ":: Proceeding with full system upgrade..."
  if (( $+commands[yay] )); then
    yay -Syu
  elif (( $+commands[trizen] )); then
    trizen -Syu
  elif (( $+commands[pacaur] )); then
    pacaur -Syu
  elif (( $+commands[aura] )); then
    sudo aura -Syu
  else
    sudo pacman -Syu
  fi

  flatpak update
}


# Shell Intergrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
# eval "$(fnm env --use-on-cd)"
eval "$(mise activate zsh)"

# Export Paths

# pnpm
export PNPM_HOME="/home/zura/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Local Bin
export PATH="$HOME/.local/bin:$PATH"


export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

export CHROME_EXECUTABLE=chromium
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
