#!/bin/bash

# Changes:
#	08.03.2015 - tested with Raspberry Pi 2 Model B
#
# Simple Bash script for monitoring the Temperature of a Raspberry Pi.
# Notice that the "calculations" for the colors is only Integer.
# ≤40°C is cold, 41-50°C is warm, 51-70°C is hot and all greater than 70°C is "melting".
# The values can be changed here:
#
cold=40
warm=50
hot=70

if ! /opt/vc/bin/vcgencmd measure_temp > /dev/null 2>&1
then
	echo -e \
"There are some issues with the installed firmware or software.
Try a update of your OS (i.e debian: apt-get update && apt-get upgrade -y)
and your firmware (i.e with rpi-update from Hexxeh: https://github.com/Hexxeh/rpi-update)
and make a restart."
exit 1
fi


settemp(){
	cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
	cpuTemp1=$(($cpuTemp0/1000))
	cpuTemp2=$(($cpuTemp0/100))
	cpuTempM=$(($cpuTemp2 % $cpuTemp1))
	cpuTempFloat="$cpuTemp1.$cpuTempM"
	gpuTemp0=$(/opt/vc/bin/vcgencmd measure_temp)
	gpuTempFloat=${gpuTemp0:5:4}
	cpuTempInt=${cpuTempFloat:0:2}
	gpuTempInt=${gpuTempFloat:0:2}
}

# cpu temperature
cputemp(){
	if [ "$cpuTempInt" -le "$cold" ] ; then
		echo -e "CPU Temp: \e[34m$cpuTempFloat\e[0m°C"
	elif [ "$cpuTempInt" -le "$warm" ] ; then
		echo -e "CPU Temp: \e[32m$cpuTempFloat\e[0m°C"
	elif [ "$cpuTempInt" -le "$hot" ] ; then
		echo -e "CPU Temp: \e[33m$cpuTempFloat\e[0m°C"
	else
		echo -e "CPU Temp: \e[31m$cpuTempFloat\e[0m°C"
	fi
}

# gpu temperature
gputemp(){
	if [ "$gpuTempInt" -le "$cold" ] ; then
		echo -e "GPU Temp: \e[34m$gpuTempFloat\e[0m°C"
	elif [ "$gpuTempInt" -le "$warm" ] ; then
		echo -e "GPU Temp: \e[32m$gpuTempFloat\e[0m°C"
	elif [ "$gpuTempInt" -le "$hot" ] ; then
		echo -e "GPU Temp: \e[33m$gpuTempFloat\e[0m°C"
	else
		echo -e "GPU Temp: \e[31m$gpuTempFloat\e[0m°C"
	fi
}

case $1 in
	-f|--follow)
		echo -e "Interrupt with CTRL+C\n"
		echo "-----------------"
		while true ; do
			settemp
			cputemp
			gputemp
			echo "-----------------"
			sleep 3
		done
	;;

	--hint)
		echo -e "\n"
		echo "Interesting fact:"
		echo -e "\tRun raspitemp with the parameter -f and press your thumb on the CPU."
		echo -e "\tAs you will see, the CPU transfers some thermal energy to your thumb and cools down."
		echo -e "\n"
	;;

	*)
		settemp
		cputemp
		gputemp
	;;
esac

exit 0
# EOF

