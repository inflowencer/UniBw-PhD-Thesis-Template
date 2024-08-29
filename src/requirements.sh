#!/bin/bash

wdir=$(pwd)
APPTAINER_VERSION="1.3.3"
IMAGE_LINK="1.3.3"

. /etc/os-release
OS=$NAME

echo -e "OS: $NAME\nRunning setup script..."
sleep 2

function debian {
    echo -e "Installing git-lfs support..."
    sleep 2
    sudo apt install git-lfs

    echo -e "Installing apptainer for compilation..."
    sleep 2
    mkdir -p tmp
    cd tmp
    wget https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/apptainer_${APPTAINER_VERSION}_amd64.deb
    wget https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/apptainer-suid_${APPTAINER_VERSION}_amd64.deb
    sudo apt install -y ./apptainer_${APPTAINER_VERSION}_amd64.deb
    sudo apt install -y ./apptainer-suid_${APPTAINER_VERSION}_amd64.deb
    cd .. && rm -rf tmp

    echo -e "Pulling remote image..."
    sleep 2
    mkdir -p image && cd image
    apptainer remote add --no-login SylabsCloud cloud.sycloud.io
    apptainer remote use SylabsCloud
    apptainer pull --arch amd64 library://inflowencer/lpt/lpt:latest
    chmod +x lpt_latest.sif
    cd ..
    touch .imageconf
    echo "image=./image/lpt_latest.sif" > .imageconf

    echo -e "Repo setup is complete..."
    sleep 2
}

function centos {
    sleep 1
}

if [[ $OS == *"Ubuntu"* ]]; then
    debian
elif [[ $OS == *"Rocky"* ]]; then
    centos
fi
