#!/bin/bash

LIST_OF_APPS="amass figlet sublist3r subfinder cargo httpx-toolkit assetfinder nuclei seclists"

if [[ "$(whoami)" != root ]]; then
  echo "Only sudo user can run this script."
  exit 1
echo "installing the must-have pre-requisites"
while read -r p 
do 
sudo apt-get update && sudo apt-get install -y  $LIST_OF_APPS;

git clone https://github.com/Edu4rdSHL/findomain.git;cd findomain;cargo build --release;sudo cp target/release/findomain /usr/bin/;

done 

echo "DONE"

