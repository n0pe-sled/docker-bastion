# Use Debian 11 as base image
FROM debian:11@sha256:c14a1d98c1f3c16597a068ab6b5edc1f8f6acb87bf18651adcc96d8467a92693

# Run updates and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    openvpn \ 
    python3 \
    python3-venv \
    curl \
    gpg \
    unzip \
    git \
    jq \
    dnsutils \
    nano \
    net-tools \
    screen \
    nmap \
    make \
    build-essential \
    unzip \
    zsh && \
    chsh -s $(which zsh)

# Install GCloud CLI
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install google-cloud-cli -y


# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install \ 
    rm -rf awscliv2.zip 

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Go
RUN curl -O https://dl.google.com/go/go1.21.0.linux-arm64.tar.gz && \
    tar xvf go1.21.0.linux-arm64.tar.gz && \
    rm go1.21.0.linux-arm64.tar.gz && \
    chown -R root:root ./go && \
    mv go /usr/local

# Install Nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
apt-get install -y nodejs

# Setup Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k && \
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

COPY .p10k.zsh /root/.p10k.zsh

COPY .zshrc /root/.zshrc

# Make tools directory
RUN mkdir -p /opt/tools

# Clone repositories
RUN git clone https://github.com/fortra/impacket /opt/tools/impacket && \
    git clone https://github.com/sensepost/gowitness.git /opt/tools/gowitness 

# Back to the home directory
WORKDIR /root
