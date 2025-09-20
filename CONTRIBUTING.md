# Contributing to n8n Ubuntu Installer Scripts

Thank you for your interest in contributing to the n8n Ubuntu Installer Scripts project! 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)

## 🤝 Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code.

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect differing viewpoints and experiences

## 🚀 How to Contribute

### Types of Contributions

We welcome various types of contributions:

- 🐛 **Bug Reports** - Help us identify and fix issues
- 💡 **Feature Requests** - Suggest new functionality
- 📝 **Documentation** - Improve guides and examples
- 🔧 **Code Improvements** - Enhance existing scripts
- 🧪 **Testing** - Test on different systems and configurations

### Before You Start

1. Check existing [issues](https://github.com/YOUR_USERNAME/n8n-installer/issues) and [pull requests](https://github.com/YOUR_USERNAME/n8n-installer/pulls)
2. For major changes, open an issue first to discuss the approach
3. Ensure your changes align with the project's goals

## 🛠️ Development Setup

### Prerequisites

- Ubuntu 22.04 LTS (for testing)
- Basic knowledge of Bash scripting
- Access to a domain for HTTPS testing (optional)

### Local Development

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/n8n-installer.git
   cd n8n-installer
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Test environment setup**
   ```bash
   # Use a fresh Ubuntu 22.04 VM or container for testing
   # Never test directly on production systems
   ```

## 🧪 Testing Guidelines

### Required Testing

Before submitting changes, test your scripts on:

- ✅ Fresh Ubuntu 22.04 LTS installation
- ✅ System with existing packages (upgrade scenario)
- ✅ Different memory configurations (1GB, 2GB, 4GB+)

### Testing Process

1. **System Requirements Check**
   ```bash
   bash check-requirements.sh
   ```

2. **Installation Testing**
   ```bash
   # Test both HTTP and HTTPS installations
   sudo bash simple-install.sh
   sudo bash install-n8n.sh
   ```

3. **Uninstallation Testing**
   ```bash
   # Test both interactive and automatic modes
   sudo bash uninstall-n8n.sh
   sudo bash uninstall-n8n.sh --auto
   ```

### Test Documentation

Include test results with your pull request:

```
## Testing Results

- **OS:** Ubuntu 22.04 LTS
- **Memory:** 2GB
- **Installation Type:** HTTPS
- **Result:** ✅ Success
- **n8n Version:** 1.97.0
- **Access URL:** https://test.domain.com
- **Issues:** None
```

## 📤 Submitting Changes

### Pull Request Process

1. **Update documentation** - Ensure README files reflect your changes
2. **Test thoroughly** - Include test results in PR description
3. **Follow conventions** - Match existing code style and structure
4. **Write clear commits** - Use descriptive commit messages

### Commit Message Format

```
type: brief description

More detailed explanation if needed

- Include bullet points for multiple changes
- Reference issues with #issue-number
- Keep lines under 72 characters
```

Examples:
- `fix: resolve DNS validation bug in install script`
- `feat: add support for custom n8n port configuration`
- `docs: update troubleshooting guide with SSL issues`

### PR Template

When creating a pull request, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested on Ubuntu 22.04 LTS
- [ ] Verified installation works
- [ ] Verified uninstallation works
- [ ] Updated documentation

## Checklist
- [ ] Code follows project conventions
- [ ] Self-reviewed the changes
- [ ] Added/updated tests if needed
- [ ] Updated documentation
```

## 🐛 Reporting Issues

### Bug Reports

Use this template for bug reports:

```markdown
## Bug Description
Clear description of the issue

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should have happened

## Actual Behavior
What actually happened

## Environment
- OS: Ubuntu 22.04 LTS
- Memory: XGB
- Script Version: vX.X.X
- Domain: Yes/No

## Logs
```
Paste relevant logs here
```

## Additional Context
Any other relevant information
```

### Feature Requests

For feature requests, describe:

- **Problem:** What problem does this solve?
- **Solution:** What would you like to see?
- **Alternatives:** What alternatives have you considered?
- **Use Case:** How would this be used?

## 📚 Resources

- [Bash Scripting Guide](https://tldp.org/LDP/abs/html/)
- [nginx Documentation](https://nginx.org/en/docs/)
- [n8n Documentation](https://docs.n8n.io/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)

## ❓ Questions

If you have questions:

1. Check the [documentation](README.md)
2. Search existing [issues](https://github.com/YOUR_USERNAME/n8n-installer/issues)
3. Create a new issue with the "question" label

Thank you for contributing! 🙏
