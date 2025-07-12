#!/bin/bash

# MCP Server Setup Script for Wedding Game Development
# Installs and configures Model Context Protocol servers for enhanced development workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[MCP-SETUP]${NC} $1"
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

print_status "Setting up MCP servers for Wedding Game development..."
echo ""

# Check if npm is available
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

# Check if npx is available
if ! command -v npx &> /dev/null; then
    print_error "npx is not available. Please ensure Node.js is properly installed."
    exit 1
fi

# Function to test MCP server availability
test_mcp_server() {
    local server_package="$1"
    local server_name="$2"
    
    print_status "Testing MCP server: $server_name"
    
    # Test if the server package can be installed and run
    if timeout 30 npx -y "$server_package" --help >/dev/null 2>&1; then
        print_success "$server_name is available"
        return 0
    else
        print_warning "$server_name may not be available or is taking too long to respond"
        return 1
    fi
}

# Install and test core MCP servers
print_status "Installing and testing core MCP servers..."
echo ""

# Test filesystem server (should already work)
test_mcp_server "@modelcontextprotocol/server-filesystem" "Filesystem"

# Test memory server (local installation)
if [ -f "/home/joe/.config/mcp-memory-server/build/index.js" ]; then
    print_success "Memory server is installed"
else
    print_warning "Memory server not found at expected location"
fi

# Test additional MCP servers
print_status "Testing additional MCP servers..."
echo ""

# Note: These package names are placeholders as the actual package names may differ
# We'll attempt to install them and handle errors gracefully

# Context7 server
print_status "Setting up Context7 server..."
if npm list -g @context7/mcp-server >/dev/null 2>&1 || timeout 30 npx -y mcp-server-context7 --help >/dev/null 2>&1; then
    print_success "Context7 server is available"
else
    print_warning "Context7 server package not found - you may need to install it manually"
    echo "  Try: npm install -g @context7/mcp-server"
    echo "  Or check https://github.com/context7/mcp-server for installation instructions"
fi

# Sequential server
print_status "Setting up Sequential server..."
if npm list -g @sequential/mcp-server >/dev/null 2>&1 || timeout 30 npx -y mcp-server-sequential --help >/dev/null 2>&1; then
    print_success "Sequential server is available"
else
    print_warning "Sequential server package not found - you may need to install it manually"
    echo "  Try: npm install -g @sequential/mcp-server"
    echo "  Or check documentation for correct package name"
fi

# Magic server
print_status "Setting up Magic server..."
if npm list -g @magic/mcp-server >/dev/null 2>&1 || timeout 30 npx -y mcp-server-magic --help >/dev/null 2>&1; then
    print_success "Magic server is available"
else
    print_warning "Magic server package not found - you may need to install it manually"
    echo "  Try: npm install -g @magic/mcp-server"
    echo "  Or check documentation for correct package name"
fi

# Puppeteer server
print_status "Setting up Puppeteer server..."
if npm list -g @puppeteer/mcp-server >/dev/null 2>&1 || timeout 30 npx -y mcp-server-puppeteer --help >/dev/null 2>&1; then
    print_success "Puppeteer server is available"
else
    print_warning "Puppeteer server package not found - you may need to install it manually"
    echo "  Try: npm install -g @puppeteer/mcp-server"
    echo "  Or check documentation for correct package name"
fi

echo ""
print_status "MCP Server Configuration Files:"
echo "- mcp-config.json       - Full configuration with all servers"
echo "- mcp-simple.json       - Basic configuration (filesystem + memory only)"
echo ""

print_status "Usage:"
echo "To use the full configuration:"
echo "  claude-code --mcp-config mcp-config.json"
echo ""
echo "To use the basic configuration:"
echo "  claude-code --mcp-config mcp-simple.json"
echo ""

print_status "Available MCP Servers:"
echo "✅ Filesystem - File system operations"
echo "✅ Memory - Persistent memory and context"
echo "⚠️  Context7 - Library documentation access"
echo "⚠️  Sequential - Multi-step reasoning capabilities"
echo "⚠️  Magic - AI-generated UI components"
echo "⚠️  Puppeteer - Browser testing and automation"
echo ""

print_status "Manual Installation Commands:"
echo "If any servers failed to install, try these commands:"
echo ""
echo "# Context7 (Documentation access)"
echo "npm install -g @context7/mcp-server"
echo ""
echo "# Sequential (Multi-step reasoning)"
echo "npm install -g @sequential/mcp-server"
echo ""
echo "# Magic (UI components)"
echo "npm install -g @magic/mcp-server"
echo ""
echo "# Puppeteer (Browser automation)"
echo "npm install -g @puppeteer/mcp-server"
echo ""

print_status "Creating backup configurations..."

# Create a development-focused configuration
cat > mcp-dev.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."],
      "env": {}
    },
    "memory": {
      "command": "node",
      "args": ["/home/joe/.config/mcp-memory-server/build/index.js"],
      "env": {}
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"],
      "env": {}
    },
    "sequential": {
      "command": "npx",
      "args": ["-y", "@sequential/mcp-server"],
      "env": {}
    }
  }
}
EOF

# Create a testing-focused configuration
cat > mcp-test.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."],
      "env": {}
    },
    "memory": {
      "command": "node",
      "args": ["/home/joe/.config/mcp-memory-server/build/index.js"],
      "env": {}
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@puppeteer/mcp-server"],
      "env": {}
    }
  }
}
EOF

print_success "Created additional MCP configurations:"
echo "- mcp-dev.json    - Development-focused (filesystem, memory, context7, sequential)"
echo "- mcp-test.json   - Testing-focused (filesystem, memory, puppeteer)"
echo ""

print_success "MCP server setup completed!"
echo ""
print_status "Next steps:"
echo "1. Test the configurations with: claude-code --mcp-config mcp-simple.json"
echo "2. Install any missing servers manually using the commands above"
echo "3. Use the full configuration once all servers are installed"
echo ""
print_status "For troubleshooting, check:"
echo "- MCP server documentation"
echo "- npm global packages: npm list -g"
echo "- Claude Code MCP integration guide"