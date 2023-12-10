# Media Stack Helm Chart

## Introduction

This project provides a Helm chart for deploying a stack of commonly used media management services on Kubernetes.
The project can deploy:

- **Radarr**: Movie tracking & management
- **Sonarr**: TV tracking & management
- **Bazarr**: Subtitle management
- **Overseerr**: User interface for content requests

## Prerequisites

- Basic understanding of Kubernetes and Helm
- Kubernetes cluster
- Helm installed on your local machine
- A storage provider for configuration files
- An NFS server for media file storage

## Installation

```shell
helm install media-stack .
```

### Configuration

Stub
