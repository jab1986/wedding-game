# Wedding Game - Installation Guide

## Quick Install

```bash
# Clone repository
git clone https://github.com/jab1986/wedding-game.git
cd wedding-game

# Run setup script
./setup.sh

# Start development
make dev
```

## Prerequisites

### Required Software
- **Node.js** (v16+): [Download](https://nodejs.org/)
- **Python 3** (3.8+): [Download](https://python.org/)
- **Git**: [Download](https://git-scm.com/)
- **Cursor Editor**: [Download](https://cursor.sh/) (for full MCP integration)

### Optional Software
- **Termux** (Android): For mobile development
- **Docker**: For containerized development
- **VS Code**: Alternative editor (limited MCP support)

## Step-by-Step Installation

### 1. System Prerequisites

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y nodejs npm python3 python3-pip git curl
```

**macOS:**
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install prerequisites
brew install node python git
```

**Windows:**
```powershell
# Install via Chocolatey
choco install nodejs python git

# Or download installers from official websites
```

### 2. Clone Repository

```bash
git clone https://github.com/jab1986/wedding-game.git
cd wedding-game
```

### 3. Environment Setup

```bash
# Copy environment template
cp example.env.txt .env

# Edit with your API keys
nano .env  # or vim .env
```

**Required API Keys:**
- `TAVILY_API_KEY`: For web search capabilities
- `GITHUB_TOKEN`: For GitHub integration
- `OPENAI_API_KEY`: For AI features (optional)

### 4. Install Dependencies

**Automatic (Recommended):**
```bash
./setup.sh
```

**Manual:**
```bash
# Install Node.js dependencies
npm install

# Install Python dependencies
python3 -m pip install -r requirements.txt

# Install MCP servers
./setup-mcp.sh
```

### 5. Configure Cursor (Recommended)

**Global MCP Configuration:**

Edit `/home/joe/.cursor/mcp.json` (Linux/macOS) or `%APPDATA%\Cursor\mcp.json` (Windows):

```json
{
  "mcpServers": {
    "file-system": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/wedding-game"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    },
    "overflow-aggregator": {
      "command": "python3",
      "args": ["/path/to/wedding-game/scripts/aggregate_tools.py"],
      "env": {
        "MCP_CONFIG_FILE": "/path/to/wedding-game/mcp-config-minimal.json"
      }
    }
  }
}
```

Replace `/path/to/wedding-game` with your actual project path.

### 6. Verify Installation

```bash
# Test MCP configuration
python3 scripts/aggregate_tools.py --test

# Check development environment
make env-check

# Start development session
make dev
```

## Mobile Development Setup (Optional)

### Android (Termux)

1. **Install Termux:**
   - Download from [F-Droid](https://f-droid.org/en/packages/com.termux/)
   - Avoid Google Play version (limited functionality)

2. **Setup Mobile Environment:**
   ```bash
   # In Termux
   pkg update && pkg upgrade
   pkg install git python nodejs openssh nano
   
   # Clone project
   git clone https://github.com/jab1986/wedding-game.git
   cd wedding-game
   
   # Setup mobile development
   ./scripts/mobile-dev-session.sh setup
   ```

3. **Configure SSH for Sync:**
   ```bash
   # Generate SSH key in Termux
   ssh-keygen -t ed25519 -C "mobile-dev@termux"
   
   # Copy public key to desktop
   cat ~/.ssh/id_ed25519.pub
   # Add to desktop's ~/.ssh/authorized_keys
   ```

## Alternative Installation Methods

### Docker Installation

```bash
# Build development container
docker build -t wedding-game-dev .

# Run development environment
docker run -it -v $(pwd):/workspace wedding-game-dev
```

### Package Manager Installation

**npm (Node.js package):**
```bash
npm install -g wedding-game-dev-tools
wedding-game-init
```

**pip (Python package):**
```bash
pip install wedding-game-dev-tools
wedding-game-setup
```

## Troubleshooting

### Common Issues

**1. Node.js Version Issues:**
```bash
# Use Node Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

**2. Python Path Issues:**
```bash
# Check Python installation
which python3
python3 --version

# Create virtual environment (optional)
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate  # Windows
```

**3. MCP Server Connection Issues:**
```bash
# Test individual servers
npx -y @modelcontextprotocol/server-filesystem --help
npx -y @modelcontextprotocol/server-github --help

# Check aggregator
python3 scripts/aggregate_tools.py --debug
```

**4. Permission Issues (Linux/macOS):**
```bash
# Make scripts executable
chmod +x setup.sh
chmod +x scripts/*.sh

# Fix npm permissions (if needed)
sudo chown -R $(whoami) ~/.npm
```

**5. Windows Path Issues:**
```powershell
# Use Git Bash or WSL for better compatibility
# Or ensure Python and Node.js are in PATH
```

### Getting Help

1. **Check Documentation:**
   - `README-DEVELOPMENT.md`: Complete development guide
   - `QUICK-REFERENCE.md`: Command reference
   - `docs/`: Detailed setup guides

2. **Run Diagnostics:**
   ```bash
   make env-check
   make debug-mcp
   ./scripts/dev-session-manager.sh status
   ```

3. **Common Commands:**
   ```bash
   make help          # Show all available commands
   make test          # Test installation
   make clean         # Clean temporary files
   make backup        # Create project backup
   ```

## Verification Checklist

After installation, verify these components work:

- [ ] Node.js and npm installed and accessible
- [ ] Python 3 and pip installed and accessible
- [ ] Git installed and configured
- [ ] Environment file (.env) created with API keys
- [ ] MCP servers installed and accessible
- [ ] MCP aggregator test passes
- [ ] Cursor MCP configuration active (if using Cursor)
- [ ] Development session starts successfully
- [ ] Mobile development setup (if using mobile)

## Next Steps

1. **Read Documentation:**
   - `README-DEVELOPMENT.md` for development workflow
   - `QUICK-REFERENCE.md` for daily commands

2. **Start Development:**
   ```bash
   make dev                    # Start development session
   ./scripts/dev-session-manager.sh start
   ```

3. **Test Mobile Development (if applicable):**
   ```bash
   ./scripts/mobile-dev-session.sh start
   ./scripts/sync-mobile-work.sh test
   ```

4. **Begin Coding:**
   - Open project in Cursor for full MCP integration
   - Start with character implementation
   - Use AI assistance for code generation

---

**Installation successful!** 🎉

Your AI-augmented wedding game development environment is ready. Happy coding!