#!/bin/bash

# Update the package list
sudo apt update

# Create a system group named 'prometheus'
sudo groupadd --system prometheus

# Create a system user named 'prometheus' with /sbin/nologin as the login shell,
# associated with the 'prometheus' group
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Create directories for Prometheus configuration and data
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Download Prometheus v2.43.0 release for Linux AMD64
wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz

# Extract the contents of the Prometheus tarball
tar xzf prometheus-*.tar.gz

# Move Prometheus binaries to /usr/local/bin
sudo mv prometheus-*/prometheus /usr/local/bin/
sudo mv prometheus-*/promtool /usr/local/bin/

# Move Prometheus configuration files to /etc/prometheus
sudo mv prometheus-*/consoles /etc/prometheus
sudo mv prometheus-*/console_libraries /etc/prometheus

# Set ownership of Prometheus directories to the prometheus user and group
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Clean up downloaded files
rm -rf prometheus-*.tar.gz prometheus-*/

# Create a basic Prometheus configuration file
cat <<EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Create a systemd service unit file for Prometheus
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to pick up the new service unit file
sudo systemctl daemon-reload

# Start Prometheus service and enable it to start on boot
sudo systemctl start prometheus
sudo systemctl enable prometheus
