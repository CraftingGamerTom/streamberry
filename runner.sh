#!/bin/bash

# Set variables
RTMP_URL="$1"           # URL for RTMP
RTMP_KEY="$2"           # KEY for RTMP
SOURCE="$3"             # UDP Source (see SAP ads)      

# Function to handle sleeping
# Sleep until next quarter day (6 hours or less if started as odd time)
# Monitor Service and shutdown if silent error occurs
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
		echo "ERROR: difference is less than zero!"
        exit 1
	elif [ $time_since_midnight -lt $quarterday ]; then 
		echo "before 6am"
		SLEEPTIME=$((quarterday - time_since_midnight))
	elif [ $time_since_midnight -lt $(($quarterday*2)) ]; then
		echo "between 6am and 12pm"
		SLEEPTIME=$((quarterday*2 - time_since_midnight))
	elif [ $time_since_midnight -lt $(($quarterday*3)) ]; then
		echo "between 12pm and 6pm"
		SLEEPTIME=$((quarterday*3 - time_since_midnight))
	elif [ $time_since_midnight -lt $(($quarterday*4)) ]; then
		echo "between 6pm and midnight"
		SLEEPTIME=$((quarterday*4 - time_since_midnight))
	else 
		echo "ERROR: time_since_midnight is greater than a day!"
        exit 1
	fi

	echo stream for "$((SLEEPTIME))" seconds
	NUMBER_OF_LOOPS=$((SLEEPTIME/60))

	for(( index=0; index<NUMBER_OF_LOOPS; index++ ))
	do
		if ps -p $((pid)) > /dev/null
		then

            # Time to sleep
			thisSleepCycleTime=60

			# Check if ffmpeg is stuck sleeping (will check twice)
			keepRunning="no"
			for(( indexTwo=0; indexTwo<2; indexTwo++ ))
			do
                COMPARE_TIME=2

				frameA=$(tail ${LOG_FILE} -n 1 | sed -nr 's/.*frame=(.*)fps.*/\1/p')
				sleep $COMPARE_TIME
				frameB=$(tail ${LOG_FILE} -n 1 | sed -nr 's/.*frame=(.*)fps.*/\1/p')
                echo "$(date +'%F %r') - Comparing Frames: $frameA -> $frameB"

                if [ "$frameA" = "$frameB" ]
                then
                    echo "$(date +'%F %r') - Stream is hanging. Killing ffmpeg"
					keepRunning="no"
                else 
                    echo "$(date +'%F %r') - Stream looks ok."
					keepRunning="yes" 
				    thisSleepCycleTime=$((thisSleepCycleTime-COMPARE_TIME))
					break
                fi
			done

			# If can keepRunning then sleep
			if [ "$keepRunning" = "yes" ]
			then
                # Sleep, check again later
				echo "[debug] sleeping "$thisSleepCycleTime" seconds"
				sleep $((thisSleepCycleTime))
				continue
			fi
		fi
		echo "[debug] stream has stopped. beginning shutdown."
		break   # Abandon the loop.
	done
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

# RUN FFMPEG
while true
do
    echo =====
    echo Starting Live Stream
    echo Time: "$(date +'%F %r')"
    echo =====

    # Set up log file
    LOG_FILE=./stream-logs/ffmpeg-$(date +'%F').log
    mkdir ./stream-logs/

    # Pause to ensure new stream is started
    # Youtube use 60 seconds, Twitch can be less
    echo Pausing for 20 seconds to ensure a new stream is created by service provider
    sleep 20

    # Run ffmpeg
    bash ./stream.sh $RTMP_URL $RTMP_KEY $SOURCE $LOG_FILE & pid=$!

    echo =====
    echo PID: "$((pid))"
    echo =====

    # wait from stream to start before running logical sleep
    sleep 15
    sleep_during_stream

    # End Stream
    echo =====
    echo Ending Live Stream
    echo Time: "$(date +'%F %r')"
    echo -----
    echo killing process..
    pkill ffmpeg
    sleep 8
    echo ..done!
    echo =====

done

exit 0






