sudo dnf install -y i3 fontawesome-fonts xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-xauth xorg-x11-apps mesa-dri-drivers lxdm
sudo X -configure
sudo cp /root/xorg.conf.new /etc/X11/xorg.conf
sudo systemctl set-default graphical
sudo sed -i 's,# session=/usr/bin/startlxde,session=/usr/bin/i3,' /etc/lxdm/lxdm.conf
sudo systemctl enable -f lxdm
sudo dnf install -y zsh curl git pipenv keepassxc neovim fd-find the_silver_searcher fzf pam-devel libX11-devel libXcomposite-devel libXext-devel libXfixes-devel libXft-devel libXmu-devel libXrandr-devel pkgconf-pkg-config xorg-x11-proto-devel autoconf automake xss-lock rofi firefox rsync nodejs feh ranger tar unzip nmap net-tools pciutils maim xclip i3status-rs fontawesome-fonts lm_sensors
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

# kitty terminal install
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
mkdir ~/.local/share/applications
mkdir ~/.local/bin
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" ~/.local/share/applications/kitty.desktop

# ranger update desktop file
sudo sed -i "s,Terminal=true,$Terminal=true," /usr/share/applications/ranger.desktop
sudo sed -i "s,Exec=ranger,Exec=kitty ranger," /usr/share/applications/ranger.desktop

# remove rhgb 
sudo sed -i "s,rhgb,," /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# install oh-my-zsh
sudo sed -i "s,$USER:/bin/bash,$USER:/bin/zsh," /etc/passwd
env KEEP_ZSHRC=yes RUNZSH=no CHSH=no bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify

# optional - install nm-applet and NetworkManager-wifi if using laptop
# remove 'ServerLayout" Screen iptions from /etc/X11/xorg.conf, if there is problem with mouse traverse edges
