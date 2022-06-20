# Commands that help me debug

### Run locally
Youtube
`~/Desktop/working/streamberry/capture.sh rtmp://a.rtmp.youtube.com/live2 xxxx-xxxx /dev/video-cam`
Twitch
`~/Desktop/working/streamberry/capture.sh rtmp://iad05.contribute.live-video.net/app XXXXXX /dev/video-cam`

### See System Activity
`sudo apt-get install htop`
`htop`

### Kill running process (when running local)
`sudo kill -9 PIDHERE`


### If running as a local service (which we dont anymore)
```
systemctl --type=service
sudo systemctl disable live-stream.service

```

### List available webcam resolutions
`v4l2-ctl --list-formats-ext`

**example output**
```
ioctl: VIDIOC_ENUM_FMT
        Index       : 0
        Type        : Video Capture
        Pixel Format: 'MJPG' (compressed)
        Name        : Motion-JPEG
                Size: Discrete 1280x720
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 352x288
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 176x144
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 160x120
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 800x600
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 960x720
                        Interval: Discrete 0.033s (30.000 fps)

        Index       : 1
        Type        : Video Capture
        Pixel Format: 'YUYV'
        Name        : YUYV 4:2:2
                Size: Discrete 1280x720
                        Interval: Discrete 0.100s (10.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 352x288
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 176x144
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 160x120
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 800x600
                        Interval: Discrete 0.050s (20.000 fps)
                Size: Discrete 960x720
                        Interval: Discrete 0.067s (15.000 fps)
```

**OR**
`ffmpeg -f video4linux2 -list_formats all -i /dev/video-cam`

**example output**
```
[video4linux2,v4l2 @ 0x1c6b570] Compressed:       mjpeg :          Motion-JPEG : 1280x720 640x480 352x288 320x240 176x144 160x120 800x600 960x720
[video4linux2,v4l2 @ 0x1c6b570] Raw       :     yuyv422 :           YUYV 4:2:2 : 1280x720 640x480 352x288 320x240 176x144 160x120 800x600 960x720
```

### Debug inside the container

```
docker ps

docker exec -it <CONTAINER_ID> /bin/bash

ps aux

tail -f /proc/<PID>/fd/0

tail -f /proc/15/status

grep -h 'State' /proc/15/status

grep -h 'State' /proc/15/status | grep -h 'running'
```

### Some resources
https://wiki.archlinux.org/title/Udev#Video_devices
https://gist.github.com/chrisstubbs93/f1ee6220dbb3e5a92398feed48ed6cb8