#!/bin/bash
# Mobile Work Synchronization Script
# Handles bidirectional sync between mobile (Termux) and desktop

ACTION=${1:-status}
SYNC_LOG_FILE=".mobile-sync.log"
MOBILE_BRANCH="mobile-dev"
SYNC_CONFIG_FILE=".sync-config"

# Detect environment
if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
    IS_TERMUX=true
    ENVIRONMENT="mobile"
else
    IS_TERMUX=false
    ENVIRONMENT="desktop"
fi

# Logging function
log_sync() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$ENVIRONMENT] $1" >> $SYNC_LOG_FILE
}

# Check git status
check_git_status() {
    if [ ! -d ".git" ]; then
        echo "❌ Not in a git repository"
        exit 1
    fi
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo "⚠️  Uncommitted changes detected:"
        git status --short
        return 1
    fi
    return 0
}

# Create sync commit
create_sync_commit() {
    local commit_msg="$1"
    
    git add .
    git commit -m "$commit_msg

🤖 Generated with Claude Code (Mobile Sync)

Co-Authored-By: Claude <noreply@anthropic.com>"
    
    return $?
}

case $ACTION in
    "setup")
        echo "🛠️  Setting Up Mobile-Desktop Synchronization"
        echo "============================================="
        
        # Create sync configuration
        cat > $SYNC_CONFIG_FILE << 'EOF'
# Mobile Sync Configuration
SYNC_ENABLED=true
AUTO_COMMIT=true
CONFLICT_RESOLUTION=manual
SYNC_DIRECTORIES=src,scripts,docs,dialogues
DESKTOP_HOST=192.168.1.100
DESKTOP_USER=joe
DESKTOP_PROJECT_PATH=/home/joe/Projects/wedding-game
EOF
        
        if [ "$IS_TERMUX" = true ]; then
            echo "📱 Configuring Termux sync..."
            
            # Setup SSH key if not exists
            if [ ! -f ~/.ssh/id_ed25519 ]; then
                echo "🔑 Generating SSH key..."
                ssh-keygen -t ed25519 -C "mobile-sync@termux" -f ~/.ssh/id_ed25519 -N ""
                echo "✅ SSH key generated"
                echo ""
                echo "📋 Add this public key to your desktop's ~/.ssh/authorized_keys:"
                echo "=================================================="
                cat ~/.ssh/id_ed25519.pub
                echo "=================================================="
                echo ""
            fi
            
            # Create mobile sync aliases
            cat >> ~/.bashrc << 'EOF'
# Mobile Sync Aliases
alias sync-push='./scripts/sync-mobile-work.sh push'
alias sync-pull='./scripts/sync-mobile-work.sh pull'
alias sync-status='./scripts/sync-mobile-work.sh status'
alias sync-test='./scripts/sync-mobile-work.sh test'
EOF
            
        else
            echo "🖥️  Configuring desktop sync..."
            
            # Setup SSH key for desktop if needed
            if [ ! -f ~/.ssh/id_ed25519 ]; then
                echo "🔑 Generating SSH key for desktop..."
                ssh-keygen -t ed25519 -C "desktop-sync@wedding-game" -f ~/.ssh/id_ed25519 -N ""
            fi
            
            # Create mobile development branch
            git checkout -b $MOBILE_BRANCH 2>/dev/null || git checkout $MOBILE_BRANCH
            git push -u origin $MOBILE_BRANCH 2>/dev/null || echo "Branch already exists on remote"
            git checkout main
        fi
        
        echo "✅ Sync setup completed!"
        echo ""
        echo "🎯 Next steps:"
        echo "   1. Test connection: ./scripts/sync-mobile-work.sh test"
        echo "   2. Push changes: ./scripts/sync-mobile-work.sh push"
        echo "   3. Pull changes: ./scripts/sync-mobile-work.sh pull"
        
        log_sync "Sync setup completed for $ENVIRONMENT"
        
        ;;
        
    "push")
        echo "📤 Pushing Mobile Work to Desktop"
        echo "================================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "📱 Pushing from Termux to desktop..."
            
            # Check for changes
            if [ -z "$(git status --porcelain)" ]; then
                echo "✅ No changes to push"
                exit 0
            fi
            
            # Create sync commit
            COMMIT_MSG="Mobile development sync - $(date '+%Y-%m-%d %H:%M')"
            create_sync_commit "$COMMIT_MSG"
            
            if [ $? -eq 0 ]; then
                # Push to mobile branch
                git push origin $MOBILE_BRANCH 2>/dev/null || git push origin $(git branch --show-current)
                
                if [ $? -eq 0 ]; then
                    echo "✅ Mobile work pushed successfully"
                    log_sync "Push completed - $COMMIT_MSG"
                else
                    echo "❌ Push failed"
                    log_sync "Push failed - $COMMIT_MSG"
                    exit 1
                fi
            else
                echo "❌ Failed to create sync commit"
                exit 1
            fi
            
        else
            echo "🖥️  Desktop push not implemented"
            echo "   Use: git push origin main"
        fi
        
        ;;
        
    "pull")
        echo "📥 Pulling Changes from Remote"
        echo "============================="
        
        if [ "$IS_TERMUX" = true ]; then
            echo "📱 Pulling to Termux..."
            
            # Check for uncommitted changes
            if ! check_git_status; then
                echo "💾 Auto-committing local changes..."
                create_sync_commit "Auto-commit before pull - $(date '+%Y-%m-%d %H:%M')"
            fi
            
            # Pull from main branch
            git pull origin main
            
            if [ $? -eq 0 ]; then
                echo "✅ Pull completed successfully"
                log_sync "Pull completed from main branch"
            else
                echo "⚠️  Pull completed with conflicts"
                echo "🔧 Resolve conflicts and run: git commit"
                log_sync "Pull completed with conflicts"
            fi
            
        else
            echo "🖥️  Pulling to desktop..."
            
            # Switch to mobile branch and pull
            CURRENT_BRANCH=$(git branch --show-current)
            git checkout $MOBILE_BRANCH
            git pull origin $MOBILE_BRANCH
            
            # Show changes
            echo "📋 Changes from mobile:"
            git diff --name-status main..$MOBILE_BRANCH
            
            echo ""
            echo "🔄 To merge mobile changes:"
            echo "   git checkout main"
            echo "   git merge $MOBILE_BRANCH"
            echo "   git push origin main"
            
            # Switch back to original branch
            git checkout $CURRENT_BRANCH
            
            log_sync "Desktop pull completed"
        fi
        
        ;;
        
    "status")
        echo "📊 Mobile-Desktop Sync Status"
        echo "============================="
        
        # Show environment
        echo "🔧 Environment: $ENVIRONMENT"
        
        # Show sync config
        if [ -f "$SYNC_CONFIG_FILE" ]; then
            echo ""
            echo "⚙️  Sync Configuration:"
            cat $SYNC_CONFIG_FILE | sed 's/^/   /'
        fi
        
        # Show git status
        if [ -d ".git" ]; then
            echo ""
            echo "🌿 Git Status:"
            echo "   Current branch: $(git branch --show-current)"
            echo "   Uncommitted changes: $(git status --porcelain | wc -l)"
            echo "   Last commit: $(git log -1 --format='%cr' 2>/dev/null || echo 'N/A')"
            
            # Show branch relationship
            if git rev-parse --verify $MOBILE_BRANCH &>/dev/null; then
                echo "   Mobile branch: $MOBILE_BRANCH"
                AHEAD=$(git rev-list --count main..$MOBILE_BRANCH 2>/dev/null || echo "0")
                BEHIND=$(git rev-list --count $MOBILE_BRANCH..main 2>/dev/null || echo "0")
                echo "   Mobile ahead: $AHEAD commits"
                echo "   Mobile behind: $BEHIND commits"
            fi
        fi
        
        # Show recent sync activity
        if [ -f "$SYNC_LOG_FILE" ]; then
            echo ""
            echo "📝 Recent Sync Activity:"
            tail -5 $SYNC_LOG_FILE | sed 's/^/   /'
        fi
        
        # Show network connectivity
        if [ "$IS_TERMUX" = true ]; then
            echo ""
            echo "🌐 Network Status:"
            if ping -c 1 github.com &> /dev/null; then
                echo "   GitHub connectivity: ✅ OK"
            else
                echo "   GitHub connectivity: ❌ Failed"
            fi
        fi
        
        ;;
        
    "test")
        echo "🧪 Testing Mobile-Desktop Sync"
        echo "=============================="
        
        echo "🔧 Environment: $ENVIRONMENT"
        
        # Test git
        if [ -d ".git" ]; then
            echo "✅ Git repository: OK"
        else
            echo "❌ Git repository: Missing"
            exit 1
        fi
        
        # Test network
        if ping -c 1 github.com &> /dev/null; then
            echo "✅ Network connectivity: OK"
        else
            echo "❌ Network connectivity: Failed"
            exit 1
        fi
        
        # Test git remote
        if git remote get-url origin &> /dev/null; then
            echo "✅ Git remote: OK"
            echo "   Remote URL: $(git remote get-url origin)"
        else
            echo "❌ Git remote: Missing"
            exit 1
        fi
        
        # Test SSH (if on Termux)
        if [ "$IS_TERMUX" = true ]; then
            if [ -f ~/.ssh/id_ed25519 ]; then
                echo "✅ SSH key: Available"
            else
                echo "⚠️  SSH key: Missing (run setup)"
            fi
        fi
        
        # Test sync configuration
        if [ -f "$SYNC_CONFIG_FILE" ]; then
            echo "✅ Sync config: Available"
        else
            echo "⚠️  Sync config: Missing (run setup)"
        fi
        
        echo ""
        echo "🎯 Test completed!"
        
        ;;
        
    "conflicts")
        echo "🔧 Resolving Sync Conflicts"
        echo "=========================="
        
        # Show current conflicts
        if git status --porcelain | grep "^UU"; then
            echo "⚠️  Merge conflicts detected:"
            git status --porcelain | grep "^UU"
            
            echo ""
            echo "🛠️  Resolution steps:"
            echo "   1. Edit conflicted files"
            echo "   2. git add <resolved-files>"
            echo "   3. git commit -m 'Resolve sync conflicts'"
            echo "   4. ./scripts/sync-mobile-work.sh push"
            
        else
            echo "✅ No merge conflicts detected"
        fi
        
        ;;
        
    "clean")
        echo "🧹 Cleaning Sync Environment"
        echo "==========================="
        
        # Clean sync logs
        if [ -f "$SYNC_LOG_FILE" ]; then
            echo "📝 Cleaning sync logs..."
            > $SYNC_LOG_FILE
        fi
        
        # Clean git
        echo "🔧 Cleaning git repository..."
        git clean -fdx
        git gc --aggressive
        
        # Clean temporary files
        rm -rf .tmp-sync/
        
        echo "✅ Sync environment cleaned"
        
        ;;
        
    *)
        echo "❌ Unknown command: $ACTION"
        echo "Usage: $0 [setup|push|pull|status|test|conflicts|clean]"
        echo ""
        echo "Commands:"
        echo "  setup     - Setup mobile-desktop synchronization"
        echo "  push      - Push mobile work to desktop"
        echo "  pull      - Pull changes from remote"
        echo "  status    - Show sync status"
        echo "  test      - Test sync environment"
        echo "  conflicts - Help resolve merge conflicts"
        echo "  clean     - Clean sync environment"
        exit 1
        ;;
esac