# Security Best Practices

Security recommendations for n8n Ubuntu installations.

## SSL/TLS Configuration

### Automatic SSL Setup
The installer automatically configures SSL using Let's Encrypt:
- **Certificate Authority:** Let's Encrypt
- **Auto-renewal:** Configured via systemd timer
- **Strong ciphers:** Modern TLS configuration
- **HSTS:** HTTP Strict Transport Security enabled

### Manual SSL Verification
```bash
# Check certificate status
sudo certbot certificates

# Test SSL configuration
curl -I https://yourdomain.com

# Verify certificate chain
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com
```

## nginx Security Headers

The installer configures these security headers:

```nginx
# Security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
```

## Firewall Configuration

### UFW Rules
```bash
# Check current rules
sudo ufw status verbose

# Default configuration
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
```

### Custom Rules
```bash
# Allow specific IP only
sudo ufw allow from 192.168.1.100 to any port 22

# Block specific countries (requires geoip)
sudo ufw deny from 192.168.1.0/24

# Rate limiting
sudo ufw limit ssh
```

## n8n Security Configuration

### Basic Authentication
Add extra security layer:
```bash
sudo systemctl edit n8n
```

Add configuration:
```ini
[Service]
Environment="N8N_BASIC_AUTH_ACTIVE=true"
Environment="N8N_BASIC_AUTH_USER=admin"
Environment="N8N_BASIC_AUTH_PASSWORD=secure_random_password_123"
```

### User Permissions
The installer creates a dedicated user:
```bash
# n8n runs as limited user
sudo -u n8n whoami

# Check permissions
ls -la /home/n8n/
```

## Database Security

### SQLite (Default)
- File permissions restricted to n8n user
- Located in `/home/n8n/.n8n/database.sqlite`

### PostgreSQL (Recommended for Production)
```bash
# Create dedicated database user
sudo -u postgres createuser --no-superuser --no-createdb --no-createrole n8n_user

# Set strong password
sudo -u postgres psql
ALTER USER n8n_user WITH PASSWORD 'very_strong_password_here';
```

## System Security

### Regular Updates
```bash
# Automatic security updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Manual updates
sudo apt update && sudo apt upgrade
```

### SSH Hardening
```bash
# Disable root login
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Use key-based authentication only
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH service
sudo systemctl restart ssh
```

### File System Security
```bash
# Set proper ownership
sudo chown -R n8n:n8n /home/n8n/

# Restrict permissions
sudo chmod 700 /home/n8n/.n8n/
sudo chmod 600 /home/n8n/.n8n/config

# Check for world-writable files
find /home/n8n -type f -perm -o+w
```

## Monitoring and Logging

### Log Monitoring
```bash
# Monitor n8n logs
sudo journalctl -u n8n -f

# Monitor nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Monitor auth logs
sudo tail -f /var/log/auth.log
```

### Fail2Ban Setup
```bash
# Install fail2ban
sudo apt install fail2ban

# Configure for nginx
sudo tee /etc/fail2ban/jail.local << EOF
[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
bantime = 3600

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
maxretry = 10
bantime = 600
EOF

sudo systemctl restart fail2ban
```

## Backup Security

### Encrypted Backups
```bash
# Create encrypted backup
sudo tar -czf - /home/n8n/.n8n/ | gpg --cipher-algo AES256 --compress-algo 2 --symmetric --output n8n-backup-$(date +%Y%m%d).tar.gz.gpg

# Restore encrypted backup
gpg --decrypt n8n-backup-YYYYMMDD.tar.gz.gpg | sudo tar -xzf - -C /
```

### Secure Storage
- Store backups off-site
- Use different encryption keys
- Regular backup testing
- Version rotation

## Compliance Considerations

### GDPR Compliance
- Configure data retention policies
- Implement user data export
- Set up data deletion procedures
- Document data processing activities

### Access Logging
```bash
# Enable detailed logging
sudo systemctl edit n8n
```

Add:
```ini
[Service]
Environment="N8N_LOG_LEVEL=verbose"
Environment="N8N_LOG_OUTPUT=file"
Environment="N8N_LOG_FILE=/home/n8n/.n8n/logs/n8n.log"
```

## Security Checklist

### Initial Setup
- [ ] SSL certificates properly configured
- [ ] Strong passwords used everywhere
- [ ] Firewall rules configured
- [ ] Basic authentication enabled
- [ ] System updates applied

### Regular Maintenance
- [ ] Monitor security logs weekly
- [ ] Update n8n monthly
- [ ] Review access logs monthly
- [ ] Test backups monthly
- [ ] Review user accounts quarterly

### Incident Response
- [ ] Document security procedures
- [ ] Create incident response plan
- [ ] Test recovery procedures
- [ ] Maintain contact information
- [ ] Regular security assessments

## Additional Resources

- [OWASP Security Guidelines](https://owasp.org/)
- [nginx Security Tips](https://nginx.org/en/docs/http/securing_web_traffic.html)
- [Ubuntu Security Guide](https://ubuntu.com/security)
- [Let's Encrypt Best Practices](https://letsencrypt.org/docs/)
