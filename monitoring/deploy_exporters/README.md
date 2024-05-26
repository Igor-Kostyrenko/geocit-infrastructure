# Ansible Role: Metric Exporters Setup

This Ansible role is designed to deploy two key metric exporters, cAdvisor and Node Exporter, using Docker and Docker Compose. It ensures Docker is installed, configures Docker Compose, and deploys both containers to gather system and container metrics efficiently.

## Requirements

- Linux host (Ubuntu, CentOS, Debian, etc.)
- Ansible 2.9 or higher

## Role Variables

The main variables for this role are listed below (see `defaults/main.yml` for default values):

## Installation Steps
- Install Docker: Ensures Docker is present on the system.
- Install Docker Compose: Deploys Docker Compose using the specified version.
- Deploy Exporters: Utilizes Docker Compose to start the cAdvisor and Node Exporter containers.

Container Details
- cAdvisor (Container Advisor): Monitors container performance and resource usage.
- Node Exporter: Provides system and hardware metrics suitable for monitoring.

### The configuration and deployment are managed through the docker-compose.yml file located at *files/docker-compose.yml*.

