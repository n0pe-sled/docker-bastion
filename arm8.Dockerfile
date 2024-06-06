# Use Debian 12 as base image
FROM debian:stable@sha256:ff394977014e94e9a7c67bb22f5014ea069d156b86e001174f4bae6f4618297a

ENV DEBIAN_FRONTEND=noninteractive

# Run updates and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    openvpn \ 
    wget \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    libkrb5-dev \
    krb5-config \
    curl \
    gpg \
    unzip \
    git \
    jq \
    dnsutils \
    nano \
    net-tools \
    ldap-utils \
    libssl-dev \
    screen \
    nmap \
    make \
    build-essential \
    unzip \
    locate \
    default-jdk \
    tmux \
    docker.io \
    proxychains-ng \
    tcpdump \
    zsh && \
    chsh -s $(which zsh)

# Install Powershell
RUN curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-arm64.tar.gz && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Install GCloud CLI
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install google-cloud-cli -y

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \ 
    rm -rf awscliv2.zip 

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Metasploit
RUN curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | gpg --dearmor | tee /usr/share/keyrings/metasploit.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/metasploit.gpg] https://apt.metasploit.com/ buster main" | tee /etc/apt/sources.list.d/metasploit-framework.list && \
    apt update && \
    apt install metasploit-framework -y

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Go
RUN curl -O https://dl.google.com/go/go1.22.2.linux-arm64.tar.gz && \
    tar xvf go1.22.2.linux-arm64.tar.gz && \
    rm go1.22.2.linux-arm64.tar.gz && \
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

# Make a directory for tools
RUN mkdir /opt/tools

# Install Python tooling
RUN pipx ensurepath && \
    pipx install dirsearch && \
    pipx install dnsrecon && \
    pipx install impacket && \
    pipx install bloodhound && \
    pipx install sqlmap && \
    pipx install certipy-ad && \
    pipx install Coercer && \
    pipx install pyldapsearch && \
    pipx install pysqlrecon && \
    pipx install ROADtools --include-deps && \
    pipx install spraycharles && \
    pipx install git+https://github.com/nccgroup/PMapper --include-deps && \
    pipx install git+https://github.com/nccgroup/ScoutSuite --include-deps && \
    pipx install git+https://github.com/blacklanternsecurity/trevorspray && \
    pipx install git+https://github.com/blacklanternsecurity/trevorproxy && \
    git clone https://github.com/zer1t0/certi.git /opt/tools/certi && cd /opt/tools/certi && pipx install . && \
    git clone https://github.com/cddmp/enum4linux-ng.git /opt/tools/enum4linux-ng && cd /opt/tools/enum4linux-ng && pipx install . && \
    git clone https://github.com/lanmaster53/recon-ng.git /opt/tools/recon-ng && python3 -m venv /root/.local/pipx/venvs/recon-ng && /root/.local/pipx/venvs/recon-ng/bin/pip install -r /opt/tools/recon-ng/REQUIREMENTS && echo "#\!/bin/bash\n/root/.local/pipx/venvs/recon-ng/bin/python /opt/tools/recon-ng/recon-ng \"\$@\"" > /usr/bin/recon-ng && chmod +x /usr/bin/recon-ng  && \
    git clone https://github.com/topotam/PetitPotam.git /opt/tools/PetitPotam && echo "#\!/bin/bash\n/root/.local/pipx/venvs/impacket/bin/python /opt/tools/PetitPotam/PetitPotam.py \"\$@\"" > /usr/bin/PetitPotam && chmod +x /usr/bin/PetitPotam && \
    git clone https://github.com/garrettfoster13/pre2k.git /opt/tools/pre2k && cd /opt/tools/pre2k && pipx install . && \
    git clone https://github.com/ShutdownRepo/pywhisker.git /opt/tools/pywhisker && python3 -m venv /root/.local/pipx/venvs/pywhisker && /root/.local/pipx/venvs/pywhisker/bin/pip install -r /opt/tools/pywhisker/requirements.txt && echo "#\!/bin/bash\n/root/.local/pipx/venvs/pywhisker/bin/python /opt/tools/pywhisker/pywhisker.py \"\$@\"" > /usr/bin/pywhisker && chmod +x /usr/bin/pywhisker && \
    git clone https://github.com/dirkjanm/PKINITtools.git /opt/tools/PKINITtools && python3 -m venv /root/.local/pipx/venvs/PKINITtools && /root/.local/pipx/venvs/PKINITtools/bin/pip install -r /opt/tools/PKINITtools/requirements.txt && echo "#\!/bin/bash\n/root/.local/pipx/venvs/PKINITtools/bin/python /opt/tools/PKINITtools/getnthash.py \"\$@\"" > /usr/bin/getnthash && chmod +x /usr/bin/getnthash && echo "#\!/bin/bash\n/root/.local/pipx/venvs/PKINITtools/bin/python /opt/tools/PKINITtools/gets4uticket.py \"\$@\"" > /usr/bin/gets4uticket && chmod +x /usr/bin/gets4uticket && \
    git clone https://github.com/garrettfoster13/sccmhunter.git /opt/tools/sccmhunter && cd /opt/tools/sccmhunter && python3 -m venv /root/.local/pipx/venvs/sccmhunter && /root/.local/pipx/venvs/sccmhunter/bin/pip install -r /opt/tools/sccmhunter/requirements.txt && echo "#\!/bin/bash\n/root/.local/pipx/venvs/sccmhunter/bin/python /opt/tools/sccmhunter/sccmhunter.py \"\$@\"" > /usr/bin/sccmhunter && chmod +x /usr/bin/sccmhunter && \
    git clone https://github.com/XiaoliChan/wmiexec-Pro.git /opt/tools/wmiexec-Pro && cd /opt/tools/wmiexec-Pro && python3 -m venv /root/.local/pipx/venvs/wmiexec-Pro && /root/.local/pipx/venvs/wmiexec-Pro/bin/pip install impacket numpy && echo "#\!/bin/bash\n/root/.local/pipx/venvs/wmiexec-Pro/bin/python /opt/tools/wmiexec-Pro/wmiexec-pro.py \"\$@\"" > /usr/bin/wmiexec-pro && chmod +x /usr/bin/wmiexec-pro && \
    git clone https://github.com/carlospolop/bf-aws-perms-simulate.git /opt/tools/bf-aws-perms-simulate && python3 -m venv /root/.local/pipx/venvs/bf-aws-perms-simulate && /root/.local/pipx/venvs/bf-aws-perms-simulate/bin/pip install -r /opt/tools/bf-aws-perms-simulate/requirements.txt && echo "#\!/bin/bash\n/root/.local/pipx/venvs/bf-aws-perms-simulate/bin/python /opt/tools/bf-aws-perms-simulate/bf-aws-perms-simulate.py \"\$@\"" > /usr/bin/bf-aws-perms-simulate && chmod +x /usr/bin/bf-aws-perms-simulate

# Install Java Tools
RUN mkdir /opt/tools/ysoserial && wget https://github.com/frohoff/ysoserial/releases/latest/download/ysoserial-all.jar -O /opt/tools/ysoserial/ysoserial-all.jar && echo "#\!/bin/bash\njava -jar /opt/tools/ysoserial/ysoserial-all.jar \"\$@\"" > /usr/bin/ysoserial && chmod +x /usr/bin/ysoserial

# Install Golang tools

RUN /usr/local/go/bin/go install github.com/sensepost/gowitness@latest && \
    git clone https://github.com/Macmod/godap /opt/tools/godap && cd /opt/tools/godap && /usr/local/go/bin/go install . && \
    /usr/local/go/bin/go install github.com/ropnop/kerbrute@latest && \
    git clone https://github.com/Synzack/ldapper.git /opt/tools/ldapper && cd /opt/tools/ldapper && /usr/local/go/bin/go mod tidy && /usr/local/go/bin/go install . && \
    git clone https://github.com/MitchellDStein/TeamsUserEnum.git /opt/tools/TeamsUserEnum && cd /opt/tools/TeamsUserEnum/src && /usr/local/go/bin/go install . && \
    /usr/local/go/bin/go install github.com/BishopFox/cloudfox@latest

# Install Perl Tools
RUN git clone https://github.com/sullo/nikto /opt/tools/nikto && echo "#\!/bin/bash\nperl /opt/tools/nikto/program/nikto.pl \"\$\@\"" > /usr/bin/nikto && chmod +x /usr/bin/nikto 
    
# Installing Bash Tools
RUN git clone https://github.com/carlospolop/bf-aws-permissions.git /opt/tools/bf-aws-permissions && ln -s /opt/tools/bf-aws-permissions/bf-aws-permissions.sh /usr/bin/bf-aws-permissions && \
    git clone https://github.com/ChrisTruncer/mikto.git /opt/tools/mikto && echo "#\!/bin/bash\nbash /opt/tools/mikto/Mikto.sh \"\$@\"" > /usr/bin/mikto && chmod +x /usr/bin/mikto && \
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Installing Powershell Tools
RUN git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/tools/PowerSploit && \
    git clone https://github.com/NetSPI/MicroBurst.git /opt/tools/MicroBurst && \
    git clone https://github.com/BloodHoundAD/BARK.git /opt/tools/BARK 

# Back to the home directory
WORKDIR /root

# Define the entrypoint command
ENTRYPOINT ["/usr/bin/zsh"]