# 🚀 n8n Installation Scripts

**Languages:** [English](README.md) | [Russian](README.ru.md)

Automated installation scripts for n8n workflow automation platform on Ubuntu 22.04 with SSL support

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu 22.04](https://img.shields.io/badge/Ubuntu-22.04%20LTS-orange.svg)](https://ubuntu.com/)
[![n8n Latest](https://img.shields.io/badge/n8n-Latest-blue.svg)](https://n8n.io/)

## 🚀 Quick Installation

⚡ **Recommended:** Tested and optimized for VPS servers [MyHosti.pro](https://myhosti.pro/services/vds) (MVK plans)

### System Requirements Check
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/check-requirements.sh | bash
```

### Production Installation (with SSL)
```bash
sudo -E DOMAIN="yourdomain.com" EMAIL="your@email.com" bash -c 'curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/install-n8n.sh | bash'
```

### Development Installation (HTTP only)
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/simple-install.sh | sudo bash
```

### Complete n8n Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/uninstall-n8n.sh | sudo bash -s -- --auto
```
## 🌐 Access Points

**After HTTPS installation (install-n8n.sh):**
- 🌍 Public access: `https://yourdomain.com` (port 443)
- 🔒 Internal service: `localhost:5678` (accessible only on the server)

**After HTTP installation (simple-install.sh):**  
- 🌍 Direct access: `http://server-ip:5678`
- 📝 Example: `http://n8n.tech:5678`

## 📋 What's Included

| Script | Version | Purpose | Status |
|--------|---------|------------|---------|
| `install-n8n.sh` | v2.4 | 🔒 Full HTTPS setup with nginx proxy | ✅ Tested |
| `simple-install.sh` | v1.0 | ⚡ Quick HTTP installation | ✅ Tested |
| `uninstall-n8n.sh` | v2.2 | 🗑️ Complete removal with --auto mode | ✅ Tested |
| `check-requirements.sh` | v1.0 | 🔍 System requirements check | ✅ Tested |

## ✨ Features

- **🔒 HTTPS Ready** - Automatic SSL certificates via Let's Encrypt
- **⚡ One-Click Install** - Complete automation without configuration
- **🛡️ Security First** - nginx proxy with security headers
- **🔧 Easy Management** - systemd service with auto-startup
- **🗑️ Clean Removal** - Complete uninstallation option
- **✅ Pre-Check** - System requirements verification

## 📖 Installation Guide

### Step 1: Requirements Check
```bash
# Download and run system check
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/check-requirements.sh | bash
```

**Requirements:**
- **OS:** Ubuntu 22.04 LTS
- **RAM:** Minimum 1 GB, recommended 2+ GB
- **CPU:** Any modern processor (2+ cores recommended)
- **Disk:** Minimum 4 GB SSD, recommended 40+ GB
- **Privileges:** sudo privileges
- **Domain:** DNS pointing to your server (HTTPS only)

### Step 2: DNS Setup
Configure DNS records with your domain registrar or DNS provider:

**Add A records:**
- `yourdomain.com` → `YOUR_SERVER_IP`
- `www.yourdomain.com` → `YOUR_SERVER_IP` (optional)

**Where to configure:**
- At your **domain registrar** (where you bought the domain)
- Or at your **DNS provider** (if using external DNS)

**Check DNS propagation:**
```bash
# Check that domain points to your server
dig +short yourdomain.com

# Should return your server's IP
```
### Step 3: Installation

### Production installation (with SSL) - script will prompt for domain and email
```bash
sudo -E DOMAIN="yourdomain.com" EMAIL="your@email.com" bash -c 'curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/install-n8n.sh | bash'
```

### Development installation (HTTP only)
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer/main/simple-install.sh | sudo bash
```

## 🛠️ What Gets Installed

- **Node.js 20** - Latest LTS version via NodeSource
- **n8n** - Latest stable release via npm
- **nginx** - Web server and reverse proxy
- **certbot** - SSL certificate management
- **systemd service** - Process management and auto-startup

## 🛡️ Security Features

- **SSL/TLS encryption** with automatic renewal
- **Security headers** (HSTS, X-Frame-Options, etc.)
- **Firewall configuration** (ufw rules)
- **Service isolation** (dedicated user account)
- **File permission hardening**

## 🚨 Troubleshooting

### Common Issues

**DNS Problems:**
```bash
# Check DNS resolution
dig +short yourdomain.com
nslookup yourdomain.com

# Restart nginx
sudo systemctl restart nginx
```

**SSL Certificate Issues:**
```bash
# Manual certificate renewal
sudo certbot renew --dry-run
sudo certbot certificates

# Check nginx configuration
sudo nginx -t
```

**Service Issues:**
```bash
# Check n8n service status
sudo systemctl status n8n
sudo journalctl -u n8n -f

# Restart services
sudo systemctl restart n8n nginx
```

### Log Locations
- **n8n logs:** `sudo journalctl -u n8n -f`
- **nginx logs:** `/var/log/nginx/`
- **certbot logs:** `/var/log/letsencrypt/`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If this project helped you, please give it a ⭐ on GitHub!

## 🔗 Links

- [Official n8n Documentation](https://docs.n8n.io/)
- [Ubuntu 22.04 LTS](https://ubuntu.com/download/server)
- [Let's Encrypt](https://letsencrypt.org/)
- [MyHost.pro](https://myhosti.pro/services/auction) - Recommended hosting

---
