#!/bin/bash

printf "\n  MAd3 WithL0vE  \n\n"

RED="\033[1;31m" 
RESET="\033[0m" 

TARGET=$1 
DOMAIN="$1_domain" 
INFO_PATH="$1_domain/info" 
SUBDOMAIN_PATH="$1_domain/subdomain" 
DIRECTORY_ENUM="$1_domain/directory_enum" 
GAU_PATH="$1_domain/gau_data"
SCREENSHOT="$1_domain/aqua_shot"

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
 
 if [ ! -d "$GAU_PATH" ];then 
mkdir $GAU_PATH 
fi

if [ !  -d "$SCREENSHOT" ];then 
mkdir $SCREENSHOT
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
nmap -sV -T3 -Pn -p3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080 $TARGET |  grep -E 'open|filtered|closed' > $INFO_PATH/nmap.txt 

printf "\n----- WHATWEB -----\n\n" 
echo -e "${RED} [+] Checking 4 Whatweb ... ${RESET}" 
whatweb $TARGET > $INFO_PATH/whatweb.txt 

printf "\n----- PUBLIC API SUBDOMAIN ENUMERATION-----\n\n"
echo -e "${RED} [+] Launching anubis... ${RESET}" 
curl https://jldc.me/anubis/subdomains/$TARGET | jq -r ".[]" >> $SUBDOMAIN_PATH/found_subdomain.txt 

echo -e "${RED} [+] Launching rapid... ${RESET}" 
curl -s "https://rapiddns.io/subdomain/$TARGET?full=1" | grep -oE "[\.a-zA-Z0-9-]+\.$TARGET" | sort -u  >> $SUBDOMAIN_PATH/found_subdomain.txt  

echo -e "${RED} [+] Launching crt.sh.. ${RESET}" 
 curl -s "https://crt.sh/?q=%25.$TARGET" | grep -oE "[\.a-zA-Z0-9-]+\.$TARGET" | sort -u >> $SUBDOMAIN_PATH/found_subdomain.txt  

printf "\n----- TOOLS SUBDOMAIN ENUMERATION -----\n\n" 
echo -e "${RED} [+] Launching findomain ... ${RESET}" 
findomain -t $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- DNSRECON -----\n\n" 
echo -e "${RED} [+] Launching dnsrecon ... ${RESET}" 
gobuster dns --wildcard -d $TARGET --wildcard -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt > $SUBDOMAIN_PATH/dns_subdomain.txt

printf "\n----- AMASS -----\n\n" 
echo -e "${RED} [+] Launching Amass ... ${RESET}" 
amass enum -d $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- SUBFINDER -----\n\n" 
echo -e "${RED} [+] Launching Subfinder ... ${RESET}" 
subfinder -silent -d $TARGET  >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- SUBLIST3R -----\n\n" 
echo -e "${RED} [+] Launching Sublist3r ... ${RESET}" 
sublist3r -d $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- ASSETFINDER -----\n\n" 
echo -e "${RED} [+] Launching Assetfinder... ${RESET}" 
assetfinder --subs-only $TARGET >> $SUBDOMAIN_PATH/found_subdomain.txt 

printf "\n----- FINALLY TIME TO PROBE ALIVE SUBDOMAIN -----\n\n" 
echo -e "${RED} [+] Checking What's Alive... ${RESET}" 
cat $SUBDOMAIN_PATH/found_subdomain.txt | sort -u | httpx-toolkit -mc 200,302,403 | tee -a $SUBDOMAIN_PATH/responsive.txt
cat $SUBDOMAIN_PATH/responsive.txt  | sed 's/\http\:\/\///g' |  sed 's/\https\:\/\///g' | sort -u | tee -a  $SUBDOMAIN_PATH/urllist.txt
echo  "Total of $(wc -l $SUBDOMAIN_PATH/urllist.txt | awk '{print $1}') live subdomains were found"

printf "\n----- TIME TO TAKE SCREENSHOTS OF ALL PROBE SUBDOMAIN -----\n\n" 
echo "Starting aquatone scan..."
cat $SUBDOMAIN_PATH/responsive.txt | aquatone -silent -out $SCREENSHOT 


printf "\n----- SCRAPE4SCRAPE -----\n\n" 
echo "Scraping wayback for data..."
cat $SUBDOMAIN_PATH/urllist.txt | gau > $GAU_PATH/gaus.txt
cat $GAU_PATH/gaus.txt | sort -u |  unfurl --unique keys > $GAU_PATH/paramlist.txt
[ -s   $GAU_PATH/paramlist.txt ] && echo "Wordlist saved to  $GAU_PATH/paramlist.txt"


cat $GAU_PATH/gaus.txt | sort -u | grep -P "\w+\.js(\?|$)" | sort -u  > $GAU_PATH/jsurls.txt
[ -s  $GAU_PATH/jsurls.txt ] && echo "JS Urls saved to   $GAU_PATH/jsurls.txt"

cat $GAU_PATH/gaus.txt | sort -u | grep -P "\w+\.php(\?|$)" | sort -u  > $GAU_PATH/phpurls.txt
[ -s   $GAU_PATH/phpurls.txt ] && echo "PHP Urls saved to  $GAU_PATH/phpurls.txt"

cat  $GAU_PATH/gaus.txt | sort -u | grep -P "\w+\.aspx(\?|$)" | sort -u  > $GAU_PATH/aspxurls.txt
[ -s  $GAU_PATH/aspxurls.txt ] && echo "ASPX Urls saved to  $GAU_PATH/aspxurls.txt"

cat  $GAU_PATH/gaus.txt | sort -u | grep -P "\w+\.jsp(\?|$)" | sort -u  >  $GAU_PATH/jspurls.txt
[ -s  $GAU_PATH/jsurls.txt ] && echo "JSP Urls saved to  $GAU_PATH/jspurls.txt"




printf "\n----- VULNERABILITY SCANNING-----\n\n" 
echo -e "${RED} [+] Running Nuclei Scanner... Let see what Info we could find.... ${RESET}" 
echo -e "${RED} [+] This may take some time... Make sure you take a break and have a coffee....${RESET}"
cat $SUBDOMAIN_PATH/urllist.txt | nuclei  > $INFO_PATH/nuclei.txt

#echo -e "${RED} [+] Running Nikto Scanner... Let see what Info we could find.... ${RESET}" 

#for i in "cat $SUBDOMAIN_PATH/responsive.txt";
#do 
#wapiti -u $i >> $INFO_PATH/wapiti.txt
done

#printf "\n----- DIRECTORY ENUM TIME -----\n\n" 
#echo -e "${RED} [+] Starting Directory Enumeration...... ${RESET}" 
#echo -e "${RED} [+]Doing FFUF subdomain enum...${RESET}" 
#echo -e "${RED} [+] This may take some time... Make sure you take a break and have a coffee....${RESET}" 

#cat $SUBDOMAIN_PATH/alive.txt | sed -e 's/^http:\/\///g' -e 's/^https:\/\///g' |  while read y;
#do

#dirsearch -u https://$y/FUZZ   -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-small.txt >> $DIRECTORY_ENUM/ffuf_enum.txt
#or 
#gobuster dir -u https://$y -w /usr/share/seclists/Discovery/Web-Content/common.txt >>  $DIRECTORY_ENUM/ffuf_enum.txt
#done 

echo -e "DONE"
exit
