# Troubleshooting Guide

Common issues and solutions for n8n Ubuntu installations.

## Installation Issues

### Node.js Installation Fails

**Problem:** NodeSource repository not accessible or GPG key issues.

**Solution:**
```bash
# Clean up failed installation
sudo apt remove nodejs npm
sudo rm -f /etc/apt/sources.list.d/nodesource.list

# Manual Node.js installation
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update && sudo apt install nodejs
```

### n8n Installation Fails

**Problem:** npm permissions or network issues.

**Solution:**
```bash
# Check npm configuration
npm config list

# Clear npm cache
sudo npm cache clean --force

# Install with different method
sudo -u n8n npm install -g n8n@latest --unsafe-perm
```

### SSL Certificate Issues

**Problem:** Let's Encrypt fails to issue certificate.

**Symptoms:**
- "Failed to obtain certificate"
- "DNS challenge failed" 
- "Rate limit exceeded"

**Solutions:**

1. **Check DNS propagation:**
   ```bash
   dig +short yourdomain.com
   nslookup yourdomain.com 8.8.8.8
   ```

2. **Manual certificate request:**
   ```bash
   sudo certbot certonly --nginx -d yourdomain.com
   ```

3. **Rate limit issues:**
   ```bash
   # Check rate limit status
   sudo certbot certificates

   # Wait 1 hour and retry, or use staging environment
   sudo certbot certonly --staging -d yourdomain.com
   ```

## Service Issues

### n8n Service Won't Start

**Problem:** Service fails to start or immediately stops.

**Diagnosis:**
```bash
# Check service status
sudo systemctl status n8n

# View detailed logs
sudo journalctl -u n8n -f --no-pager

# Check service file
sudo cat /etc/systemd/system/n8n.service
```

**Common Solutions:**

1. **Permission issues:**
   ```bash
   sudo chown -R n8n:n8n /home/n8n/
   sudo chmod 755 /home/n8n/
   ```

2. **Node.js path issues:**
   ```bash
   # Update service file with correct path
   which node
   sudo systemctl edit n8n
   ```

3. **Port conflicts:**
   ```bash
   # Check what's using port 5678
   sudo netstat -tlnp | grep :5678
   sudo lsof -i :5678
   ```

### nginx Configuration Issues

**Problem:** nginx fails to start or proxy doesn't work.

**Diagnosis:**
```bash
# Test nginx configuration
sudo nginx -t

# Check nginx status
sudo systemctl status nginx

# View nginx logs
sudo tail -f /var/log/nginx/error.log
```

**Solutions:**

1. **Configuration syntax errors:**
   ```bash
   # Fix syntax and test
   sudo nginx -t
   sudo systemctl reload nginx
   ```

2. **Port 80/443 conflicts:**
   ```bash
   # Check what's using the ports
   sudo netstat -tlnp | grep :80
   sudo netstat -tlnp | grep :443

   # Stop conflicting services
   sudo systemctl stop apache2  # if installed
   ```

3. **SSL certificate path issues:**
   ```bash
   # Verify certificate files exist
   ls -la /etc/letsencrypt/live/yourdomain.com/

   # Update nginx config with correct paths
   sudo nano /etc/nginx/sites-available/n8n
   ```

## Access Issues

### Cannot Access n8n Interface

**Problem:** Browser shows connection refused or timeout.

**Troubleshooting Steps:**

1. **Check if n8n is running:**
   ```bash
   sudo systemctl status n8n
   curl -i http://localhost:5678
   ```

2. **Check nginx proxy:**
   ```bash
   sudo systemctl status nginx
   curl -i http://localhost
   ```

3. **Check firewall:**
   ```bash
   sudo ufw status
   sudo ufw allow 'Nginx Full'
   ```

4. **Check DNS:**
   ```bash
   dig +short yourdomain.com
   # Should return your server IP
   ```

### SSL/HTTPS Issues

**Problem:** Browser shows SSL errors or certificate warnings.

**Solutions:**

1. **Certificate not found:**
   ```bash
   sudo certbot certificates
   sudo systemctl reload nginx
   ```

2. **Mixed content issues:**
   ```bash
   # Check n8n is running on HTTP internally
   curl http://localhost:5678
   ```

3. **Certificate renewal:**
   ```bash
   sudo certbot renew --dry-run
   sudo certbot renew
   ```

## Performance Issues

### High Memory Usage

**Problem:** System running out of memory.

**Solutions:**

1. **Check memory usage:**
   ```bash
   free -h
   ps aux | grep n8n
   ```

2. **Optimize n8n settings:**
   ```bash
   sudo systemctl edit n8n
   ```

   Add:
   ```ini
   [Service]
   Environment="NODE_OPTIONS=--max-old-space-size=1024"
   ```

3. **Add swap space:**
   ```bash
   sudo fallocate -l 2G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
   ```

### Slow Performance

**Problem:** n8n interface or workflows are slow.

**Solutions:**

1. **Check system resources:**
   ```bash
   htop
   iotop
   ```

2. **Database optimization (SQLite):**
   ```bash
   sudo -u n8n sqlite3 /home/n8n/.n8n/database.sqlite "VACUUM;"
   ```

3. **Consider PostgreSQL:**
   ```bash
   # Install PostgreSQL
   sudo apt install postgresql postgresql-contrib

   # Configure n8n to use PostgreSQL
   sudo systemctl edit n8n
   ```

## Database Issues

### SQLite Database Corruption

**Problem:** Database errors or corruption.

**Solutions:**

1. **Check database integrity:**
   ```bash
   sudo -u n8n sqlite3 /home/n8n/.n8n/database.sqlite "PRAGMA integrity_check;"
   ```

2. **Repair database:**
   ```bash
   sudo systemctl stop n8n
   sudo -u n8n sqlite3 /home/n8n/.n8n/database.sqlite ".recover" | sudo -u n8n sqlite3 /home/n8n/.n8n/database_recovered.sqlite
   sudo -u n8n mv /home/n8n/.n8n/database.sqlite /home/n8n/.n8n/database.sqlite.backup
   sudo -u n8n mv /home/n8n/.n8n/database_recovered.sqlite /home/n8n/.n8n/database.sqlite
   sudo systemctl start n8n
   ```

### Migration to PostgreSQL

**Problem:** Need to migrate from SQLite to PostgreSQL.

**Steps:**

1. **Install PostgreSQL:**
   ```bash
   sudo apt install postgresql postgresql-contrib
   ```

2. **Create database:**
   ```bash
   sudo -u postgres createdb n8n
   sudo -u postgres createuser n8n_user
   ```

3. **Configure n8n:**
   ```bash
   sudo systemctl edit n8n
   ```

   Add:
   ```ini
   [Service]
   Environment="DB_TYPE=postgresdb"
   Environment="DB_POSTGRESDB_HOST=localhost"
   Environment="DB_POSTGRESDB_DATABASE=n8n"
   Environment="DB_POSTGRESDB_USER=n8n_user"
   Environment="DB_POSTGRESDB_PASSWORD=secure_password"
   ```

## Network Issues

### DNS Problems

**Problem:** Domain not resolving or pointing to wrong IP.

**Solutions:**

1. **Check DNS propagation:**
   ```bash
   dig +short yourdomain.com
   dig +short yourdomain.com @8.8.8.8
   dig +short yourdomain.com @1.1.1.1
   ```

2. **Wait for propagation:**
   - DNS changes can take up to 48 hours
   - Use online DNS checker tools

3. **Verify domain configuration:**
   - Check with your domain registrar
   - Ensure A record points to correct IP

### Firewall Issues

**Problem:** Connections blocked by firewall.

**Solutions:**

1. **Check UFW status:**
   ```bash
   sudo ufw status verbose
   ```

2. **Allow required ports:**
   ```bash
   sudo ufw allow ssh
   sudo ufw allow 'Nginx Full'
   ```

3. **Check iptables:**
   ```bash
   sudo iptables -L -n
   ```

## Log Analysis

### Reading n8n Logs

```bash
# Real-time logs
sudo journalctl -u n8n -f

# Logs from specific time
sudo journalctl -u n8n --since "2024-01-01 00:00:00"

# Error logs only
sudo journalctl -u n8n -p err
```

### Reading nginx Logs

```bash
# Access logs
sudo tail -f /var/log/nginx/access.log

# Error logs
sudo tail -f /var/log/nginx/error.log

# Search for specific errors
sudo grep "error" /var/log/nginx/error.log
```

## Recovery Procedures

### Complete System Recovery

If everything fails:

1. **Backup data:**
   ```bash
   sudo tar -czf n8n-backup-$(date +%Y%m%d).tar.gz /home/n8n/.n8n/
   ```

2. **Clean installation:**
   ```bash
   sudo bash uninstall-n8n.sh --auto
   sudo bash install-n8n.sh
   ```

3. **Restore data:**
   ```bash
   sudo systemctl stop n8n
   sudo tar -xzf n8n-backup-*.tar.gz -C /
   sudo chown -R n8n:n8n /home/n8n/
   sudo systemctl start n8n
   ```

### Emergency Access

If you're locked out:

1. **Direct access via IP:**
   ```bash
   # Temporarily allow direct access
   sudo ufw allow 5678
   # Access via http://your-ip:5678
   ```

2. **Remove SSL redirect:**
   ```bash
   sudo sed -i 's/return 301 https:/# return 301 https:/' /etc/nginx/sites-available/n8n
   sudo systemctl reload nginx
   ```

## Getting Help

### Collect System Information

Before asking for help, collect this information:

```bash
# System information
uname -a
lsb_release -a
free -h
df -h

# Service status
sudo systemctl status n8n nginx
sudo journalctl -u n8n --no-pager -l -n 50

# Network information
ip addr show
sudo netstat -tlnp | grep -E ':80|:443|:5678'

# SSL certificates
sudo certbot certificates

# nginx configuration test
sudo nginx -t
```

### Where to Get Help

- [GitHub Issues](https://github.com/YOUR_USERNAME/n8n-installer/issues)
- [n8n Community](https://community.n8n.io/)
- [Ubuntu Forums](https://ubuntuforums.org/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/n8n)

Remember to include system information and relevant logs when asking for help!
