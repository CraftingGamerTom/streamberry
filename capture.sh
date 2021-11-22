# CONFIG
RTMP_URL="$1"           # URL for RTMP
RTMP_KEY="$2"           # KEY for RTMP
SOURCE="$3"             # UDP Source (see SAP ads)         

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
