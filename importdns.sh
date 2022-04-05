#!/bin/sh

#Overwriting the custom.list file with imported Windows DNS entries
curl "http://192.168.1.205/lists/custom.txt" -o /tmp/dc1dns.list
curl "http://192.168.1.208/lists/custom.txt" -o /tmp/dc2dns.list
TARGET="/etc/pihole/custom.list"

if [ -s /tmp/dc1dns.list ]
then
  echo "DC1"
  cp /tmp/dc1dns.list $TARGET
else
  echo "DC2"
  cp /tmp/dc2dns.list $TARGET
fi

ls /tmp/*.list
rm /tmp/dc*.list

#Restart the Pihole DNS service
pihole restartdns