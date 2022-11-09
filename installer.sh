#!/bin/bash

LIST_OF_APPS="amass dirsearch figlet sublist3r subfinder cargo assetfinder nuclei seclists httprobe aquatone dnsrecon"

if [[ "$(whoami)" != root ]]; then
echo "Only sudo user can run this script."
exit 1
fi
echo "Press EnterKey to start installing the must-have pre-requisetes"
while read -r p 
do 
apt-get update && sudo apt-get install -y  $LIST_OF_APPS;
go install github.com/lc/gau/v2/cmd/gau@latest
git clone https://github.com/Edu4rdSHL/findomain.git;cd findomain && cargo build --release;sudo cp target/release/findomain /usr/bin/
wget https://github.com/tomnomnom/unfurl/releases/download/v0.0.1/unfurl-linux-amd64-0.0.1.tgz;tar xzf unfurl-linux-amd64-0.0.1.tgz;sudo mv unfurl /usr/bin 
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip;unzip aquatone_linux_amd64_1.7.0.zip;sudo mv aquatone /usr/bin
done 

echo "DONE"

exit 0
