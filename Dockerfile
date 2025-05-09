FROM ubuntu:24.04

# Update and install desktop environment and XRDP
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y lubuntu-desktop && \
    apt install -y xrdp && \
    adduser xrdp ssl-cert

# Create a user and add to sudo group
RUN useradd -m demo && \
    echo "demo:demo" | chpasswd && \
    usermod -aG sudo demo

# Expose port 3389
EXPOSE 3389

# Start services

CMD service xrdp start && \
    /bin/bash

# https://github.com/linuxserver/docker-rdesktop
# https://github.com/linuxserver/docker-webtop
# https://medium.com/cloud-for-all/running-ubuntu-os-with-gui-in-a-docker-container-rdp-dbecb0880893
# docker build -t lubuntuos .
# docker run -it -p 3390:3389 --name dev1 lubuntuos

