# docker-q2pro

A complete Dockerized Quake 2 CTF server setup using Q2PRO with integrated web server for file downloads.

## Overview

This repository provides a fully configured Docker Compose environment for running a Quake 2 server with the following components:

1. **q2server**: A dedicated Q2PRO server optimized for CTF gameplay
2. **q2web**: An Nginx web server for serving game files to clients

The server is built from source using the latest Q2PRO codebase, compiled for optimal performance on modern systems while maintaining compatibility with the classic Quake 2 experience.

## Features

- Complete Docker Compose setup for one-command deployment
- Q2PRO dedicated server compiled from source
- Nginx web server for map and content downloads
- Proper volume mapping for easy content management
- Built for CTF gameplay with pre-configured settings
- Non-root container for improved security

## Prerequisites

- Docker and Docker Compose installed on your system
- Quake 2 game files organized in the following directory structure:
  - `./volumes/baseq2/` - Contains the base Quake 2 game files (pak0.pak, etc.)
  - `./volumes/ctf/` - Contains Capture The Flag mod files
  - `./volumes/ctf/lfirecfg/` - CTF configuration files

## Quick Start

### Directory Structure

Before starting, ensure your directory structure matches this layout:

```
docker-q2pro/
├── docker-compose.yml  # The Docker Compose configuration
├── Dockerfile          # Server build instructions
├── nginx.conf          # Nginx web server configuration
└── volumes/
    ├── baseq2/         # Base Quake 2 files (pak0.pak, etc.)
    └── ctf/            # CTF mod files
        └── lfirecfg/   # CTF configuration files
```

### Starting the Server

To build and run the server:

```bash
# Build and start both the Q2PRO server and web server
docker-compose up -d

# View server logs
docker-compose logs -f q2server
```

### Connecting to the Server

Players can connect to your server using any compatible Quake 2 client:

1. Direct connection: `connect your-server-ip`
2. For missing content, players can download files from `http://your-server-ip/`

## Configuration

### Server Configuration

The Q2PRO server is configured to run CTF mode by default with the following settings:
- Game mode: CTF
- Startup map: q2ctf1
- Air acceleration: 1

To modify these settings, edit the CMD line in the Dockerfile and rebuild:

```bash
# After editing the Dockerfile
docker-compose down
docker-compose up -d --build
```

### Web Server Configuration

The Nginx server is configured to:
- Serve files from the volumes directory with directory listing enabled
- Provide appropriate MIME types for Quake 2 files
- Log access and errors

To modify the web server configuration, edit the `nginx.conf` file.

## Volume Structure

The Docker Compose setup uses the following volume mappings:

| Host Path | Container Path | Description |
|-----------|---------------|-------------|
| `./volumes/baseq2` | `/home/q2user/.q2pro/baseq2` | Base Quake 2 game files |
| `./volumes/ctf` | `/home/q2user/.q2pro/ctf` | CTF mod files |
| `./volumes/ctf/lfirecfg` | `/home/q2user/ctf/lfirecfg` | CTF configuration files |
| `./volumes` | `/usr/share/nginx/html` | Web server root directory |

## Managing the Server

### Viewing Logs

```bash
# View Q2PRO server logs in real-time
docker-compose logs -f q2server

# View web server logs in real-time
docker-compose logs -f q2web

# View only the last 100 lines of server logs
docker-compose logs --tail=100 q2server
```

### Restarting or Updating

```bash
# Restart both services
docker-compose restart

# Stop the services
docker-compose down

# Rebuild and restart (after making changes to Dockerfile)
docker-compose up -d --build
```

## Technical Details

### Q2PRO Server Build

The server is built from source with the following features:
- Built from the official Q2PRO GitHub repository
- Compiled for 32-bit for maximum compatibility
- Uses game-abi-hack for improved stability
- Runs as a non-root user (q2user) for security

### Nginx Web Server

The web server is configured to:
- Use Alpine Linux for a minimal footprint
- Provide proper MIME types for Quake 2 files
- Enable directory listing for easy file browsing

## Adding Custom Content

To add custom maps, models, or other content:

1. Place the files in the appropriate directory under `./volumes/`
2. Restart the server if necessary:
   ```bash
   docker-compose restart
   ```

## Common Issues

### Port Forwarding

For public servers, ensure UDP port 27910 and TCP port 80 are forwarded in your router or firewall.

### File Permissions

If you encounter permission issues:

```bash
# Fix permissions on the volumes directory
chmod -R 755 ./volumes
```

## License

- Q2PRO is released under GPLv2
- The Quake 2 game itself is owned by id Software
- You must own a legal copy of Quake 2 to use the game files

## References

- Q2PRO: https://github.com/skullernet/q2pro
- Docker: https://www.docker.com/
- Nginx: https://nginx.org/
