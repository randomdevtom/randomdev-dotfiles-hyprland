#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# UI helpers
info()    { echo -e "${CYAN}${BOLD}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC} $1"; }
warning() { echo -e "${YELLOW}${BOLD}[WARN]${NC} $1"; }
error()   { echo -e "${RED}${BOLD}[ERR]${NC} $1"; }
section() { echo -e "\n${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n${BOLD}  $1${NC}\n${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"; }

clear
echo -e "${CYAN}${BOLD}"
cat << 'BANNER'
  ██████╗  ██████╗ ████████╗███████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
  ██║  ██║██║   ██║   ██║   ███████╗
  ██║  ██║██║   ██║   ██║   ╚════██║
  ██████╔╝╚██████╔╝   ██║   ███████║
  ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
    Hyprland Dotfiles by randomdevtom
BANNER
echo -e "${NC}"
echo -e "${YELLOW}${BOLD}  I am a lazy guy :P${NC}\n"
sleep 1
echo -e "${RED}${BOLD}  WARNING: This script will overwrite existing config files!${NC}"
echo -e "${YELLOW}  Make sure to backup any configs you want to keep.${NC}\n"
read -p "  Press Enter to continue or Ctrl+C to cancel..."
# Ask for password once and keep sudo alive
info "Requesting sudo access..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
success "Sudo access granted!"

# ── Copy config files ─────────────────────────────────────────
section "Copying Configuration Files"
info "Copying .config (merging, keeping existing user configs)..."
cp -rf .oh-my-zsh ~/
cp -rn .config/. ~/.config/
cp -rf .config/hypr ~/.config/
cp -rf .config/waybar ~/.config/
cp -rf .config/kitty ~/.config/
cp -rf .config/wofi ~/.config/ 2>/dev/null || true
cp -rf .config/dunst ~/.config/ 2>/dev/null || true
cp -rf .config/nemo ~/.config/ 2>/dev/null || true
cp -rf .config/wal ~/.config/ 2>/dev/null || true
success "Config files copied!"

info "Copying .zshrc..."
cp -rf .zshrc ~/
cp -rf .ohmy-zsh/. ~/.oh-my-zsh/
success ".zshrc copied!"
info "Copying themes..."
[ -d ".themes" ] && cp -rf .themes/. ~/.themes/ && success "Themes copied!" || warning "No .themes folder found, skipping."

info "Copying icons..."
[ -d ".icons" ] && cp -rf .icons/. ~/.icons/ && success "Icons copied!" || warning "No .icons folder found, skipping."

info "Copying wallpapers..."
[ -d "Pictures" ] && cp -rf Pictures/. ~/Pictures/ && success "Wallpapers copied!" || warning "No Pictures folder found, skipping."

# ── Update system ─────────────────────────────────────────────
section "Updating System"
sudo pacman -Syu --noconfirm
success "System updated!"

# ── Install yay ───────────────────────────────────────────────
section "Installing Yay (AUR Helper)"
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
success "Yay installed!"

# ── Pacman packages ───────────────────────────────────────────
section "Installing Packages"

info "Core..."
sudo pacman -S --needed --noconfirm base base-devel git sudo wget flatpak
success "Core done!"

info "Boot..."
sudo pacman -S --needed --noconfirm grub efibootmgr
success "Boot done!"

info "Drivers..."
sudo pacman -S --needed --noconfirm intel-ucode intel-media-driver libva-intel-driver vulkan-intel vulkan-radeon vulkan-nouveau xf86-video-amdgpu xf86-video-ati xf86-video-nouveau
success "Drivers done!"

info "Hyprland & Wayland..."
sudo pacman -S --needed --noconfirm hyprland xdg-desktop-portal-hyprland xdg-utils qt6-wayland uwsm hyprpolkitagent
success "Hyprland done!"

info "Display manager..."
sudo pacman -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
success "SDDM done!"

info "Audio..."
sudo pacman -S --needed --noconfirm pipewire wireplumber pipewire-pulse pavucontrol
success "Audio done!"

info "Networking..."
sudo pacman -S --needed --noconfirm iwd nm-connection-editor
success "Networking done!"

info "Bar & launcher..."
sudo pacman -S --needed --noconfirm waybar wofi dunst
success "Bar & launcher done!"

info "Terminal..."
sudo pacman -S --needed --noconfirm kitty
success "Terminal done!"

info "Fonts..."
sudo pacman -S --needed --noconfirm noto-fonts ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common
success "Fonts done!"

info "Wallpaper..."
sudo pacman -S --needed --noconfirm swww
success "Wallpaper done!"

info "Pywal..."
sudo pacman -S --needed --noconfirm python-pywal bc sassc nwg-look
yay -S --needed --noconfirm python-pywalfox 
mkdir -p ~/.local/share/nwg-look
touch ~/.local/share/nwg-look/gsettings
success "Pywal done!"

info "Shell..."
sudo pacman -S --needed --noconfirm zsh
success "Shell done!"

info "Theming..."
sudo pacman -S --needed --noconfirm nwg-look qt5ct
success "Theming done!"

info "File manager..."
sudo pacman -S --needed --noconfirm nemo
success "File manager done!"

info "System tools..."
sudo pacman -S --needed --noconfirm brightnessctl playerctl btop fastfetch
success "System tools done!"

info "Browser..."
sudo pacman -S --needed --noconfirm firefox
success "Browser done!"

info "Oomox dependencies..."
sudo pacman -S --needed --noconfirm sassc gtk-engine-murrine gtk-engines
success "Oomox dependencies done!"

# ── AUR packages ──────────────────────────────────────────────
section "Installing AUR Packages"
yay -S --needed --noconfirm grimblast-git hyprlauncher wlogout sddm-astronaut-theme python-pywal
flatpak install -y flathub com.github.themix_project.Oomox
success "AUR packages done!"

# ── Default pywal colors ──────────────────────────────────────
section "Setting Up Default Colors"
mkdir -p ~/.cache/wal

cat > ~/.cache/wal/colors-hyprland.conf << 'WALEOF'
$foreground = rgb(ffffff)
$background = rgb(000000)
$color0 = rgb(000000)
$color1 = rgb(444444)
$color2 = rgb(888888)
$color3 = rgb(aaaaaa)
$color4 = rgb(bbbbbb)
$color5 = rgb(cccccc)
$color6 = rgb(dddddd)
$color7 = rgb(eeeeee)
$color8 = rgb(111111)
$color9 = rgb(555555)
$color10 = rgb(999999)
$color11 = rgb(aaaaaa)
$color12 = rgb(bbbbbb)
$color13 = rgb(cccccc)
$color14 = rgb(dddddd)
$color15 = rgb(ffffff)
WALEOF

cat > ~/.cache/wal/colors-waybar.css << 'WAYBAREOF'
@define-color foreground #ffffff;
@define-color background #000000;
@define-color color0 #000000;
@define-color color1 #444444;
@define-color color2 #888888;
@define-color color3 #aaaaaa;
@define-color color4 #bbbbbb;
@define-color color5 #cccccc;
@define-color color6 #dddddd;
@define-color color7 #eeeeee;
@define-color color8 #111111;
@define-color color9 #555555;
@define-color color10 #999999;
@define-color color11 #aaaaaa;
@define-color color12 #bbbbbb;
@define-color color13 #cccccc;
@define-color color14 #dddddd;
@define-color color15 #ffffff;
WAYBAREOF
success "Default colors created!"

# ── Shell ─────────────────────────────────────────────────────
section "Setting Up Shell"
info "Setting zsh as default shell..."
chsh -s /usr/bin/zsh
success "Zsh set as default shell!"

# ── Groups ────────────────────────────────────────────────────
section "Setting Up User Groups"
sudo usermod -aG input,storage $USER
success "User groups set!"

# ── SDDM ─────────────────────────────────────────────────────
section "Setting Up SDDM"

info "Copying fonts..."
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

info "Setting SDDM theme..."
sudo tee /etc/sddm.conf << 'SDDMEOF'
[Theme]
Current=sddm-astronaut-theme
SDDMEOF
sudo sed -i 's/ConfigFiles=Themes\/.*/ConfigFiles=Themes\/hyprland_kath.conf/' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
sudo mkdir -p /etc/sddm.conf.d/
sudo tee /etc/sddm.conf.d/virtualkbd.conf << 'KBDEOF'
[General]
InputMethod=qtvirtualkeyboard
KBDEOF

info "Enabling SDDM..."
sudo systemctl enable sddm
success "SDDM setup done!"
info "Applying SDDM theme..."
sudo sed -i 's/ConfigFile=Themes\/.*/ConfigFile=Themes\/hyprland_kath.conf/' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
success "SDDM theme applied!"
# ── Post install script ───────────────────────────────────────
section "Creating Post-Install Script"

cat > ~/post-install.sh << 'POSTEOF'
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}${BOLD}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC} $1"; }
error()   { echo -e "${RED}${BOLD}[ERR]${NC} $1"; }

echo -e "${CYAN}${BOLD}Running post-install setup...${NC}\n"

info "Starting swww daemon..."
swww-daemon &
sleep 2

info "Setting wallpaper and generating pywal colors..."

./wallpaper.sh ~/Pictures/Wallpapers/wallpaper-animated.gif
# ── Done ──────────────────────────────────────────────────────
echo -e "\n${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}  Installation complete!${NC}"
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n  ${BOLD}Next steps:${NC}"
echo -e "  ${CYAN}1.${NC} Enjoy :)"
