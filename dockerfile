# Pull Debian
FROM debian:buster-slim

# Labels
LABEL Maintainer="CraftingGamerTom"

# Install Dependencies
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install ffmpeg
RUN apt-get -y install procps

# Set Up Directory
WORKDIR /usr/app/src
COPY .env ./
COPY capture.sh ./

# Mark File as executable
RUN ["chmod", "+x", "./capture.sh"]

# Run Program
CMD ./capture.sh ${RTMP_LINK} ${RTMP_KEY} ${CAMERA_LOCATION}