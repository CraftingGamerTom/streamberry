# Pull Python
FROM python:latest

# Labels
LABEL Maintainer="CraftingGamerTom"

WORKDIR /usr/app/src
COPY test.py ./

#CMD instruction should be used to run the software
#contained by your image, along with any arguments.

CMD [ "python", "./test.py"]