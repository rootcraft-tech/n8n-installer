# 🚀 n8n Installer Scripts

**Languages:** [English](README.md) | [Русский](README.ru.md)

Automated installer scripts for n8n workflow automation platform on Ubuntu 22.04 with SSL support

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu 22.04](https://img.shields.io/badge/Ubuntu-22.04%20LTS-orange.svg)](https://ubuntu.com/)
[![n8n Latest](https://img.shields.io/badge/n8n-Latest-blue.svg)](https://n8n.io/)

## 🚀 Quick Install

⚡ **Recommended:** Tested and optimized for [MyHosti.pro](https://myhosti.pro/en/services/vds) VPS servers (MVK tariff plans)

### Production Installation (with SSL)
```bash
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer1/main/install-n8n.sh | sudo bash
```

### Development Installation (HTTP only)
```bash 
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer1/main/simple-install.sh | sudo bash
```

## 📋 What's Included

| Script | Version | Purpose | Status |
|--------|---------|---------|---------|
| `install-n8n.sh` | v2.3.1 | 🔒 Full HTTPS setup with nginx proxy | ✅ Tested |
| `simple-install.sh` | v1.0 | ⚡ Quick HTTP installation | ✅ Tested |
| `uninstall-n8n.sh` | v2.2 | 🗑️ Complete removal with --auto mode | ✅ Tested |
| `check-requirements.sh` | v1.0 | 🔍 System requirements validation | ✅ Tested |

## ✨ Features

- **🔒 HTTPS Ready** - Automatic SSL certificates via Let's Encrypt
- **⚡ One-Click Install** - Full automation with zero configuration
- **🛡️ Security First** - nginx proxy with security headers
- **🔧 Easy Management** - systemd service with auto-start
- **🗑️ Clean Removal** - Complete uninstallation option
- **✅ Pre-validated** - System requirements checking

## 📖 Installation Guide

### Step 1: Check Requirements
```bash
# Download and run system check
curl -fsSL https://raw.githubusercontent.com/rootcraft-tech/n8n-installer1/main/check-requirements.sh | bash
```

**Requirements:**
- Ubuntu 22.04 LTS
- Minimum 1GB RAM
- sudo privileges 
- Domain with DNS pointing to your server (for HTTPS)

### Step 2: DNS Configuration
Point your domain to your server IP:
```bash
# Verify DNS propagation
dig +short yourdomain.com
```

### Step 3: Run Installation
```bash
# Download installer
wget https://raw.githubusercontent.com/rootcraft-tech/n8n-installer1/main/install-n8n.sh

# Make executable
chmod +x install-n8n.sh

# Run installation
sudo ./install-n8n.sh
```

The installer will:
1. 📦 Install Node.js 20 LTS
2. 🚀 Install latest n8n version
3. 🌐 Configure nginx reverse proxy
4. 🔒 Obtain SSL certificate
5. ⚙️ Setup systemd service
6. 🎯 Configure firewall rules

## 🔧 Advanced Usage

### Manual Installation Steps
```bash
# 1. Check system requirements
bash check-requirements.sh

# 2. Install with custom domain
sudo ./install-n8n.sh --domain yourdomain.com --email your@email.com

# 3. Access your n8n instance
# https://yourdomain.com
```

### Uninstallation
```bash
# Interactive removal
sudo bash uninstall-n8n.sh

# Silent removal
sudo bash uninstall-n8n.sh --auto
```

## 🛠️ What Gets Installed

- **Node.js 20** - Latest LTS version via NodeSource
- **n8n** - Latest stable release via npm
- **nginx** - Web server and reverse proxy
- **certbot** - SSL certificate management
- **systemd service** - Process management and auto-start

## 🌐 Access Points

- **HTTPS Access:** `https://yourdomain.com` (Port 443)
- **HTTP Access:** `http://server-ip:5678` (simple-install only)
- **Internal Service:** `localhost:5678` (behind nginx proxy)

## 🛡️ Security Features

- **SSL/TLS encryption** with automatic renewal
- **Security headers** (HSTS, X-Frame-Options, etc.)
- **Firewall configuration** (ufw rules)
- **Service isolation** (dedicated user account)
- **File permissions** hardening

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

# Check nginx config
sudo nginx -t
```

**Service Problems:**
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

## 📁 Project Structure

```
n8n-installer/
├── README.md                 # This file
├── README.ru.md             # Russian documentation
├── LICENSE                  # MIT License
├── install-n8n.sh          # Main HTTPS installer
├── simple-install.sh       # HTTP-only installer
├── uninstall-n8n.sh       # Complete removal script
├── check-requirements.sh   # System validation
├── docs/
│   ├── installation.md     # Detailed installation guide
│   ├── security.md        # Security best practices
│   └── troubleshooting.md # Common issues and solutions
└── examples/
    ├── nginx.conf         # Sample nginx configuration
    └── n8n.service       # Sample systemd service
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If this project helped you, please give it a ⭐ on GitHub!

## 🔗 Links

- [n8n Official Documentation](https://docs.n8n.io/)
- [Ubuntu 22.04 LTS](https://ubuntu.com/download/server)
- [Let's Encrypt](https://letsencrypt.org/)
- [MyHost.pro VPS](https://myhost.pro) - Recommended hosting

---

**✅ Tested on Ubuntu 22.04 LTS**  
**🚀 Production Ready**  
**🔒 Security Focused**
