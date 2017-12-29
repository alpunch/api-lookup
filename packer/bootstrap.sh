#!/bin/bash

# Install python
sudo apt-get update
sudo apt-get install -qy python

# Remove potential existing docker installation
sudo apt-get remove -qy docker docker-engine docker.io

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -qy \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install docker-ce
sudo apt-get update
sudo apt-get install -qy docker-ce