#!/bin/bash

# Ask for password once and keep sudo alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Starting installation..."
echo "I am a lazy guy :P"
# Copy config files
echo "Copying configuration files..."
cp -r .config/. ~/
cp -r -.zshrc ~/
[ -d ".themes" ] && cp -r .themes/. ~/.themes/
[ -d "Pictures" ] && cp -r Pictures/. ~/Pictures/
# Update system
sudo pacman -Syu --noconfirm

# Install yay
echo "Installing yay..."
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay

# Core
echo "Installing core packages..."
sudo pacman -S --needed --noconfirm base base-devel git sudo wget

# Boot
echo "Installing boot packages..."
sudo pacman -S --needed --noconfirm grub efibootmgr

# Drivers
echo "Installing drivers..."
sudo pacman -S --needed --noconfirm intel-ucode intel-media-driver libva-intel-driver vulkan-intel

# Hyprland
echo "Installing Hyprland..."
sudo pacman -S --needed --noconfirm hyprland xdg-desktop-portal-hyprland xdg-utils qt6-wayland uwsm hyprpolkitagent

# Display manager
echo "Installing sddm..."
sudo pacman -S --needed --noconfirm sddm

# Audio
echo "Installing audio..."
sudo pacman -S --needed --noconfirm pipewire wireplumber pipewire-pulse pavucontrol

# Networking
echo "Installing networking..."
sudo pacman -S --needed --noconfirm iwd nm-connection-editor

# Bar and launcher
echo "Installing bar and launcher..."
sudo pacman -S --needed --noconfirm waybar wofi dunst

# Terminal
echo "Installing terminal..."
sudo pacman -S --needed --noconfirm kitty

# Fonts
echo "Installing fonts..."
sudo pacman -S --needed --noconfirm noto-fonts ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common

# Wallpaper
echo "Installing swww..."
sudo pacman -S --needed --noconfirm swww

# Pywal
echo "Installing pywal..."
sudo pacman -S --needed --noconfirm python-pywal python-pywalfox

# Shell
echo "Installing zsh..."
sudo pacman -S --needed --noconfirm zsh

# Theming
echo "Installing theming tools..."
sudo pacman -S --needed --noconfirm nwg-look qt5ct

# File manager
sudo pacman -S --needed --noconfirm nemo

# System tools
sudo pacman -S --needed --noconfirm brightnessctl playerctl btop fastfetch

# Browser
sudo pacman -S --needed --noconfirm firefox

# Oomox dependencies
sudo pacman -S --needed --noconfirm sassc gtk-engine-murrine gtk-engines flatpak

# AUR packages
echo "Installing AUR packages..."
yay -S --needed --noconfirm grimblast-git hyprlauncher wlogout sddm-astronaut-theme com.github.themix_project.Oomox python-pywal



# Set zsh as default shell
echo "Setting zsh as default shell..."
chsh -s /usr/bin/zsh

# Enable sddm
echo "Enabling sddm..."
sudo systemctl enable sddm

# Set sddm theme
echo "Setting sddm theme..."
sudo mkdir -p /etc/sddm.conf.d/
sudo bash -c 'cat > /etc/sddm.conf.d/theme.conf << EOF
[Theme]
Current=sddm-astronaut-theme
EOF'

# Create post-install script
cat > ~/post-install.sh << 'EOF'
#!/bin/bash
echo "Running post install setup..."

swww-daemon &
sleep 2

swww img ~/Pictures/Wallpapers/wallpaper_animated.gif
wal -i ~/Pictures/Wallpapers/wallpaper_animated.gif -n

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