# Use Debian 12 as base image
FROM debian:stable@sha256:ff394977014e94e9a7c67bb22f5014ea069d156b86e001174f4bae6f4618297a

ENV DEBIAN_FRONTEND=noninteractive

COPY install.sh ./install.sh

RUN chmod +x install.sh && \
    ./install.sh

COPY .p10k.zsh /root/.p10k.zsh

COPY .zshrc /root/.zshrc

# Back to the home directory
WORKDIR /root

# Define the entrypoint command
ENTRYPOINT ["/usr/bin/zsh"]