#!/bin/sh

# Place file in /etc/update-motd.d
echo
echo --------------------------------------------------------------------------------
ip -4 a |grep "inet 10."|sed 's/^.*inet.//; s/\/.*//'
date
lsb_release -d | sed s/^.*:.//
uname -snrvm
echo 