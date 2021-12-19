# streamberry
A dockerized way of streaming to youtube from a raspberry pi


docker build -t streamberry:0.0.1 .



docker run --device=/dev/video0 --env RTMP_LINK='rtmp://a.rtmp.youtube.com/live2' --env RTMP_KEY='xxxxx' --env CAMERA_LOCATION='/dev/video1' streamberry:0.0.4


docker run streamberry:0.0.2 --env-file ./.env