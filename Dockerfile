# Use Debian 11 as base image
FROM debian:11@sha256:84341aded75be116ba3115f5a7916f3c3cd9916c82335744d2a36df9dfa7c0cf

# Run updates and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    python3 \
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
RUN curl -O https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz && \
    tar xvf go1.16.2.linux-amd64.tar.gz && \
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
RUN mkdir -p /root/tools

# Clone repositories
RUN git clone https://github.com/fortra/impacket /root/tools/impacket && \
    git clone https://github.com/sensepost/gowitness.git /root/tools/gowitness

# Back to the home directory
WORKDIR /root

# Start from ZSH
ENTRYPOINT /usr/bin/zsh
