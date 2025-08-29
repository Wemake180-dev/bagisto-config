# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based development environment for Bagisto, an open-source e-commerce platform built on Laravel. The setup provides a containerized environment with PHP 8.2, Apache, MySQL, and all necessary dependencies for Bagisto development.

## Architecture

The project uses Docker Compose to orchestrate two main services:

1. **bagisto-dev**: Ubuntu 22.04-based container with PHP 8.2, Apache, Composer, Node.js, and development tools
   - Exposes port 8080 for web access
   - Exposes port 2222 for SSH access
   - Mounts `./workspace` directory to `/var/www/html` for code persistence

2. **mysql_bagisto**: MySQL 8.0 database container
   - Database: bagisto
   - User: bagisto / Password: bagisto123
   - Root password: root123
   - Data persisted in `./mysql_data` directory

## Development Commands

### Container Management
```bash
# Start the development environment
docker-compose up -d

# Stop the environment
docker-compose down

# View container logs
docker-compose logs -f bagisto-dev

# Access the container shell
docker exec -it bagisto-config-bagisto-dev-1 bash

# SSH into container (after starting)
ssh -p 2222 root@localhost  # Password: bagisto
```

### Bagisto Setup (run inside container)
```bash
# Install Bagisto via Composer (if not already installed)
composer create-project bagisto/bagisto .

# Install dependencies for existing project
composer install
npm install

# Run database migrations
php artisan migrate

# Seed the database
php artisan db:seed

# Clear application cache
php artisan cache:clear
php artisan config:clear
php artisan view:clear

# Build frontend assets
npm run dev  # Development build
npm run build  # Production build
```

## Directory Structure

- `docker-compose.yaml`: Docker Compose configuration
- `Dockerfile`: Alternative standalone Docker image configuration
- `workspace/`: Mounted directory for Bagisto application code (created on first run)
- `mysql_data/`: MySQL data persistence directory (created on first run)

## Access Points

- **Web Application**: http://localhost:8080
- **SSH Access**: ssh -p 2222 root@localhost (password: bagisto)
- **MySQL Connection**:
  - Host: mysql_bagisto (from within containers)
  - Port: 3306
  - Database: bagisto
  - User: bagisto
  - Password: bagisto123

## Important Notes

- The Apache DocumentRoot is configured to `/var/www/html/public` as required by Laravel/Bagisto
- PHP memory limit is set to 512M and max execution time to 360 seconds for Bagisto requirements
- The environment includes both development tools (git, composer, npm) and runtime requirements
- SSH is enabled for direct container access during development