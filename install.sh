#!/bin/bash

# Update and install necessary packages
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y \
    python3 \
    unzip \
    gpg \
    openvpn \
    python3-venv \
    curl \
    git \
    dnsutils \
    nano \
    net-tools \
    screen \
    nmap \
    make \
    build-essential \
    unzip \
    zsh 

sudo chsh ubuntu -s $(which zsh)

# Install GCloud CLI
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli -y

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
rm awscliv2.zip
sudo ./aws/install

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Go
curl -O https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz
tar xvf go1.21.0.linux-amd64.tar.gz
rm go1.21.0.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local

export PATH=$PATH:/usr/local/go/bin/

# Install Nodejs
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
sudo apt-get install -y nodejs

# Setup Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k 

mv .zshrc ~/
mv .p10k.zsh ~/

# Make tools directory
mkdir -p ~/tools

# Clone repositories
git clone https://github.com/fortra/impacket ~/tools/impacket 
git clone https://github.com/sensepost/gowitness.git ~/tools/gowitness
git clone https://github.com/xjasonlyu/tun2socks.git
