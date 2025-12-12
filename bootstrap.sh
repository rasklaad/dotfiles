set +xe
sudo dnf install --skip-unavailable zsh curl git keepassxc neovim fd-find the_silver_searcher fzf pam-devel pkgconf-pkg-config autoconf automake wofi firefox rsync feh tar unzip nmap net-tools pciutils lm_sensors cmake freetype-devel fontconfig-devel libxcb-devel ncdu sshfs sqlite dejavu-serif-fonts dejavu-sans-mono-fonts pavucontrol xbindkeys alacritty inotify-tools pamu2fcfg pam-u2f sway swaylock grim wl-clipboard wf-recorder
sudo dnf group install -y 'Development Tools'

# copy my dotfiles
cd ~/projects/dotfiles
rsync -r --exclude=.git --exclude=README.MD . ~/

# hack font install
cd $HOME
curl -O -L --silent https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
unzip Hack-v3.003-ttf.zip
sudo cp ./ttf/* /usr/share/fonts/
sudo curl https://raw.githubusercontent.com/source-foundry/Hack/master/config/fontconfig/45-Hack.conf --output /etc/fonts/conf.d/45-Hack.conf
sudo fc-cache -f -v
rm -f Hack-v3.003-ttf.zip
rm -rf ttf

# remove rhgb 
sudo sed -i "s,rhgb,," /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# install oh-my-zsh
sudo sed -i "s,$USER:/bin/bash,$USER:/bin/zsh," /etc/passwd
env KEEP_ZSHRC=yes RUNZSH=no CHSH=no bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify

# optional (for laptop):
#sudo dnf install tlp
#sudo systemctl enable tlp
# sudo modprobe btusb
# sudo systemctl enable bluetooth
# sudo dnf install -y blueman bluez-tools python3-cairo
# remove 'ServerLayout" Screen iptions from /etc/X11/xorg.conf, if there is problem with mouse traverse edges
