# Pull Python
FROM python:latest

# Labels
LABEL Maintainer="CraftingGamerTom"

RUN apt update
RUN apt install ffmpeg -y

WORKDIR /usr/app/src
COPY .env ./
COPY main.py ./
COPY capture.sh ./

#CMD instruction should be used to run the software
#contained by your image, along with any arguments.

CMD [ "python", "./main.py"]