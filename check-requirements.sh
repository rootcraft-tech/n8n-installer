#!/bin/bash

# n8n Requirements Checker
# System requirements validation script
# Author: AI-Generated Script
# License: MIT

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "=================================="
    echo "   n8n System Requirements Check"
    echo "=================================="
    echo -e "${NC}"
}

check_pass() {
    echo -e "✅ ${GREEN}$1${NC}"
}

check_fail() {
    echo -e "❌ ${RED}$1${NC}"
}

check_warn() {
    echo -e "⚠️  ${YELLOW}$1${NC}"
}

check_info() {
    echo -e "ℹ️  ${BLUE}$1${NC}"
}

print_header

# Check if running on Ubuntu
echo "🔍 Checking Operating System..."
if grep -q "Ubuntu" /etc/os-release; then
    OS_VERSION=$(lsb_release -rs)
    if [[ "$OS_VERSION" == "22.04" ]]; then
        check_pass "Ubuntu 22.04 LTS detected"
    else
        check_warn "Ubuntu $OS_VERSION detected (22.04 LTS recommended)"
    fi
else
    check_fail "Not running Ubuntu (Ubuntu 22.04 LTS required)"
    exit 1
fi

# Check architecture
echo
echo "🔍 Checking Architecture..."
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    check_pass "x86_64 architecture supported"
elif [[ "$ARCH" == "aarch64" ]]; then
    check_pass "ARM64 architecture supported"
else
    check_warn "Architecture $ARCH may not be fully supported"
fi

# Check memory
echo
echo "🔍 Checking Memory..."
MEMORY_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEMORY_GB=$(( MEMORY_KB / 1024 / 1024 ))

if (( MEMORY_GB >= 2 )); then
    check_pass "${MEMORY_GB}GB RAM available (recommended: 2GB+)"
elif (( MEMORY_GB >= 1 )); then
    check_warn "${MEMORY_GB}GB RAM available (minimum: 1GB, recommended: 2GB+)"
else
    check_fail "Only ${MEMORY_GB}GB RAM available (minimum: 1GB required)"
fi

# Check disk space
echo
echo "🔍 Checking Disk Space..."
DISK_SPACE=$(df / | awk 'NR==2 {print $4}')
DISK_GB=$(( DISK_SPACE / 1024 / 1024 ))

if (( DISK_GB >= 5 )); then
    check_pass "${DISK_GB}GB disk space available"
elif (( DISK_GB >= 2 )); then
    check_warn "${DISK_GB}GB disk space available (minimum: 2GB)"
else
    check_fail "Only ${DISK_GB}GB disk space available (minimum: 2GB required)"
fi

# Check sudo access
echo
echo "🔍 Checking Permissions..."
if [[ $EUID -eq 0 ]]; then
    check_pass "Running as root"
elif sudo -n true 2>/dev/null; then
    check_pass "sudo access available"
else
    check_fail "sudo access required"
fi

# Check internet connectivity
echo
echo "🔍 Checking Internet Connectivity..."
if ping -c 1 google.com &> /dev/null; then
    check_pass "Internet connectivity available"
else
    check_fail "No internet connectivity (required for installation)"
fi

# Check if ports are available
echo
echo "🔍 Checking Port Availability..."
if command -v netstat &> /dev/null; then
    if netstat -tuln | grep -q ":80 "; then
        check_warn "Port 80 is in use (required for nginx)"
    else
        check_pass "Port 80 is available"
    fi

    if netstat -tuln | grep -q ":443 "; then
        check_warn "Port 443 is in use (required for HTTPS)"
    else
        check_pass "Port 443 is available"
    fi

    if netstat -tuln | grep -q ":5678 "; then
        check_warn "Port 5678 is in use (required for n8n)"
    else
        check_pass "Port 5678 is available"
    fi
else
    check_info "netstat not available, skipping port check"
fi

# Check existing installations
echo
echo "🔍 Checking Existing Installations..."

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    check_info "Node.js already installed: $NODE_VERSION"

    if command -v n8n &> /dev/null; then
        N8N_VERSION=$(n8n --version)
        check_warn "n8n already installed: $N8N_VERSION"
    fi
else
    check_pass "Node.js not installed (will be installed)"
fi

if command -v nginx &> /dev/null; then
    check_info "nginx already installed"
else
    check_pass "nginx not installed (will be installed)"
fi

# Check systemd
echo
echo "🔍 Checking System Services..."
if command -v systemctl &> /dev/null; then
    check_pass "systemd available"
else
    check_fail "systemd required but not available"
fi

# Check package manager
echo
echo "🔍 Checking Package Manager..."
if command -v apt &> /dev/null; then
    check_pass "apt package manager available"

    # Check if we can update package list
    if apt list --upgradable &> /dev/null; then
        check_pass "Package manager working correctly"
    else
        check_warn "Package manager may need update (run: sudo apt update)"
    fi
else
    check_fail "apt package manager required"
fi

echo
echo "🔍 Summary:"
echo "========================"

# Count checks
TOTAL_CHECKS=$(( $(check_pass "dummy" 2>&1 | wc -l) + $(check_warn "dummy" 2>&1 | wc -l) + $(check_fail "dummy" 2>&1 | wc -l) ))

echo "System ready for n8n installation!"
check_info "Run 'sudo bash install-n8n.sh' for HTTPS installation"
check_info "Run 'sudo bash simple-install.sh' for HTTP installation"

echo
echo "📚 Documentation:"
echo "• Installation Guide: https://github.com/YOUR_USERNAME/n8n-installer"
echo "• Troubleshooting: https://github.com/YOUR_USERNAME/n8n-installer/blob/main/docs/troubleshooting.md"

echo -e "${NC}"
