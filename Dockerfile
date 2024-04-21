# TODO see if using a smaller base image is possible
FROM python:3-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Expose the host's arcconf binary
VOLUME /bin/arcconf

# Install python dependencies
WORKDIR /tmp/python-requirements
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Install app
WORKDIR /usr/src/app
COPY src .

CMD python main.py