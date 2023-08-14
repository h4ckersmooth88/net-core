#!/bin/bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update 
sudo apt install apt-transport-https -y
sudo apt install dotnet-sdk-2.1 -y
