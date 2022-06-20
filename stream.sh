
RTMP_URL="$1"           # URL for RTMP
RTMP_KEY="$2"           # KEY for RTMP
SOURCE="$3"             # UDP Source (see SAP ads)      
LOG_FILE=$4

ffmpeg \
	-nostdin \
	-loglevel error -stats \
	-f s16le -ac 2 -i /dev/zero \
	-f v4l2 -input_format yuyv422 -s 800x600 -i "$SOURCE" \
	-vf "drawtext=fontfile=FreeSerif.ttf:fontcolor=white@0.8:x=10:y=10:text='%{localtime}:fontsize=24'[out]" \
	-codec:v h264 -b:v 3500 -maxrate 5000 -bufsize 2500 \
	-tune zerolatency -preset ultrafast -qp 18 -g 25 \
	-codec:a aac -shortest -ac 2 -ar 22050 -ab 64k \
	-f flv "$RTMP_URL/$RTMP_KEY" \
	2> $LOG_FILE