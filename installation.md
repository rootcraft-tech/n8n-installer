# Installation Guide

Complete installation guide for n8n Ubuntu Installer Scripts.

## Prerequisites

Before installing n8n, ensure your system meets these requirements:

### System Requirements
- **Operating System:** Ubuntu 22.04 LTS
- **Memory:** Minimum 1GB RAM (2GB+ recommended)
- **Storage:** At least 2GB free space
- **Network:** Internet connection for downloading packages
- **Permissions:** sudo/root access

### Domain Requirements (HTTPS only)
- Valid domain name pointing to your server
- DNS propagation completed
- Email address for SSL certificate registration

## Installation Methods

### Method 1: Quick HTTPS Installation (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/n8n-installer/main/install-n8n.sh | sudo bash
```

This method:
- ✅ Installs Node.js 20 LTS
- ✅ Installs latest n8n version
- ✅ Configures nginx reverse proxy
- ✅ Obtains SSL certificates automatically
- ✅ Sets up systemd service
- ✅ Configures firewall rules

### Method 2: Development Installation (HTTP)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/n8n-installer/main/simple-install.sh | sudo bash
```

This method:
- ✅ Quick setup for development/testing
- ✅ HTTP access on port 5678
- ⚠️ No SSL encryption
- ⚠️ Not recommended for production

### Method 3: Manual Installation

1. **Download scripts:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/n8n-installer.git
   cd n8n-installer
   ```

2. **Check system requirements:**
   ```bash
   bash check-requirements.sh
   ```

3. **Run installation:**
   ```bash
   chmod +x install-n8n.sh
   sudo ./install-n8n.sh
   ```

## Post-Installation Steps

### 1. Verify Installation

Check if services are running:
```bash
sudo systemctl status n8n
sudo systemctl status nginx
```

### 2. Access n8n

- **HTTPS:** https://yourdomain.com
- **HTTP:** http://your-server-ip:5678

### 3. First-Time Setup

1. Open your n8n URL in a browser
2. Create your admin account
3. Complete the initial setup wizard

### 4. Configure Firewall (if needed)

The installer automatically configures UFW, but you can verify:
```bash
sudo ufw status
```

## Configuration Files

### n8n Configuration
- **Service file:** `/etc/systemd/system/n8n.service`
- **Working directory:** `/home/n8n/`
- **Data directory:** `/home/n8n/.n8n/`

### nginx Configuration
- **Main config:** `/etc/nginx/sites-available/n8n`
- **Symlink:** `/etc/nginx/sites-enabled/n8n`
- **SSL certificates:** `/etc/letsencrypt/live/yourdomain.com/`

## Troubleshooting

### Common Issues

1. **Port 80/443 already in use:**
   ```bash
   sudo netstat -tlnp | grep :80
   sudo netstat -tlnp | grep :443
   ```

2. **Domain not resolving:**
   ```bash
   dig +short yourdomain.com
   nslookup yourdomain.com
   ```

3. **SSL certificate issues:**
   ```bash
   sudo certbot certificates
   sudo nginx -t
   ```

### Log Locations

- **n8n logs:** `sudo journalctl -u n8n -f`
- **nginx logs:** `/var/log/nginx/`
- **certbot logs:** `/var/log/letsencrypt/`

## Advanced Configuration

### Custom Domain Setup

```bash
sudo ./install-n8n.sh --domain custom.domain.com --email admin@domain.com
```

### Environment Variables

Edit the systemd service to add environment variables:
```bash
sudo systemctl edit n8n
```

Add configuration:
```ini
[Service]
Environment="N8N_BASIC_AUTH_ACTIVE=true"
Environment="N8N_BASIC_AUTH_USER=admin"
Environment="N8N_BASIC_AUTH_PASSWORD=secure_password"
```

### Database Configuration

For production use, consider PostgreSQL:
```bash
# Install PostgreSQL
sudo apt install postgresql postgresql-contrib

# Create database and user
sudo -u postgres createdb n8n
sudo -u postgres createuser n8n_user

# Update n8n configuration
sudo systemctl edit n8n
```

Add database configuration:
```ini
[Service]
Environment="DB_TYPE=postgresdb"
Environment="DB_POSTGRESDB_HOST=localhost"
Environment="DB_POSTGRESDB_DATABASE=n8n"
Environment="DB_POSTGRESDB_USER=n8n_user"
Environment="DB_POSTGRESDB_PASSWORD=your_password"
```

## Security Considerations

### SSL/TLS Configuration
- Certificates auto-renew via cron job
- Strong SSL ciphers configured in nginx
- HSTS headers enabled

### Firewall Rules
- Only ports 22, 80, 443 open by default
- UFW configured automatically
- Additional rules can be added as needed

### Access Control
- Consider enabling n8n basic auth for additional security
- Use strong passwords
- Regularly update the system and n8n

## Backup and Maintenance

### Backup n8n Data
```bash
# Backup n8n data directory
sudo tar -czf n8n-backup-$(date +%Y%m%d).tar.gz /home/n8n/.n8n/

# Backup database (if using PostgreSQL)
sudo -u postgres pg_dump n8n > n8n-db-backup-$(date +%Y%m%d).sql
```

### Regular Maintenance
```bash
# Update system packages
sudo apt update && sudo apt upgrade

# Update n8n
sudo systemctl stop n8n
sudo -u n8n npm install -g n8n@latest
sudo systemctl start n8n

# Renew SSL certificates (automatic, but can be done manually)
sudo certbot renew
```

For more help, see [Troubleshooting Guide](troubleshooting.md).
