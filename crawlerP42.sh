#!/bin/bash


TARGET=$1

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: crawler4P2.sh target.com"
  exit 0
fi

if [ $# -lt 1 ]; then
   echo "Error: No target provided"
   echo "Usage: crawler4P2.sh target.com"
   exit 1
fi


curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$TARGET/url_list?limit=100&page=1" | jq -r '.url_list[].url'
