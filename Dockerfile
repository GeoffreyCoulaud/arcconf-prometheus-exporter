# TODO see if using a smaller base image is possible
FROM python:3-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Known good archives : 
# v2_02_22404
# v4_01_24763
ARG ARCCONF_VERSION=v4_01_24763
ARG ARCCONF_BASE_URL=http://download.adaptec.com/raid/storage_manager
# Paths depend on the version
# v2_02_22404: linux_x64/cmdline/arcconf
# v4_01_24763: linux_64/arcconf
ARG ARCCONF_ARCHIVE_EXECUTABLE_PATH=linux_64/arcconf

# Install arcconf
RUN apt-get update && apt-get install -y unzip
WORKDIR /tmp/arcconf
RUN curl $ARCCONF_BASE_URL/arcconf_$ARCCONF_VERSION.zip -o arcconf.zip
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