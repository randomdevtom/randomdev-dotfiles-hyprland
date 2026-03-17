#!/bin/bash

echo "Starting installation..."

# Update system
sudo pacman -Syu --noconfirm

# Install yay
echo "Installing yay..."
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay

# ── pacman ───────────────────────────────────────────────────
echo "Installing pacman packages..."
sudo pacman -S --needed --noconfirm \
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
yay -S --needed --noconfirm \
  grimblast-git \
  hyprlauncher \
  wlogout \
  com.github.themix_project.Oomox

# ── Copy config files ─────────────────────────────────────────
echo "Copying configuration files..."
cp -r .config/* ~/.config/
cp .zshrc ~/

# Copy themes and wallpapers if they exist
[ -d ".themes" ] && cp -r .themes/. ~/.themes/
[ -d "Pictures" ] && cp -r Pictures/. ~/Pictures/

# ── Shell ─────────────────────────────────────────────────────
echo "Setting zsh as default shell..."
chsh -s $(which zsh)

# ── Enable services ───────────────────────────────────────────
echo "Enabling sddm..."
sudo systemctl enable sddm

# ── Post login script ─────────────────────────────────────────
# Create a script that runs after first Hyprland login
cat > ~/post-install.sh << 'EOF'
#!/bin/bash
echo "Running post install setup..."

# Start swww
swww-daemon &
sleep 2

# Set wallpaper and generate pywal colors
swww img ~/Pictures/Wallpapers/wallpaper_animated.gif
wal -i ~/Pictures/Wallpapers/wallpaper_animated.gif -n

# Generate oomox GTK theme
source ~/.cache/wal/colors.sh

OOMOX_THEME_SCRIPT="/var/lib/flatpak/app/com.github.themix_project.Oomox/x86_64/stable/current/files/opt/oomox/plugins/theme_oomox/change_color.sh"

OOMOX_COLORS=$(mktemp)
cat > "$OOMOX_COLORS" << COLORS
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
COLORS

"$OOMOX_THEME_SCRIPT" -o "pywal" "$OOMOX_COLORS"
gsettings set org.gnome.desktop.interface gtk-theme "oomox-pywal"
rm "$OOMOX_COLORS"

echo "Post install done! You can delete ~/post-install.sh"
EOF

chmod +x ~/post-install.sh

echo "Done! Please reboot, then run ~/post-install.sh after logging into Hyprland."