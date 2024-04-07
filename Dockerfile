# TODO see if using a smaller base image is possible
FROM python:3-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ARG ARCCONF_ARCHIVE_URL=http://download.adaptec.com/raid/storage_manager/arcconf_v4_01_24763.zip
ARG ARCCONF_ARCHIVE_EXECUTABLE_PATH=linux_64/arcconf

# Install arcconf
RUN apt-get update && apt-get install -y unzip
WORKDIR /tmp/arcconf
RUN curl $ARCCONF_ARCHIVE_URL -o arcconf.zip
RUN unzip -j arcconf.zip $ARCCONF_ARCHIVE_EXECUTABLE_PATH -d /bin
RUN chmod +x /bin/arcconf

# Install python dependencies
WORKDIR /tmp/python-requirements
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install app
WORKDIR /usr/src/app
COPY src .

CMD python main.py