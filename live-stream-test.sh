#!/bin/bash

# From https://github.com/alexellis/raspberrypi-youtube-streaming/blob/master/streaming/entry.sh
# Changed dev/zero to dev/video0

# Youtube broadcast with ffmpeg
# https://gist.githubusercontent.com/olasd/9841772/raw/12c78a9426af9102e7c3fe40652c96f3c793aa9d/stream_to_youtube.sh

# Another possibly useful startup command
#ffmpeg -f video4linux2 -r 15 -s 1280x720 -vcodec mjpeg -i /dev/video0 -g 40 -f flv "$YOUTUBE_URL/$KEY"

# Configure youtube with 720p resolution. The video is not scaled.
VBR="7000k"                                    # Bitrate de la vidéo en sortie
#RES="1920x1080"
RES="1280x720"
#RES="858x480"
FPS="60"                                       # FPS de la vidéo en sortie
QUAL="ultrafast"                                  # Preset de qualité FFMPEG
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"  # URL de base RTMP youtube

SOURCE="/dev/video0"              # UDP Source (see SAP ads)
#KEY="$1"                       # Key to the youtube event
KEY="XXXXXXXXXX"

# Function to handle sleeping
sleep_during_stream() {
	eval "$(date +'today=%F now=%s')"
	quarterday=$((21600))
	midnight=$(date -d "$today 0" +%s)
	difference=$((now - midnight))
	SLEEPTIME=$0

	echo "$((now - midnight))"

	if [ "$difference" -lt $((0)) ]; then
		echo ERROR: difference is less than zero!
	elif [ "$difference" -lt "$quarterday" ]; then 
		echo before 6am
		SLEEPTIME=$((quarterday - difference))
	elif [ "$difference" -lt $(("$quarterday"*2)) ]; then
		echo between 6am and 12pm
		SLEEPTIME=$((quarterday*2 - difference))
	elif [ "$difference" -lt $(("$quarterday"*3)) ]; then
		echo between 12pm and 6pm
		SLEEPTIME=$((quarterday*3 - difference))
	elif [ "$difference" -lt $(("$quarterday"*4)) ]; then
		echo between 6pm and midnight
		SLEEPTIME=$((quarterday*4 - difference))
	else 
		echo ERROR: difference is greater than a day!
	fi

#	echo sleeping "$((SLEEPTIME))"
#	sleep "$((SLEEPTIME))"
	
	echo sleeping 30
	sleep 30 #debug
}

# Ensure the stream key is set
if [ -z "$1" ]; then
	echo Stream Key was not passed in as an argument
	exit 1
fi

# Loop to start and stop the streaming events
while true
do
	echo =====
	echo Starting Live Stream
	echo Time: "$((now))"
	
	# Run ffmpeg
	ffmpeg \
	    -i "$SOURCE" \
	    -f lavfi -i anullsrc \
	    -vf "drawtext=fontfile=FreeSerif.ttf:fontcolor=white:text='%{localtime}:fontsize=16'[out]" \
	    -vcodec libx264 -pix_fmt yuv420p -s $RES -preset $QUAL -r $FPS -g $(($FPS * 2)) -b:v $VBR \
	    -acodec libmp3lame -ar 44100 -threads 1 -qscale 4 -b:a 64k -bufsize 256k \
	    -f flv "$YOUTUBE_URL/$KEY" &
	pid=$!

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
done
