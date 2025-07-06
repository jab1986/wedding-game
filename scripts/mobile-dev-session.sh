#!/bin/bash
# Mobile Development Session Manager for Termux
# Handles mobile development workflow for Wedding Game

ACTION=${1:-start}
MOBILE_CONFIG_FILE=".env.mobile"
SYNC_LOG_FILE=".mobile-sync.log"

# Detect if running on Termux
if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
    IS_TERMUX=true
    PYTHON_CMD="python"
else
    IS_TERMUX=false
    PYTHON_CMD="python3"
fi

case $ACTION in
    "start")
        echo "📱 Starting Mobile Development Session"
        echo "====================================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "🤖 Running on Termux environment"
            
            # Check for required packages
            if ! command -v git &> /dev/null; then
                echo "⚠️  Git not found. Installing..."
                pkg install git
            fi
            
            if ! command -v python &> /dev/null; then
                echo "⚠️  Python not found. Installing..."
                pkg install python
            fi
            
            # Load mobile-specific environment
            if [ -f "$MOBILE_CONFIG_FILE" ]; then
                export $(cat $MOBILE_CONFIG_FILE | xargs)
                echo "✅ Mobile environment variables loaded"
            else
                echo "⚠️  Creating mobile environment config..."
                cat > $MOBILE_CONFIG_FILE << 'EOF'
MOBILE_DEV=true
REDUCED_FUNCTIONALITY=true
SYNC_ENABLED=true
EDITOR=nano
EOF
                echo "✅ Mobile config created"
            fi
            
            # Check available storage
            AVAILABLE_SPACE=$(df -h . | tail -1 | awk '{print $4}')
            echo "💾 Available storage: $AVAILABLE_SPACE"
            
            # Check git status
            if [ -d ".git" ]; then
                echo "📊 Git Status:"
                git status --porcelain | head -5
                BRANCH=$(git branch --show-current)
                echo "🌿 Current branch: $BRANCH"
                
                # Check for uncommitted changes
                if [ -n "$(git status --porcelain)" ]; then
                    echo "⚠️  Uncommitted changes detected"
                fi
            else
                echo "⚠️  Not in a git repository"
            fi
            
            # Check network connectivity
            if ping -c 1 google.com &> /dev/null; then
                echo "🌐 Network connectivity: OK"
            else
                echo "⚠️  Network connectivity: Limited"
            fi
            
            # Display mobile development tips
            echo ""
            echo "📋 Mobile Development Tips:"
            echo "   - Use nano for simple edits: nano filename.gd"
            echo "   - Use vim for advanced editing: vim filename.gd"
            echo "   - Test changes: ./scripts/mobile-dev-session.sh test"
            echo "   - Sync to desktop: ./scripts/sync-mobile-work.sh push"
            echo "   - Check session: ./scripts/mobile-dev-session.sh status"
            
        else
            echo "🖥️  Running on desktop environment"
            echo "   Use this script on Termux for mobile development"
        fi
        
        echo ""
        echo "✨ Mobile session initialized!"
        
        ;;
        
    "test")
        echo "🧪 Testing Mobile Development Environment"
        echo "======================================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "🔧 Testing Termux Environment:"
            
            # Test basic commands
            if command -v git &> /dev/null; then
                echo "✅ Git: Available"
            else
                echo "❌ Git: Missing"
            fi
            
            if command -v python &> /dev/null; then
                echo "✅ Python: Available"
                python --version
            else
                echo "❌ Python: Missing"
            fi
            
            if command -v nano &> /dev/null; then
                echo "✅ Nano editor: Available"
            else
                echo "❌ Nano editor: Missing"
            fi
            
            # Test file operations
            echo "🗂️  Testing file operations:"
            if [ -r "README.md" ]; then
                echo "✅ File reading: OK"
            else
                echo "⚠️  File reading: Limited"
            fi
            
            if [ -w "." ]; then
                echo "✅ File writing: OK"
            else
                echo "❌ File writing: Permission denied"
            fi
            
            # Test git operations
            if [ -d ".git" ]; then
                echo "✅ Git repository: OK"
                git status --porcelain > /dev/null 2>&1
                if [ $? -eq 0 ]; then
                    echo "✅ Git operations: OK"
                else
                    echo "⚠️  Git operations: Limited"
                fi
            else
                echo "⚠️  Git repository: Not found"
            fi
            
            # Test network
            if ping -c 1 github.com &> /dev/null; then
                echo "✅ GitHub connectivity: OK"
            else
                echo "⚠️  GitHub connectivity: Limited"
            fi
            
        else
            echo "🖥️  Desktop environment detected"
            echo "   Use standard development tools"
        fi
        
        echo ""
        echo "🎯 Test completed!"
        
        ;;
        
    "status")
        echo "📊 Mobile Development Status"
        echo "==========================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "🤖 Environment: Termux"
            echo "📱 Version: $TERMUX_VERSION"
            
            # Show system info
            echo ""
            echo "💻 System Information:"
            echo "   Architecture: $(uname -m)"
            echo "   Kernel: $(uname -r)"
            echo "   Shell: $SHELL"
            
            # Show storage
            echo ""
            echo "💾 Storage:"
            df -h . | tail -1 | awk '{print "   Available: " $4 " (" $5 " used)"}'
            
            # Show git info
            if [ -d ".git" ]; then
                echo ""
                echo "🌿 Git Status:"
                echo "   Branch: $(git branch --show-current)"
                echo "   Uncommitted: $(git status --porcelain | wc -l) files"
                echo "   Last commit: $(git log -1 --format='%cr')"
            fi
            
            # Show mobile config
            if [ -f "$MOBILE_CONFIG_FILE" ]; then
                echo ""
                echo "⚙️  Mobile Config:"
                cat $MOBILE_CONFIG_FILE | sed 's/^/   /'
            fi
            
        else
            echo "🖥️  Environment: Desktop"
            echo "   Use desktop development tools"
        fi
        
        ;;
        
    "setup")
        echo "🛠️  Setting Up Mobile Development Environment"
        echo "============================================"
        
        if [ "$IS_TERMUX" = true ]; then
            echo "📦 Installing required packages..."
            
            # Update package list
            pkg update
            
            # Install essential packages
            pkg install -y git python nodejs openssh nano vim curl wget
            
            # Install build tools
            pkg install -y build-essential clang cmake pkg-config
            
            # Create mobile config
            cat > $MOBILE_CONFIG_FILE << 'EOF'
MOBILE_DEV=true
REDUCED_FUNCTIONALITY=true
SYNC_ENABLED=true
EDITOR=nano
MAX_MEMORY=512MB
TEMP_DIR=/data/data/com.termux/files/home/tmp
EOF
            
            # Setup git config
            echo "⚙️  Configuring Git..."
            git config --global push.default simple
            git config --global pull.rebase true
            git config --global core.autocrlf false
            
            # Create helpful aliases
            echo "🔗 Setting up aliases..."
            cat >> ~/.bashrc << 'EOF'
# Wedding Game Mobile Development Aliases
alias ll='ls -la'
alias ..='cd ..'
alias wedding='cd ~/wedding-game'
alias mobile-session='./scripts/mobile-dev-session.sh'
alias mobile-sync='./scripts/sync-mobile-work.sh'
alias mobile-test='./scripts/mobile-dev-session.sh test'
EOF
            
            # Create tmp directory
            mkdir -p ~/tmp
            
            echo "✅ Mobile development environment setup complete!"
            echo ""
            echo "🎯 Next steps:"
            echo "   1. source ~/.bashrc"
            echo "   2. ./scripts/mobile-dev-session.sh start"
            echo "   3. ./scripts/sync-mobile-work.sh setup"
            
        else
            echo "⚠️  This setup is designed for Termux"
            echo "   Use standard development setup on desktop"
        fi
        
        ;;
        
    "sync")
        echo "🔄 Mobile Sync Operation"
        echo "======================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "📱 Syncing mobile work..."
            
            # Check if sync script exists
            if [ -f "scripts/sync-mobile-work.sh" ]; then
                ./scripts/sync-mobile-work.sh $2
            else
                echo "⚠️  Sync script not found"
                echo "   Creating basic sync functionality..."
                
                # Log sync operation
                echo "$(date): Mobile sync requested" >> $SYNC_LOG_FILE
                
                # Basic git sync
                git add .
                git commit -m "Mobile development sync - $(date)"
                git push origin mobile-dev 2>/dev/null || git push origin $(git branch --show-current)
                
                echo "✅ Basic sync completed"
            fi
        else
            echo "🖥️  Desktop sync not implemented in mobile script"
        fi
        
        ;;
        
    "clean")
        echo "🧹 Cleaning Mobile Development Environment"
        echo "========================================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "📱 Cleaning Termux environment..."
            
            # Clean temporary files
            rm -rf ~/tmp/*
            rm -rf ~/.cache/*
            
            # Clean git
            git clean -fdx
            git gc --aggressive
            
            # Clean Python cache
            find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
            find . -name "*.pyc" -delete 2>/dev/null || true
            
            # Clean npm cache if exists
            if command -v npm &> /dev/null; then
                npm cache clean --force
            fi
            
            echo "✅ Mobile environment cleaned"
        else
            echo "🖥️  Desktop cleaning not implemented in mobile script"
        fi
        
        ;;
        
    *)
        echo "❌ Unknown command: $ACTION"
        echo "Usage: $0 [start|test|status|setup|sync|clean]"
        echo ""
        echo "Commands:"
        echo "  start  - Start mobile development session"
        echo "  test   - Test mobile development environment"
        echo "  status - Show mobile development status"
        echo "  setup  - Setup mobile development environment"
        echo "  sync   - Sync mobile work (requires direction: push/pull)"
        echo "  clean  - Clean mobile development environment"
        exit 1
        ;;
esac