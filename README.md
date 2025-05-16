# Q2Pro Docker Server

This repository contains a Dockerized Quake 2 server using the q2pro client/server implementation, along with an nginx web server for file hosting.

## Requirements

- Docker and Docker Compose
- `/volumes/baseq2` directory containing Quake 2 base game files
- `/volumes/ctf` directory containing Capture The Flag game files

## Components

1. **Q2Pro Server (q2server)**
   - Built from q2pro source code compiled for 32-bit
   - Runs as non-root user
   - Serves on UDP port 27910
   - Default configuration runs CTF game mode on q2ctf1 map

2. **Web Server (q2web)**
   - Nginx-based file server
   - Serves Quake 2 game files over HTTP port 80
   - Provides directory listing for file access

## Directory Structure

```
/
├── Dockerfile           # Q2Pro server build configuration
├── docker-compose.yml   # Container orchestration
├── nginx.conf           # Web server configuration
└── volumes/
    ├── baseq2/          # Base Quake 2 game files (required)
    └── ctf/             # CTF game mode files (required)
        └── lfirecfg/    # Special configuration directory
```

## Usage

Start the server:

```
docker-compose up -d
```

Stop the server:

```
docker-compose down
```

View q2server logs:

```
docker-compose logs -f q2server
```

## Configuration

Server configuration can be modified by:
- Editing the CMD line in Dockerfile
- Adding/modifying configuration files in the volumes directories
- Adjusting server.cfg in the appropriate game directory

The server runs with `sv_airaccelerate 1` by default.
