#!/bin/bash

echo "Starting installation..."
echo "You will be asked to enter your password to install the required dependencies."
echo "Some stuff you might not need so feel free to delete what you want"
echo "I am a lazy guy :P"

# Update system
sudo pacman -Syu

# Install yay
echo "Installing yay..."
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd .. && rm -rf yay

# ── pacman ───────────────────────────────────────────────────
echo "Installing pacman packages..."
sudo pacman -S --needed \
  base base-devel git sudo wget \
  grub efibootmgr \
  intel-ucode intel-media-driver libva-intel-driver vulkan-intel \
  hyprland xdg-desktop-portal-hyprland xdg-utils qt6-wayland uwsm hyprpolkitagent \
  sddm \
  pipewire wireplumber pipewire-pulse pavucontrol \
  iwd nm-connection-editor \
  waybar \
  wofi \
  dunst \
  kitty \
  noto-fonts ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common \
  swww \
  python-pywal python-pywalfox \
  zsh \
  nwg-look qt5ct \
  nemo \
  brightnessctl \
  playerctl \
  firefox \
  btop fastfetch \
  sassc gtk-engine-murrine gtk-engines \
  flatpak

# ── AUR ──────────────────────────────────────────────────────
echo "Installing AUR packages..."
yay -S --needed \
  grimblast-git \
  hyprlauncher \
  wlogout \
  com.github.themix_project.Oomox

# ── Copy config files ─────────────────────────────────────────
echo "Copying configuration files..."
cp -r config/* ~/.config/
cp .zshrc ~/
cp -r .oh-my-zsh/* ~/.oh-my-zsh/
chsh -s $(which zsh)
cp -r .themes/* ~/.themes/
cp -r Pictures/* ~/Pictures/

# ── Enable SDDM ───────────────────────────────────────────────
echo "Enabling sddm..."
sudo systemctl enable sddm

# ── Pywal + oomox GTK theme ───────────────────────────────────
echo "Generating pywal colors..."
swww-daemon &
sleep 1
swww img ~/Pictures/Wallpapers/wallpaper_animated.gif
wal -i ~/Pictures/Wallpapers/wallpaper_animated.gif -n

echo "Building oomox GTK theme from pywal colors..."
source ~/.cache/wal/colors.sh

OOMOX_THEME_SCRIPT="/var/lib/flatpak/app/com.github.themix_project.Oomox/x86_64/stable/current/files/opt/oomox/plugins/theme_oomox/change_color.sh"

OOMOX_COLORS=$(mktemp)
cat > "$OOMOX_COLORS" << EOF
BG=${background#\#}
FG=${foreground#\#}
SEL_BG=${color1#\#}
SEL_FG=${foreground#\#}
BTN_BG=${color2#\#}
BTN_FG=${foreground#\#}
HDR_BG=${color0#\#}
HDR_FG=${foreground#\#}
TXT_BG=${background#\#}
TXT_FG=${foreground#\#}
ROUNDNESS=4
GRADIENT=0.0
SPACING=3
EOF

"$OOMOX_THEME_SCRIPT" -o "pywal" "$OOMOX_COLORS"
gsettings set org.gnome.desktop.interface gtk-theme "oomox-pywal"
rm "$OOMOX_COLORS"

echo "Done! Please reboot."