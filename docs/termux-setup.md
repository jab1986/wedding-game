# Termux Mobile Development Setup

## Overview
This guide sets up a complete mobile development environment for the Wedding Game project using Termux on Android.

## Prerequisites
- Android device with Termux installed (preferably from F-Droid)
- Stable internet connection
- At least 2GB free storage

## Initial Setup

### 1. Install Termux
```bash
# From F-Droid (recommended)
# https://f-droid.org/en/packages/com.termux/

# Or from GitHub releases
# https://github.com/termux/termux-app/releases
```

### 2. Basic Package Installation
```bash
# Update packages
pkg update && pkg upgrade

# Install essential tools
pkg install git python nodejs openssh nano vim curl wget

# Install additional development tools
pkg install build-essential clang cmake pkg-config
```

### 3. SSH Key Setup
```bash
# Generate SSH key for desktop sync
ssh-keygen -t ed25519 -C "mobile-dev@termux"

# Copy public key to desktop
cat ~/.ssh/id_ed25519.pub
# Add this to your desktop's ~/.ssh/authorized_keys
```

### 4. Clone Repository
```bash
# Clone the wedding game repository
git clone https://github.com/jab1986/wedding-game.git
cd wedding-game

# Install Python dependencies
pip install -r requirements.txt  # if exists
```

## Mobile Development Scripts

### 1. Mobile Session Manager
```bash
# Make executable
chmod +x scripts/mobile-dev-session.sh

# Start mobile development session
./scripts/mobile-dev-session.sh start
```

### 2. Synchronization Setup
```bash
# Setup sync with desktop
./scripts/sync-mobile-work.sh setup

# Test connection
./scripts/sync-mobile-work.sh test
```

## Development Workflow

### Daily Mobile Development
```bash
# 1. Start session
./scripts/mobile-dev-session.sh start

# 2. Pull latest changes
./scripts/sync-mobile-work.sh pull

# 3. Work on code
nano src/characters/Mark.gd
vim scripts/gameplay_logic.py

# 4. Test changes
./scripts/mobile-dev-session.sh test

# 5. Commit and push
git add .
git commit -m "feat: mobile development changes"
./scripts/sync-mobile-work.sh push
```

### Available Editors
- **nano**: Simple, beginner-friendly
- **vim**: Powerful, keyboard-driven
- **emacs**: Feature-rich (if installed)
- **micro**: Modern, mouse-friendly

## Limitations and Workarounds

### MCP Server Limitations
- Limited MCP server support on mobile
- Reduced tool availability (no Cursor integration)
- Network dependency for cloud tools

### Performance Considerations
- Battery optimization needed
- CPU-intensive tasks may be slow
- Limited memory compared to desktop

### File System Differences
- Case-sensitive file system
- Different path separators
- Limited file permissions

## Troubleshooting

### Common Issues

#### 1. Package Installation Failures
```bash
# Clear package cache
pkg clean

# Update repositories
pkg update

# Try alternative mirrors
termux-change-repo
```

#### 2. Git Authentication
```bash
# Use token authentication
git config --global credential.helper store
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

#### 3. Python Environment
```bash
# Install missing packages
pip install --upgrade pip
pip install requests python-dotenv

# Check Python version
python --version
```

#### 4. SSH Connection Issues
```bash
# Test SSH connection
ssh -T git@github.com

# Check SSH agent
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519
```

### Performance Optimization
```bash
# Reduce memory usage
export NODE_OPTIONS="--max-old-space-size=1024"

# Enable swap (if device supports)
# Note: This requires root access
```

## Advanced Configuration

### Environment Variables
```bash
# Create mobile-specific .env
cat > .env.mobile << EOF
MOBILE_DEV=true
REDUCED_FUNCTIONALITY=true
SYNC_ENABLED=true
DESKTOP_HOST=192.168.1.100
EOF
```

### Git Configuration
```bash
# Configure Git for mobile
git config --global push.default simple
git config --global pull.rebase true
git config --global core.autocrlf false
```

### Alias Setup
```bash
# Add to ~/.bashrc
echo "alias ll='ls -la'" >> ~/.bashrc
echo "alias ..='cd ..'" >> ~/.bashrc
echo "alias wedding='cd ~/wedding-game'" >> ~/.bashrc
source ~/.bashrc
```

## Backup and Recovery

### Backup Important Data
```bash
# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
tar -czf wedding-game-backup-$(date +%Y%m%d).tar.gz \
    wedding-game/ \
    ~/.ssh/ \
    ~/.gitconfig \
    ~/.bashrc
EOF

chmod +x backup.sh
./backup.sh
```

### Recovery Process
```bash
# Restore from backup
tar -xzf wedding-game-backup-YYYYMMDD.tar.gz

# Restore SSH keys
cp -r .ssh/ ~/
chmod 600 ~/.ssh/id_ed25519

# Restore Git config
cp .gitconfig ~/
```

## Integration with Desktop

### Sync Workflow
1. **Push from Mobile**: `./scripts/sync-mobile-work.sh push`
2. **Pull to Desktop**: `./scripts/sync-mobile-work.sh pull`
3. **Conflict Resolution**: Manual merge if needed
4. **Test Integration**: Full test suite on desktop

### File Structure Sync
```bash
# Sync specific directories
rsync -av src/ desktop:~/Projects/wedding-game/src/
rsync -av scripts/ desktop:~/Projects/wedding-game/scripts/
```

## Security Considerations

### API Key Management
- Use environment variables for sensitive data
- Never commit real API keys
- Use read-only tokens when possible
- Rotate keys regularly

### Network Security
- Use SSH for all remote connections
- Avoid public WiFi for sensitive operations
- Enable 2FA on all accounts
- Keep Termux updated

## Future Enhancements

### Planned Features
- VS Code Server integration
- Docker container support
- Advanced testing capabilities
- Cloud IDE integration

### Community Contributions
- Share mobile development tips
- Contribute to termux-setup scripts
- Report mobile-specific issues
- Improve documentation

---

*Mobile development made possible with Termux - Wedding Game Project 2024*