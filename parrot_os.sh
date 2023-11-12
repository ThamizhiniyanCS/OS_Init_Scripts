#! /bin/bash

DOCKER_HUB_USERNAME=""
DOCKER_HUB_PASSWORD=""
TEMPORARY_DIRECTORY="/tmp/OS_INIT_SCRIPT"

# Making a directory for temporary installation files
mkdir $TEMPORARY_DIRECTORY && cd $TEMPORARY_DIRECTORY

# Updating the repositories
sudo apt update

# Installing Dependencies
sudo apt install curl
sudo apt-get install wget gpg
sudo apt install apt-transport-https

# Checking whether ~/.bashrc is available, if not creating ~/.bashrc file
if [ -f "$HOME/.bashrc" ]; then echo "~/.bashrc already exists."; else touch $HOME/.bashrc; fi

# Aliases
declare -a ALIASES=(
[0]='theharvester=python3 /opt/theHarvester/theHarvester.py'
[1]='rustscan=docker run -it --rm --name rustscan rustscan/rustscan:2.1.1'
)

for each in "${ALIASES[@]}"; do
	echo alias $each >> $HOME/.bashrc
done

# Flatpak Installation
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Brave Browser Installation
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
# Flatpak
flatpak install flathub com.brave.Browser

# Chrome Browser Installation
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# Flatpak
flatpak install flathub com.google.Chrome

# Opera Browser Installation
wget -O- https://deb.opera.com/archive.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/opera.gpg
echo deb [arch=amd64 signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free | sudo tee /etc/apt/sources.list.d/opera.list
sudo apt update
sudo apt install opera-stable
# Flatpak
flatpak install flathub com.opera.Opera

# Github Installation
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# NVM Installation
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
# Updating the .bashrc file
echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $HOME/.bashrc
source $HOME/.bashrc
# Installing Nodejs latest Version
nvm install node && nvm use node
# Installing Nodejs lts Version
# nvm install --lts && nvm use --lts

# Visual Studio Code Installation
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code

# Docker Installation
sudo apt install docker.io docker-compose
# Docker regsitry login hub.docker.com
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD

# TheHarvester installation using docker
cd /opt
git clone https://github.com/theHarvester/theHarvester.git
cd theHarvester
mkdir $HOME/.theHarvester
echo "apikeys:
  bing:
    key: 

  github:
    key: 

  hunter:
    key: 

  intelx:
    key: 9df61df0-84f7-4dc7-b34c-8ccfb8646ace

  securityTrails:
    key: 

  shodan:
    key: oCiMsgM6rQWqiTvPxFHYcExlZgg7wvTt
" > $HOME/.theHarvester/api-keys.yaml
python3 -m pip install -r requirements/base.txt

# Uninstall Opera Browser
# sudo apt autoremove opera-stable --purge