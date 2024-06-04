# Ansible Role: Prometheus & Grafana Deployment

This Ansible role is aimed at setting up a monitoring solution by deploying Prometheus and Grafana inside Docker containers. This setup allows for robust monitoring and visualization of metrics across your systems.

## Requirements

- Host operating systems should be based on Linux.
- Ansible 2.9 or newer.


## Deployment Steps
- Docker Installation: Ensures Docker is installed on the target host.
- Docker Compose Setup: Installs Docker Compose to manage multi-container Docker applications.
- Containers Deployment: Deploys the Prometheus and Grafana containers using Docker Compose.

##Monitoring Components
- Prometheus: Collects and stores metrics as time series data.
- Grafana: Provides a powerful and elegant interface for visualizing the metrics collected by Prometheus.
