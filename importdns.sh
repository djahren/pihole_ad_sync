#!/bin/sh
DC1=192.168.1.2
DC2=192.168.1.3
# Healthchecks.io notification service. Set to 1 to use Healthchecks.io
HEALTHCHECKS=0
# Set to the URL of your healthchecks.io check
HEALTHCHECKS_URL=
ARECORD_FILE="/etc/pihole/custom.list"
CNAME_FILE="/etc/dnsmasq.d/05-pihole-custom-cname.conf"

if [ $HEALTHCHECKS -eq 1 ]; then
  curl -fsS -m 10 --retry 5 -o /dev/null $HEALTHCHECKS_URL/start
fi

#Overwriting the custom.list file with imported Windows DNS entries
curl "http://"$DC1"/lists/custom.txt" -o $ARECORD_FILE || curl "http://"$DC2"/lists/custom.txt" -o $ARECORD_FILE
curl "http://"$DC1"/lists/cname.txt" -o $CNAME_FILE || curl "http://"$DC2"/lists/cname.txt" -o $CNAME_FILE

#Restart the Pihole DNS service
pihole restartdns

if [ $HEALTHCHECKS -eq 1 ]; then
  curl -fsS -m 10 --retry 5 -o /dev/null $HEALTHCHECKS_URL/$?
fi