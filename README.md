# streamberry
A dockerized way of streaming to youtube from a raspberry pi


docker container build -t streamberry:0.0.1 .



docker run --env RTMP_LINK='rtmp://a.rtmp.youtube.com/live2' --env RTMP_KEY='xxxxxxxxxx' --env CAMERA_LOCATION='/dev/video0' streamberry:0.0.2

docker run streamberry:0.0.2 --env-file ./.env