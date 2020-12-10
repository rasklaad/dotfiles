sudo dnf install -y i3 fontawesome-fonts xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-xauth xorg-x11-apps mesa-dri-drivers lxdm
sudo X -configure
sudo cp /root/xorg.conf.new /etc/X11/xorg.conf
sudo systemctl set-default graphical
sudo sed -i 's,# session=/usr/bin/startlxde,session=/usr/bin/i3,' /etc/lxdm/lxdm.conf
sudo systemctl enable -f lxdm
sudo dnf install -y zsh curl git pipenv keepassxc neovim fd-find the_silver_searcher fzf pam-devel libX11-devel libXcomposite-devel libXext-devel libXfixes-devel libXft-devel libXmu-devel libXrandr-devel pkgconf-pkg-config xorg-x11-proto-devel autoconf automake xss-lock rofi firefox rsync nodejs feh ranger tar unzip nmap net-tools pciutils maim xclip i3status-rs lm_sensors cmake freetype-devel fontconfig-devel libxcb-devel ncdu sshfs sqlite dejavu-serif-fonts dejavu-sans-mono-fonts
sudo dnf group install -y 'Development Tools'

# copy my dotfiles
mkdir ~/projects
git clone https://github.com/rasklaad/dotfiles.git ~/projects/dotfiles
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

# xsecurelock install
git clone https://github.com/google/xsecurelock.git ~/.local/xsecurelock
cd $HOME/.local/xsecurelock
./autogen.sh
./configure --with-pam-service-name=authproto_pam
make
sudo make install

# rust install 
curl https://sh.rustup.rs -sSf | sh -s -- -y

# alacritty install
cd $HOME/.local
mkdir -p $HOME/.local/bin
git clone https://github.com/alacritty/alacritty.git
cd alacritty
$HOME/.cargo/bin/cargo build --release
ln -s $HOME/.local/alacritty/target/release/alacritty $HOME/.local/bin/alacritty


# ranger update desktop file
sudo sed -i "s,Terminal=true,#Terminal=true," /usr/share/applications/ranger.desktop
sudo sed -i "s,Exec=ranger,Exec=alacritty -e ranger," /usr/share/applications/ranger.desktop

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
# sudo dnf install network-manager-applet NetworkManager-wifi tlp
# sudo systemctl enable tlp
# remove 'ServerLayout" Screen iptions from /etc/X11/xorg.conf, if there is problem with mouse traverse edges
