#!/usr/bin/bash
# Identify vendors by MAC-Address

MAC=$(echo $1 | sed 's/:/-/g' | cut -b -8)
VENDOR=$(grep -i $MAC ~/Code/Data/mac_addresses.txt | cut -b 19-)
echo "MAC: $1"
echo "VENDOR: $VENDOR"
