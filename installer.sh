#!/bin/bash

LIST_OF_APPS="cargo amass dirsearch  sublist3r subfinder  assetfinder nuclei seclists httprobe aquatone dnsrecon httpx-toolkit"

if [[ "$(whoami)" != "root" ]]; then
echo "Only sudo user can run this script."
exit 1
fi

apt-get update &&  apt-get install -y  $LIST_OF_APPS
if [[ $? -ne 0 ]]; then
  echo "Failed to install required applications. Exiting script."
  exit 1
fi 

go install github.com/lc/gau/v2/cmd/gau@latest
if [[ $? -ne 0 ]]; then
  echo "Failed to install required applications. Exiting script."
  exit 1
fi
cp /root/go/bin/gau /usr/bin/

wget https://github.com/tomnomnom/unfurl/releases/download/v0.0.1/unfurl-linux-amd64-0.0.1.tgz
if [[ $? -ne 0 ]]; then
  echo "Failed to download unfurl. Exiting script."
  exit 1
fi
tar xzf unfurl-linux-amd64-0.0.1.tgz
if [[ $? -ne 0 ]]; then
  echo "Failed to download unfurl. Exiting script."
  exit 1
fi
sudo mv unfurl /usr/bin

wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
if [[ $? -ne 0 ]]; then
  echo "Failed to download unfurl. Exiting script."
  exit 1
fi
unzip aquatone_linux_amd64_1.7.0.zip
if [[ $? -ne 0 ]]; then
  echo "Failed to download unfurl. Exiting script."
  exit 1
fi
sudo mv aquatone /usr/bin

git clone https://github.com/Edu4rdSHL/findomain.git
if [[ $? -ne 0 ]]; then
  echo "Failed to download unfurl. Exiting script."
  exit 1
fi
cd findomain && cargo build --release
if [[ $? -ne 0 ]]; then
  echo "Failed to download unfurl. Exiting script."
  exit 1
fi
sudo cp target/release/findomain /usr/bin/


echo "DONE"

exit 0
