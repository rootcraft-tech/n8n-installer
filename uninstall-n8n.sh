#!/bin/bash

# n8n Ubuntu Uninstaller v2.2
# Complete removal script for n8n installation
# Author: AI-Generated Script
# License: MIT

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (use sudo)"
fi

# Check for --auto flag
AUTO_MODE=false
if [[ "$1" == "--auto" ]]; then
    AUTO_MODE=true
    log "Running in automatic mode..."
else
    warn "This will completely remove n8n and all associated data!"
    warn "This action cannot be undone!"
    echo
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Uninstallation cancelled."
        exit 0
    fi
fi

log "Starting n8n removal..."

# Stop and disable n8n service
log "Stopping n8n service..."
if systemctl is-active --quiet n8n 2>/dev/null; then
    systemctl stop n8n
fi

if systemctl is-enabled --quiet n8n 2>/dev/null; then
    systemctl disable n8n
fi

# Remove systemd service file
log "Removing systemd service file..."
if [[ -f /etc/systemd/system/n8n.service ]]; then
    rm -f /etc/systemd/system/n8n.service
    systemctl daemon-reload
fi

# Remove nginx configuration
log "Removing nginx configuration..."
if [[ -f /etc/nginx/sites-enabled/n8n ]]; then
    rm -f /etc/nginx/sites-enabled/n8n
fi

if [[ -f /etc/nginx/sites-available/n8n ]]; then
    rm -f /etc/nginx/sites-available/n8n
fi

# Test and reload nginx if it's running
if systemctl is-active --quiet nginx 2>/dev/null; then
    if nginx -t 2>/dev/null; then
        systemctl reload nginx
        log "nginx configuration reloaded"
    else
        warn "nginx configuration test failed, but continuing..."
    fi
fi

# Ask about SSL certificates
if [[ -d /etc/letsencrypt ]]; then
    if [[ "$AUTO_MODE" == "false" ]]; then
        echo
        read -p "Remove SSL certificates? This will affect other sites if they share certificates. (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            REMOVE_SSL=true
        else
            REMOVE_SSL=false
        fi
    else
        REMOVE_SSL=false
        log "Keeping SSL certificates in auto mode"
    fi

    if [[ "$REMOVE_SSL" == "true" ]]; then
        log "Removing SSL certificates..."
        certbot delete --cert-name $(ls /etc/letsencrypt/live/ | head -n1) --non-interactive 2>/dev/null || warn "Could not remove SSL certificates"
    fi
fi

# Ask about user data
if [[ "$AUTO_MODE" == "false" ]]; then
    echo
    read -p "Remove n8n user and all data? This will delete all workflows and settings. (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        REMOVE_USER=true
    else
        REMOVE_USER=false
    fi
else
    REMOVE_USER=false
    log "Keeping n8n user and data in auto mode"
fi

if [[ "$REMOVE_USER" == "true" ]]; then
    log "Removing n8n user and data..."
    if id -u n8n > /dev/null 2>&1; then
        # Stop any processes running as n8n user
        pkill -u n8n || true
        sleep 2

        # Remove user and home directory
        userdel -r n8n 2>/dev/null || warn "Could not remove n8n user completely"
    fi

    # Remove global n8n installation
    log "Removing global n8n installation..."
    npm uninstall -g n8n 2>/dev/null || warn "Could not uninstall n8n globally"
else
    log "Keeping n8n user and data"
    warn "To complete removal later, run: sudo userdel -r n8n"
fi

# Ask about Node.js
if [[ "$AUTO_MODE" == "false" ]]; then
    echo
    read -p "Remove Node.js? This may affect other applications. (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        REMOVE_NODE=true
    else
        REMOVE_NODE=false
    fi
else
    REMOVE_NODE=false
    log "Keeping Node.js in auto mode"
fi

if [[ "$REMOVE_NODE" == "true" ]]; then
    log "Removing Node.js..."
    apt remove --purge -y nodejs npm
    rm -f /etc/apt/sources.list.d/nodesource.list
    rm -f /etc/apt/keyrings/nodesource.gpg
fi

# Remove firewall rules
log "Removing firewall rules..."
if ufw status | grep -q "5678"; then
    ufw delete allow 5678
fi

# Clean up any remaining files
log "Cleaning up remaining files..."
rm -rf /tmp/n8n* 2>/dev/null || true

log "✅ n8n removal completed!"

if [[ "$REMOVE_USER" == "false" ]]; then
    warn "n8n user and data were preserved"
    warn "User data location: /home/n8n/"
fi

if [[ "$REMOVE_NODE" == "false" ]]; then
    warn "Node.js was preserved (may be used by other applications)"
fi

log "Uninstallation completed! 🗑️"
