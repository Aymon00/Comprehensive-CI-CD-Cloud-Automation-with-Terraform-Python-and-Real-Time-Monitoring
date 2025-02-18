#!/bin/bash

# Update the system first
sudo yum update -y

# Install Docker
sudo yum install -y docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
docker --version

# Install Prometheus
mkdir ~/prometheus
cd ~/prometheus

# Create Prometheus configuration file
cat <<EOL > prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOL

# Run Prometheus using Docker
docker run --restart always -p 9090:9090 -v ~/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

# Install Grafana
docker run --restart always -d -p 3000:3000 grafana/grafana

# Install Datadog Agent
sudo docker run -d \
  --name datadog-agent \
  -e DD_API_KEY=YOUR_DATADOG_API_KEY \
  -e DD_SITE=datadoghq.com \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  datadog/agent:latest

# Confirm containers are running
docker ps
