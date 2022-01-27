#!/bin/bash

# Set variables
RTMP_URL="$1"           # URL for RTMP
RTMP_KEY="$2"           # KEY for RTMP
SOURCE="$3"             # UDP Source (see SAP ads)         

# Function to handle sleeping
sleep_during_stream() {
    declare -i quarterday=21600
    timenow=$(date +'%s')
    time_since_midnight=$(( ($timenow - 18000) % 86400 ))
    difference=$(($timenow - $time_since_midnight))
    SLEEPTIME=$0

    echo "Time now: $(date +'%F %r')"
	echo "Calculated timenow: $((timenow))"
	echo "Quarter day: $((quarterday))"
	echo "Calculated Time Since Midnight: $((time_since_midnight))"
	echo "Calculated Difference: $((difference))"

	if [ $time_since_midnight -lt $((0)) ]; then
		echo ERROR: difference is less than zero!
	elif [ $time_since_midnight -lt $quarterday ]; then 
		echo before 6am
		SLEEPTIME=$((quarterday - time_since_midnight))
	elif [ $time_since_midnight -lt $(($quarterday*2)) ]; then
		echo between 6am and 12pm
		SLEEPTIME=$((quarterday*2 - time_since_midnight))
	elif [ $time_since_midnight -lt $(($quarterday*3)) ]; then
		echo between 12pm and 6pm
		SLEEPTIME=$((quarterday*3 - time_since_midnight))
	elif [ $time_since_midnight -lt $(($quarterday*4)) ]; then
		echo between 6pm and midnight
		SLEEPTIME=$((quarterday*4 - time_since_midnight))
	else 
		echo ERROR: time_since_midnight is greater than a day!
	fi

	echo stream for "$((SLEEPTIME))" seconds

	NUMBER_OF_LOOPS=$((SLEEPTIME/60))

	for(( index=0; index<NUMBER_OF_LOOPS; index++ ))
	do
		if ps -p $((pid)) > /dev/null
		then
			echo [debug] sleeping 60 seconds
			sleep 60       	   # While good and, no disaster-condition.
			continue
		fi
		echo stream has stopped. beginning shutdown.
		break				   # Abandon the loop.
	done

	#sleep "$((SLEEPTIME))"
	#sleep 60 #debug
}

# Ensure the STREAM URL is set
if [ -z "$1" ]; then
	echo RTMP_URL was not passed in as an argument
	exit 1
fi
# Ensure the STREAM KEY is set
if [ -z "$2" ]; then
	echo RTMP_KEY was not passed in as an argument
	exit 1
fi
# Ensure the VIDEO CAMERA is set
if [ -z "$3" ]; then
	echo Camera SOURCE was not passed in as an argument
	exit 1
fi


echo =====
echo Starting Live Stream
echo Time: "$((now))"
echo =====
echo Pausing for 45 seconds to ensure youtube makes a new stream
sleep 45

# RUN FFMPEG
ffmpeg \
	-ar 22050 -ac 2 -acodec pcm_s16le \
	-f s16le -ac 2 -i /dev/zero \
	-f v4l2 -s 1280x720 -r 10 -i "$SOURCE" \
	-vf "drawtext=fontfile=FreeSerif.ttf:fontcolor=white@0.8:x=10:y=10:text='%{localtime}:fontsize=24'[out]" \
	-codec:v h264 -r 1 -g 4 -b:v 3500k -bufsize 2500k \
	-codec:a aac -ac 2 -ar 22050 -ab 64k \
	-f flv "$RTMP_URL/$RTMP_KEY" \
	& 
pid=$!

echo =====
echo PID: "$((pid))"
echo =====

# Sleep until next quarter day (6 hours or less if started as odd time)
sleep_during_stream

echo =====
echo Ending Live Stream
echo Time: "$((now))"
echo -----
echo killing process..
kill -TERM $pid
sleep 8
echo ..done!
echo =====
