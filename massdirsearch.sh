#!/bin/bash
 
#adjust this to fix the path to list of domain or subdomain 
domain_wordlist="/path/to/sub_wordlist.txt"

cat $domain_wordlist | while read domain; do
#adjust gobuster wordlists option to suit your need 
gobuster dir -u $domain -w /usr/share/dirb/wordlists/common.txt >> outfile.txt

done
