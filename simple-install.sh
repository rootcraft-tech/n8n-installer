#!/bin/bash

# n8n Simple Installer
# Quick HTTP installation for development/testing
# Author: AI-Generated Script
# License: MIT

set -e

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
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

log "Starting n8n simple installation (HTTP only)..."

# Update system
log "Updating system packages..."
apt update && apt upgrade -y

# Install Node.js 20
log "Installing Node.js 20 LTS..."
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt update
apt install -y nodejs

# Install UFW if not present
apt install -y ufw

# Create n8n user
log "Creating n8n user..."
if ! id -u n8n > /dev/null 2>&1; then
    useradd --system --create-home --shell /bin/bash n8n
fi

# Install n8n
log "Installing n8n..."
sudo -u n8n npm install -g n8n@latest

# Create systemd service
log "Creating systemd service..."
cat > /etc/systemd/system/n8n.service << EOF
[Unit]
Description=n8n workflow automation tool
After=network.target

[Service]
Type=simple
User=n8n
Group=n8n
WorkingDirectory=/home/n8n
ExecStart=/usr/bin/npx n8n start
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=N8N_PORT=5678
Environment=N8N_HOST=0.0.0.0

[Install]
WantedBy=multi-user.target
EOF

# Configure firewall
log "Configuring firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 5678
ufw --force enable

# Start service
log "Starting n8n service..."
systemctl daemon-reload
systemctl enable n8n
systemctl start n8n

# Wait for service to start
sleep 5

if systemctl is-active --quiet n8n; then
    SERVER_IP=$(hostname -I | awk '{print $1}')
    log "✅ Installation completed successfully!"
    log "✅ n8n is accessible at: http://$SERVER_IP:5678"
    log "✅ Service status: $(systemctl is-active n8n)"
    warn "⚠️  This is an HTTP-only installation - not recommended for production!"
    warn "⚠️  For HTTPS setup, use install-n8n.sh instead"
else
    error "n8n service failed to start. Check logs with: journalctl -u n8n"
fi

log "Simple installation completed! 🎉"
