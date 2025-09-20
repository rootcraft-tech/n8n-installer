#!/bin/bash

# n8n Ubuntu Installer v2.3.1
# Automated HTTPS installation script for n8n on Ubuntu 22.04 LTS
# Author: AI-Generated Script
# License: MIT

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
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

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (use sudo)"
fi

# Check Ubuntu version
if ! grep -q "Ubuntu 22.04" /etc/os-release; then
    warn "This script is designed for Ubuntu 22.04 LTS. Continuing anyway..."
fi

log "Starting n8n installation with HTTPS support..."

# Function to get domain and email
get_domain_info() {
    if [[ -z "$DOMAIN" ]]; then
        read -p "Enter your domain name (e.g., yourdomain.com): " DOMAIN
        if [[ -z "$DOMAIN" ]]; then
            error "Domain name is required for HTTPS installation"
        fi
    fi

    if [[ -z "$EMAIL" ]]; then
        read -p "Enter your email address for SSL certificate: " EMAIL
        if [[ -z "$EMAIL" ]]; then
            error "Email address is required for SSL certificate"
        fi
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --email)
            EMAIL="$2"
            shift 2
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Get domain and email if not provided
get_domain_info

log "Domain: $DOMAIN"
log "Email: $EMAIL"

# Verify DNS before continuing
info "Verifying DNS resolution for $DOMAIN..."
if ! nslookup $DOMAIN > /dev/null 2>&1; then
    warn "DNS resolution failed for $DOMAIN. Make sure your domain points to this server."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system
log "Updating system packages..."
apt update && apt upgrade -y

# Install required packages
log "Installing required packages..."
apt install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release nginx ufw

# Install Node.js 20 (required for n8n 1.97+)
log "Installing Node.js 20 LTS..."
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt update
apt install -y nodejs

# Verify Node.js installation
NODE_VERSION=$(node --version)
log "Node.js installed: $NODE_VERSION"

# Create n8n user
log "Creating n8n user..."
if ! id -u n8n > /dev/null 2>&1; then
    useradd --system --create-home --shell /bin/bash n8n
fi

# Install n8n globally
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
Environment=WEBHOOK_URL=https://$DOMAIN/
Environment=GENERIC_TIMEZONE=UTC
Environment=N8N_PORT=5678
Environment=N8N_PROTOCOL=http
Environment=N8N_HOST=localhost

[Install]
WantedBy=multi-user.target
EOF

# Configure nginx
log "Configuring nginx..."
cat > /etc/nginx/sites-available/n8n << EOF
server {
    listen 80;
    server_name $DOMAIN;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    # SSL configuration will be added by certbot

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

# Enable nginx site
ln -sf /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
nginx -t || error "nginx configuration test failed"

# Install certbot for Let's Encrypt
log "Installing certbot..."
apt install -y certbot python3-certbot-nginx

# Configure firewall
log "Configuring firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 'Nginx Full'
ufw --force enable

# Start and enable services
log "Starting services..."
systemctl daemon-reload
systemctl enable n8n
systemctl start n8n

# Wait for n8n to start
log "Waiting for n8n to start..."
sleep 10

# Check if n8n is running
if ! systemctl is-active --quiet n8n; then
    error "n8n service failed to start. Check logs with: journalctl -u n8n"
fi

systemctl enable nginx
systemctl restart nginx

# Obtain SSL certificate
log "Obtaining SSL certificate..."
if ! certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email $EMAIL --redirect; then
    warn "SSL certificate installation failed. You can try manually with: certbot --nginx -d $DOMAIN"
else
    log "SSL certificate obtained successfully!"
fi

# Final status check
log "Checking final status..."
if systemctl is-active --quiet n8n && systemctl is-active --quiet nginx; then
    log "✅ Installation completed successfully!"
    log "✅ n8n is running and accessible at: https://$DOMAIN"
    log "✅ Services status:"
    echo "   - n8n: $(systemctl is-active n8n)"
    echo "   - nginx: $(systemctl is-active nginx)"
    log "✅ You can now open https://$DOMAIN in your browser to set up n8n"
else
    error "Some services are not running properly. Please check the logs."
fi

log "Installation completed! 🎉"
