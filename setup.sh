#!/bin/bash
# Wedding Game - Complete Development Environment Setup
# Sets up the entire AI-augmented development stack

set -e

echo "🎮 Wedding Game - Development Environment Setup"
echo "=============================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check prerequisites
echo "📋 Checking Prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is required but not installed"
    echo "Please install Node.js from: https://nodejs.org/"
    exit 1
fi
print_status "Node.js found: $(node --version)"

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm is required but not installed"
    exit 1
fi
print_status "npm found: $(npm --version)"

# Check Python
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is required but not installed"
    exit 1
fi
print_status "Python 3 found: $(python3 --version)"

# Check Git
if ! command -v git &> /dev/null; then
    print_error "Git is required but not installed"
    exit 1
fi
print_status "Git found: $(git --version)"

# Check if we're in the project directory
if [ ! -f "project.godot" ] && [ ! -f "README-DEVELOPMENT.md" ]; then
    print_warning "Not in wedding-game project directory"
    echo "Please run this script from the wedding-game project root"
    exit 1
fi

# Setup environment file
echo ""
echo "⚙️  Setting up environment configuration..."

if [ ! -f ".env" ]; then
    if [ -f "example.env.txt" ]; then
        cp example.env.txt .env
        print_status "Created .env file from example"
        print_warning "Please edit .env file with your API keys"
    else
        print_error "example.env.txt not found"
        exit 1
    fi
else
    print_status "Environment file already exists"
fi

# Install MCP servers
echo ""
echo "🔧 Installing MCP Servers..."

# Core MCP servers for Cursor direct access
echo "Installing core MCP servers..."
npx -y @modelcontextprotocol/server-filesystem --help > /dev/null 2>&1 &
npx -y @modelcontextprotocol/server-github --help > /dev/null 2>&1 &
npx -y @modelcontextprotocol/server-puppeteer --help > /dev/null 2>&1 &

# Overflow MCP servers (minimal working set)
echo "Installing overflow MCP servers..."
npx -y @modelcontextprotocol/server-memory --help > /dev/null 2>&1 &
npx -y @modelcontextprotocol/server-sequential-thinking --help > /dev/null 2>&1 &
npx -y @modelcontextprotocol/server-everything --help > /dev/null 2>&1 &

wait
print_status "MCP servers installed"

# Setup Python dependencies
echo ""
echo "🐍 Setting up Python environment..."

if [ -f "requirements.txt" ]; then
    python3 -m pip install -r requirements.txt
    print_status "Python dependencies installed"
else
    print_info "No requirements.txt found, creating minimal requirements"
    cat > requirements.txt << 'EOF'
# Wedding Game Development Dependencies
python-dotenv>=1.0.0
requests>=2.28.0
GitPython>=3.1.0
pathlib>=1.0.1
EOF
    python3 -m pip install -r requirements.txt
    print_status "Created and installed minimal Python requirements"
fi

# Setup directory structure
echo ""
echo "📁 Setting up project structure..."

# Create essential directories if they don't exist
mkdir -p .claude logs temp backups
mkdir -p scripts/mobile scripts/desktop scripts/common

print_status "Project structure created"

# Setup git hooks (optional)
echo ""
echo "🪝 Setting up git hooks..."

if [ -d ".git" ]; then
    # Create pre-commit hook to prevent API key commits
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Prevent committing files with API keys

if git diff --cached --name-only | xargs grep -l "ghp_\|sk-\|AKIA\|glpat-" 2>/dev/null; then
    echo "❌ Error: API keys detected in staged files!"
    echo "Please remove API keys before committing."
    exit 1
fi
EOF
    chmod +x .git/hooks/pre-commit
    print_status "Git pre-commit hook installed"
else
    print_warning "Not a git repository, skipping git hooks"
fi

# Setup Cursor configuration
echo ""
echo "🎯 Setting up Cursor integration..."

CURSOR_MCP_FILE="/home/joe/.cursor/mcp.json"
if [ -f "$CURSOR_MCP_FILE" ]; then
    print_status "Cursor MCP configuration already exists"
else
    print_warning "Cursor MCP configuration not found"
    echo "Please manually configure Cursor MCP settings"
fi

# Test MCP aggregator
echo ""
echo "🧪 Testing MCP configuration..."

if [ -f "scripts/aggregate_tools.py" ]; then
    if python3 scripts/aggregate_tools.py --test > /dev/null 2>&1; then
        TOOL_COUNT=$(python3 scripts/aggregate_tools.py --test 2>/dev/null | grep "Overflow tools available" | grep -o '[0-9]\+' || echo "0")
        print_status "MCP aggregator working: $TOOL_COUNT overflow tools available"
    else
        print_warning "MCP aggregator test failed - will work when Cursor is running"
    fi
else
    print_error "MCP aggregator script not found"
    exit 1
fi

# Make scripts executable
echo ""
echo "🔨 Setting script permissions..."

chmod +x scripts/*.sh 2>/dev/null || true
chmod +x setup-mcp.sh 2>/dev/null || true

print_status "Script permissions set"

# Final setup steps
echo ""
echo "🎊 Setup Complete!"
echo "=================="
echo ""
echo "✨ Your AI-augmented wedding game development environment is ready!"
echo ""
echo "📋 Next Steps:"
echo "1. Edit .env file with your API keys"
echo "2. Start development session: ./scripts/dev-session-manager.sh start"
echo "3. Open project in Cursor for full MCP integration"
echo "4. Begin development with AI assistance"
echo ""
echo "📚 Documentation:"
echo "- README-DEVELOPMENT.md: Complete development guide"
echo "- QUICK-REFERENCE.md: Command reference"
echo "- docs/: Detailed setup and workflow guides"
echo ""
echo "🔧 Available Tools:"
echo "- Session management: ./scripts/dev-session-manager.sh [start|end|status]"
echo "- Mobile development: ./scripts/mobile-dev-session.sh [start|setup]"
echo "- Mobile sync: ./scripts/sync-mobile-work.sh [push|pull]"
echo "- MCP testing: python3 scripts/aggregate_tools.py --test"
echo ""
echo "Happy coding! 🚀"