# streamberry
A dockerized way of streaming to youtube from a raspberry pi

### To Build
`docker build -t tcrokicki/streamberry:1.0.0 .`

### To Send to docker.io
`docker push tcrokicki/streamberry:1.0.0`

### To Run
`docker run --device=/dev/video0 --env RTMP_LINK='rtmp://a.rtmp.youtube.com/live2' --env RTMP_KEY='xxxxx' --env CAMERA_LOCATION='/dev/video0' tcrokicki/streamberry:1.0.0`

You could also run with an env-file
`docker run --device=/dev/video0 --env-file ./.env tcrokicki/streamberry:1.0.0`


### To Use Container
`docker-compose up -d`

### To Tear Container down
`docker-compose down`

### To view logs
`docker-compose logs -f -t`
or
`docker-compose logs container_name`
or
`docker logs -f --tail 100 container_name`

## TO RUN LOCALLY
./capture.sh rtmp://a.rtmp.youtube.com/live2 xxx-xxx /dev/video0