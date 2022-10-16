#!/bin/bash

figlet -l Enumerator

printf "\n-----ImprovedBy Uebercrack3r WithL0ve------\n\n" 

RED="\033[1;31m" 
RESET="\033[0m" 

TARGET=$1 
DOMAIN="domain" 
INFO_PATH="domain/info" 
SUBDOMAIN_PATH="domain/subdomain" 
DIRECTORY_ENUM="domain/directory_enum" 

if [ -z "$1" ] 
  then
    echo -e "${RED} [+] USAGE : ./enum.sh <target.com> ${RESET}" 
exit 1 
fi
 
if [ ! -d "$DOMAIN" ];then 
mkdir $DOMAIN 
fi
 
if [ ! -d "$INFO_PATH" ];then 
mkdir $INFO_PATH 
fi
 
if [ !  -d "$SUBDOMAIN_PATH" ];then 
mkdir $SUBDOMAIN_PATH 
fi 

if [ ! -d "$DIRECTORY_ENUM" ];then
        mkdir $DIRECTORY_ENUM 
fi
 
printf "\n----- WHOIS -----\n\n" 
echo -e "${RED} [+] Checking whois ... ${RESET}" 
whois $TARGET > $INFO_PATH/whois.txt 

printf "\n----- DIG -----\n\n" 
echo -e "${RED} [+] Dig @ Work ... ${RESET}" 
dig $TARGET > $INFO_PATH/dig.txt 

printf "\n----- NSLOOKUP -----\n\n" 
echo -e "${RED} [+] Nslookup @ It ... ${RESET}" 
nslookup $TARGET > $INFO_PATH/nslookup.txt 

printf "\n----- NMAP -----\n\n" 
echo -e "${RED} [+] Running Nmap ... ${RESET}" 
nmap -A -Pn $TARGET > $INFO_PATH/nmap.txt 

printf "\n----- WHATWEB -----\n\n" 
echo -e "${RED} [+] Checking 4 Whatweb ... ${RESET}" 
whatweb $TARGET > $INFO_PATH/whatweb.txt 

printf "\n----- FINDOMAIN -----\n\n" 
echo -e "${RED} [+] Launching findomain ... ${RESET}" 
findomain -t $TARGET > $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- AMASS -----\n\n" 
echo -e "${RED} [+] Launching Amass ... ${RESET}" 
amass enum -d $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- SUBFINDER -----\n\n" 
echo -e "${RED} [+] Launching Subfinder ... ${RESET}" 
subfinder -silent -d $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- SUBLIST3R -----\n\n" 
echo -e "${RED} [+] Launching Sublist3r ... ${RESET}" 
sublist3r -d $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- ASSETFINDER -----\n\n" 
echo -e "${RED} [+] Launching Assetfinder... ${RESET}" 
assetfinder -subs-only $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- TIME TO CHECK ALIVE SUBDOMAIN -----\n\n" 
echo -e "${RED} [+] Checking What's Alive... ${RESET}" 
cat $SUBDOMAIN_PATH/found_subdomain.txt | httpx-toolkit -silent -mc 200 > $SUBDOMAIN_PATH/alive.txt
cat $SUBDOMAIN_PATH/found_subdomain.txt | httpx-toolkit -silent -title -tech-detect -status-code > $SUBDOMAIN_PATH/techdete>


printf "\n----- DIRECTORY ENUM TIME -----\n\n" 
echo -e "${RED} [+] Starting Directory Enumeration...... ${RESET}" 
echo -e "${RED} [+]Doing FFUF subdomain enum...${RESET}" 
echo -e "${RED} [+] This may take some time... Make sure you take a break and have a coffee....${RESET}" 

cat $SUBDOMAIN_PATH/alive.txt | sed -e 's/^http:\/\///g' -e 's/^https:\/\///g' |  while read y;
do

ffuf -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-small.txt -u https://$y/FUZZ  > $DIRECTORY_ENUM/ffuf_enum.txt

done 

printf "\n----- VULNERABILITY SCANNING-----\n\n" 
echo -e "${RED} [+] Running Nuclei Scanner... Let see what Info we could find.... ${RESET}" 
cat $SUBDOMAIN_PATH/alive.txt | nuclei -silent > $INFO_PATH/nuclei.txt

echo -e "DONE"

