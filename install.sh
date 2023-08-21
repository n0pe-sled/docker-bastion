#!/bin/bash

# Update and install necessary packages
apt-get update && apt-get upgrade -y && apt-get install -y \
    python3 \
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
chsh -s $(which zsh)

# Install GCloud CLI
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get update -y && apt-get install google-cloud-sdk -y

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Go
curl -O https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz
tar xvf go1.21.0.linux-amd64.tar.gz
chown -R root:root ./go
mv go /usr/local

export PATH=$PATH:/usr/local/go/bin/

# Install Nodejs
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Setup Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k 

mv .zshrc ~/
mv .p10k.zsh ~/

# Make tools directory
mkdir -p /root/tools

# Clone repositories
git clone https://github.com/fortra/impacket /root/tools/impacket 
git clone https://github.com/sensepost/gowitness.git /root/tools/gowitness
