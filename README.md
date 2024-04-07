# Arcconf Prometheus Exporter

A simple wrapper around `arcconf`, the Adaptec HBA control software to expose metrics to [Prometheus](https://prometheus.io/).

## Running with docker

Copy the [example docker compose](./compose.yaml) and edit it to suit your needs, then `docker compose up -d`

You can then visit `<your_server_ip>:80/Metrics` to see if metrics are available.

## Metrics

- `temperature`: Temperature of the RAID controller in degrees Celsius 

## Limitations

Running the app in docker needs elevated privileges to access the HBAs.  
This means that the app is basically not sandboxed.  
However, the code is very simple and I trust that basically anyone can audit it.

## For maintainers - Building and publishing

```sh
git clone https://github.com/GeoffreyCoulaud/arcconf-prometheus-exporter.git
cd arcconf-prometheus-exporter
docker build -t YOUR_DOCKER_USERNAME/arcconf-prometheus-exporter:TAG .
docker push YOUR_DOCKER_USERNAME/arcconf-prometheus-exporter:TAG
```