#!/bin/bash

LIST_OF_APPS="amass sublist3r subfinder cargo httpx-toolkit assetfinder nuclei"

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo installing the must-have pre-requisites
while read -r p ; do sudo apt get update && sudo apt-get install -y  $LIST_OF_APPS; done  
echo -e "\n"
sleep 3

git clone https://github.com/Edu4rdSHL/findomain.git;cd findomain;cargo build --release;sudo cp target/release/findomain /usr/bin/

echo "DONE"
