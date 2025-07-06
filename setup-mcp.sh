#!/bin/bash

# MCP Server Setup Script for Wedding Game Project
# This script installs and configures MCP servers for enhanced AI development

echo "Setting up MCP servers for Wedding Game project..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is required but not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "npm is required but not installed. Please install npm first."
    exit 1
fi

echo "Installing MCP servers..."

# Install file system server
echo "Installing file-system MCP server..."
npx -y @modelcontextprotocol/server-filesystem --help > /dev/null 2>&1

# Install git server
echo "Installing git MCP server..."
npx -y @modelcontextprotocol/server-git --help > /dev/null 2>&1

# Install puppeteer server
echo "Installing puppeteer MCP server..."
npx -y @modelcontextprotocol/server-puppeteer --help > /dev/null 2>&1

echo "MCP server setup complete!"
echo ""
echo "Available MCP servers:"
echo "- file-system: File system operations and project navigation"
echo "- git: Git operations and version control"
echo "- puppeteer: Web automation for research and testing"
echo ""
echo "Configuration files:"
echo "- mcp-config.json: Full configuration with available servers"
echo "- mcp-config-practical.json: Practical configuration (same as full config)"
echo ""
echo "To use these servers, configure your AI client with the appropriate MCP configuration."
echo ""
echo "Note: For Godot-specific tools, consider using existing Godot MCP servers"
echo "or integrating with Godot's built-in tools and APIs." 