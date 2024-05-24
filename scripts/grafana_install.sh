#!/bin/bash

# Add Grafana APT repository
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Add GPG key for the Grafana repository
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Update the package list
sudo apt-get update

# Install Grafana
sudo apt-get install -y grafana

# Start Grafana service
sudo systemctl start grafana-server

# Enable Grafana to start on boot
sudo systemctl enable grafana-server

# Display information about Grafana service status
sudo systemctl status grafana-server
