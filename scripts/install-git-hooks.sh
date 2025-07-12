#!/bin/bash

# Install Git Hooks for Wedding Game Development
# Sets up pre-commit hooks and other Git automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INSTALL]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

print_status "Installing Git hooks for Wedding Game development..."
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a Git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .githooks

# Configure Git to use custom hooks directory
print_status "Configuring Git hooks directory..."
git config core.hooksPath .githooks

# Make hooks executable
print_status "Making hooks executable..."
find .githooks -type f -exec chmod +x {} \;

# Check if hooks are properly configured
if [ -f ".githooks/pre-commit" ]; then
    print_success "Pre-commit hook installed"
else
    print_error "Pre-commit hook not found at .githooks/pre-commit"
    exit 1
fi

# Test the pre-commit hook
print_status "Testing pre-commit hook..."
if .githooks/pre-commit --version >/dev/null 2>&1 || .githooks/pre-commit --help >/dev/null 2>&1; then
    print_success "Pre-commit hook test passed"
else
    print_warning "Pre-commit hook test skipped (normal for first install)"
fi

# Create a commit template
print_status "Creating commit template..."
cat > .gitmessage << 'EOF'
# Wedding Game Commit Template
# 
# Format: type(scope): description
# 
# Types:
#   feat: New feature (game mechanics, levels, characters)
#   fix: Bug fix
#   docs: Documentation changes
#   style: Code style changes (formatting, etc.)
#   refactor: Code refactoring
#   test: Adding or modifying tests
#   chore: Maintenance tasks
#   art: Art assets (sprites, audio, etc.)
#   dialogue: Dialogue content changes
#
# Scopes:
#   gameplay: Game mechanics and rules
#   audio: Sound effects and music
#   graphics: Sprites and visual effects
#   dialogue: Character dialogue system
#   ui: User interface
#   level: Level design and progression
#   character: Character systems
#   system: Core game systems
#
# Example:
#   feat(gameplay): add new character special attacks
#   fix(audio): resolve audio manager volume issues
#   art(graphics): update Mark character sprite animations
#   dialogue(character): add Glen's wedding dialogue
#
# Remember:
# - Keep description under 50 characters
# - Use present tense ("add" not "added")
# - Don't end with a period
# - Include more details in the body if needed
EOF

# Configure Git to use the commit template
git config commit.template .gitmessage

# Create additional helpful Git configurations
print_status "Configuring Git settings..."

# Set up useful Git aliases
git config alias.st status
git config alias.co checkout
git config alias.br branch
git config alias.ci commit
git config alias.unstage 'reset HEAD --'
git config alias.last 'log -1 HEAD'
git config alias.visual '!gitk'
git config alias.qa '!./scripts/dev-qa-tools.sh all'
git config alias.hooks '!./scripts/install-git-hooks.sh'

# Configure useful settings
git config push.default simple
git config pull.rebase false
git config init.defaultBranch main

# Create ignore file for development artifacts
print_status "Creating .gitignore entries..."
cat >> .gitignore << 'EOF'

# Development artifacts
reports/
*.log
*.tmp
*.temp
*.cache
.project_discovered

# IDE files
.vscode/settings.json
.idea/

# OS files
.DS_Store
Thumbs.db
EOF

print_success "Git hooks and configuration installed successfully!"
echo ""

print_status "Git Configuration Summary:"
echo "- Custom hooks directory: .githooks"
echo "- Pre-commit hook: Quality assurance checks"
echo "- Commit template: .gitmessage"
echo "- Useful aliases: st, co, br, ci, unstage, last, visual, qa, hooks"
echo ""

print_status "Usage:"
echo "- git qa                    # Run quality assurance checks"
echo "- git hooks                 # Reinstall hooks"
echo "- git ci                    # Commit with template"
echo "- git st                    # Status"
echo ""

print_success "Ready for development with quality assurance!"