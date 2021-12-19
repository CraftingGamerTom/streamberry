# Pull Debian
FROM debian:buster-slim

# Labels
LABEL Maintainer="CraftingGamerTom"

# Install Dependencies
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install ffmpeg

# Set Up Directory
WORKDIR /usr/app/src
COPY .env ./
COPY capture.sh ./

# Run Program
CMD sh ./capture.sh ${RTMP_LINK} ${RTMP_KEY} ${CAMERA_LOCATION}