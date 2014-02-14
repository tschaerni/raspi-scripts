#!/bin/bash

# Simple Bash script for monitoring the Temperature of a Raspberry Pi.
# Notice that the "calculations" for the colors is only Integer.
# ≤40°C is cold, 41-50°C is warm, 51-70°C is hot and all greater than 70°C is "melting".
# The values can be changed here:
cold=40
warm=50
hot=70

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
	else
		if [ "$cpuTempInt" -le "$warm" ] ; then
			echo -e "CPU Temp: \e[32m$cpuTempFloat\e[0m°C"
		else
			if [ "$cpuTempInt" -le "$hot" ] ; then
				echo -e "CPU Temp: \e[33m$cpuTempFloat\e[0m°C"
			else
				echo -e "CPU Temp: \e[31m$cpuTempFloat\e[0m°C"
			fi
		fi
	fi
}

# gpu temperature
gputemp(){
	if [ "$gpuTempInt" -le "$cold" ] ; then
		echo -e "GPU Temp: \e[34m$gpuTempFloat\e[0m°C"
	else
		if [ "$gpuTempInt" -le "$warm" ] ; then
			echo -e "GPU Temp: \e[32m$gpuTempFloat\e[0m°C"
		else
			if [ "$gpuTempInt" -le "$hot" ] ; then
				echo -e "GPU Temp: \e[33m$gpuTempFloat\e[0m°C"
			else
				echo -e "GPU Temp: \e[31m$gpuTempFloat\e[0m°C"
			fi
		fi
	fi
}

case $1 in
	-w|--repeat)
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

	*)
		settemp
		cputemp
		gputemp
	;;
esac

exit 0
# EOF

