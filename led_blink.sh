#!/bin/bash
#===============================================================================
#
#		FILE:			led_blink.py
#
#		USAGE:			./led_blink.py
#
#		DESCRIPTION:	Test script for checking three GPIO ports
#
#		OPTIONS:		---
#		REQUIREMENTS:	wiringPi
#						https://projects.drogon.net/raspberry-pi/wiringpi/download-and-install/
#		BUGS:			---
#		NOTES:			---
#		AUTHOR:			Robin Cerny (rc), robin@cerny.li
#		ORGANIZATION:		private
#		CREATED:		04.02.14 13:38:34
#		REVISION:		---
#		LICENCE:		GPLv3
#
#===============================================================================
# Script only for the Revision 2!
# Used Ports are:
# 0=GPIO 17|Phys 11
# 2=GPIO 27|Phys 13
# 3=GPIO 22|Phys 15

gpio mode 0 out
gpio mode 2 out
gpio mode 3 out

i=0
while [ "$i" -lt "5" ] ; do
	i=$((i+1))
	#echo $i
	gpio write 0 1
	sleep 0.1
	gpio write 2 1
	sleep 0.1
	gpio write 3 1
	sleep 0.3
	gpio write 3 0
	sleep 0.1
	gpio write 2 0
	sleep 0.1
	gpio write 0 0
	sleep 0.3
done

i=0
while [ "$i" -lt "10" ] ; do
	i=$((i+2))
	gpio write 0 1
	gpio write 2 1
	gpio write 3 1
	sleep 0.1
	gpio write 0 0
	gpio write 2 0
	gpio write 3 0
	sleep 0.1
done

i=0
while [ "$i" -lt "3" ] ; do
	i=$((i+2))
	sleep 0.2
	gpio write 2 1
	sleep 0.3
	gpio write 2 0
	sleep 0.3
	gpio write 0 1
	gpio write 3 1
	sleep 0.3
	gpio write 0 0
	gpio write 3 0
done

exit 0
# EOF
