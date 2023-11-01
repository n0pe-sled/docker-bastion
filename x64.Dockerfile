# Use Debian 11 as base image
FROM debian:11@sha256:7a5314b612556354fd3e0bf85cffd5e3565bd390377dce8aa5e2eb86b4d8f698

# Run updates and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    python3 \
    openvpn \
    python3-venv \
    curl \
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
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Go
RUN curl -O https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz && \
    tar xvf go1.21.0.linux-amd64.tar.gz && \
    chown -R root:root ./go && \
    mv go /usr/local && \
    export PATH=$PATH:/usr/local/go/bin/

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
