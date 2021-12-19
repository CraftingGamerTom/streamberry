# streamberry
A dockerized way of streaming to youtube from a raspberry pi

### To Build
docker build -t streamberry:1.0.0 .
### To Run
docker run --device=/dev/video0 --env RTMP_LINK='rtmp://a.rtmp.youtube.com/live2' --env RTMP_KEY='xxxxx' --env CAMERA_LOCATION='/dev/video0' streamberry:1.0.0

You could also run with an env-file
docker run --device=/dev/video0 --env-file ./.env streamberry:1.0.0
