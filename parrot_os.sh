#! /bin/bash

DOCKER_HUB_USERNAME=""
DOCKER_HUB_PASSWORD=""

# Checking whether ~/.bashrc is available, if not creating ~/.bashrc file
if [ -f "$HOME/.bashrc" ]; then echo "~/.bashrc already exists."; else touch $HOME/.bashrc; fi

# Aliases
declare -a ALIASES=(
[0]='theharvester=docker run --rm -it --mount type=bind,source="$HOME/.theHarvester/api-keys.yaml",target="/app/api-keys.yaml" --entrypoint "/app/theHarvester.py" theharvester'
[1]='rustscan=docker run -it --rm --name rustscan rustscan/rustscan:2.1.1'
)

for each in "${ALIASES[@]}"; do
	echo alias $each >> $HOME/.bashrc
done

# Github Installation
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# NVM Installation

# Docker Installation
sudo apt install docker.io docker-compose
# Docker regsitry login hub.docker.com
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD

# TheHarvester installation using docker

