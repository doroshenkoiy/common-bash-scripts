#!/bin/sh

# Place file in /etc/update-motd.d
echo
echo "-------------------------------------<{ `date` }>---------------------------------------------"
echo "IP:\t\t `ip -4 a | egrep "inet\ "| grep -v "127.0.0.1" | sed 's/^.*inet.//; s/\/.*//'`"
echo "Hostname:\t  `uname -n`"
echo

echo "`lsb_release -d | sed s/^.*:.//` \t\t `uname -srvm`"

echo 
