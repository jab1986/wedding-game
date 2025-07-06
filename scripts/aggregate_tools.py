#!/usr/bin/env python3
"""
MCP Tools Aggregator - Overflow Handler
This handles tools beyond Cursor's 40 tool limit by providing the "overflow" tools
"""

import json
import sys
import subprocess
import os
from pathlib import Path

class MCPOverflowAggregator:
    def __init__(self, config_file: str = "mcp-config-minimal.json"):
        self.config_file = config_file
        # Define which tools to EXCLUDE (these will be handled directly by Cursor)
        # Keep the most commonly used tools in Cursor's direct MCP setup
        self.cursor_direct_tools = [
            # File system essentials - handle directly in Cursor
            "file-system_read_file",
            "file-system_write_file", 
            "file-system_edit_file",
            "file-system_list_directory",
            "file-system_create_directory",
            "file-system_search_files",
            "file-system_move_file",
            "file-system_get_file_info",
            
            # GitHub essentials - handle directly in Cursor
            "github_create_or_update_file",
            "github_search_repositories",
            "github_create_repository",
            "github_get_file_contents",
            "github_push_files",
            "github_create_issue",
            "github_create_pull_request",
            "github_fork_repository",
            
            # Browser essentials - handle directly in Cursor
            "puppeteer_puppeteer_navigate",
            "puppeteer_puppeteer_screenshot",
            "puppeteer_puppeteer_click",
            "puppeteer_puppeteer_fill",
            "puppeteer_puppeteer_evaluate",
        ]
        
    def run_as_server(self):
        """Run this script as an MCP server that provides overflow tools."""
        for line in sys.stdin:
            try:
                request = json.loads(line.strip())
                
                if request.get("method") == "initialize":
                    response = {
                        "jsonrpc": "2.0",
                        "id": request.get("id"),
                        "result": {
                            "protocolVersion": "2024-11-05",
                            "capabilities": {
                                "tools": {},
                                "resources": {}
                            },
                            "serverInfo": {
                                "name": "mcp-overflow-aggregator",
                                "version": "1.0.0"
                            }
                        }
                    }
                    print(json.dumps(response), flush=True)
                    
                elif request.get("method") == "tools/list":
                    tools = self.get_overflow_tools()
                    response = {
                        "jsonrpc": "2.0",
                        "id": request.get("id"),
                        "result": {
                            "tools": tools
                        }
                    }
                    print(json.dumps(response), flush=True)
                
                elif request.get("method") == "tools/call":
                    # Route tool calls to appropriate servers
                    result = self.route_tool_call(request.get("params", {}))
                    response = {
                        "jsonrpc": "2.0",
                        "id": request.get("id"),
                        "result": result
                    }
                    print(json.dumps(response), flush=True)
                    
            except json.JSONDecodeError:
                continue
            except Exception as e:
                error_response = {
                    "jsonrpc": "2.0",
                    "id": request.get("id", 1),
                    "error": {
                        "code": -32603,
                        "message": str(e)
                    }
                }
                print(json.dumps(error_response), flush=True)

    def get_overflow_tools(self):
        """Get only the overflow tools (not handled by Cursor directly)."""
        config = self.load_config()
        all_tools = []
        
        # Get tools from each server
        for server_name, server_config in config.get("mcpServers", {}).items():
            tools = self.get_server_tools(server_name, server_config)
            for tool in tools:
                tool["name"] = f"{server_name}_{tool['name']}"
                all_tools.append(tool)
        
        # Filter OUT the tools that Cursor handles directly
        overflow_tools = [tool for tool in all_tools if tool["name"] not in self.cursor_direct_tools]
        
        return overflow_tools
    
    def get_server_tools(self, server_name: str, server_config: dict):
        """Get tools from a specific server."""
        try:
            # Start server process
            command = server_config.get('command', '')
            args = server_config.get('args', [])
            env = server_config.get('env', {})
            
            server_env = os.environ.copy()
            server_env.update(env)
            
            process = subprocess.Popen(
                [command] + args,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                stdin=subprocess.PIPE,
                env=server_env,
                text=True
            )
            
            # Initialize server
            init_request = {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {
                        "roots": {"listChanged": True},
                        "sampling": {}
                    },
                    "clientInfo": {
                        "name": "cursor-mcp-overflow",
                        "version": "1.0.0"
                    }
                }
            }
            
            process.stdin.write(json.dumps(init_request) + "\n")
            process.stdin.flush()
            
            # Read init response
            init_response = process.stdout.readline()
            
            # Get tools
            tools_request = {
                "jsonrpc": "2.0",
                "id": 2,
                "method": "tools/list"
            }
            
            process.stdin.write(json.dumps(tools_request) + "\n")
            process.stdin.flush()
            
            tools_response = process.stdout.readline()
            
            # Clean up
            process.terminate()
            process.wait()
            
            if tools_response:
                tools_data = json.loads(tools_response.strip())
                return tools_data.get("result", {}).get("tools", [])
            
        except Exception as e:
            print(f"Error getting tools from {server_name}: {e}", file=sys.stderr)
            
        return []
    
    def route_tool_call(self, params: dict):
        """Route tool call to appropriate server."""
        tool_name = params.get("name", "")
        if "_" not in tool_name:
            raise Exception(f"Invalid tool name: {tool_name}")
        
        server_name, actual_tool_name = tool_name.split("_", 1)
        
        # Load config and get server config
        config = self.load_config()
        server_config = config.get("mcpServers", {}).get(server_name)
        
        if not server_config:
            raise Exception(f"Server {server_name} not found")
        
        # Start server and make the call
        command = server_config.get('command', '')
        args = server_config.get('args', [])
        env = server_config.get('env', {})
        
        server_env = os.environ.copy()
        server_env.update(env)
        
        process = subprocess.Popen(
            [command] + args,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            stdin=subprocess.PIPE,
            env=server_env,
            text=True
        )
        
        try:
            # Initialize
            init_request = {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {
                        "roots": {"listChanged": True},
                        "sampling": {}
                    },
                    "clientInfo": {
                        "name": "cursor-mcp-overflow",
                        "version": "1.0.0"
                    }
                }
            }
            
            process.stdin.write(json.dumps(init_request) + "\n")
            process.stdin.flush()
            
            # Read init response
            init_response = process.stdout.readline()
            
            # Make the actual tool call
            tool_call_request = {
                "jsonrpc": "2.0",
                "id": 2,
                "method": "tools/call",
                "params": {
                    "name": actual_tool_name,
                    "arguments": params.get("arguments", {})
                }
            }
            
            process.stdin.write(json.dumps(tool_call_request) + "\n")
            process.stdin.flush()
            
            # Read response
            response = process.stdout.readline()
            
            if response:
                response_data = json.loads(response.strip())
                return response_data.get("result", {})
            
        finally:
            process.terminate()
            process.wait()
        
        return {"content": [{"type": "text", "text": "No response from server"}]}
    
    def load_config(self):
        """Load MCP server configuration."""
        config_path = Path(self.config_file)
        if not config_path.exists():
            raise FileNotFoundError(f"MCP config file not found: {config_path}")
        
        with open(config_path, 'r') as f:
            return json.load(f)

def main():
    """Main entry point."""
    aggregator = MCPOverflowAggregator()
    
    # If --test flag is passed, show available tools
    if len(sys.argv) > 1 and sys.argv[1] == "--test":
        try:
            overflow_tools = aggregator.get_overflow_tools()
            print(f"Overflow tools available: {len(overflow_tools)}")
            for tool in overflow_tools:
                print(f"  - {tool['name']}: {tool.get('description', 'No description')}")
        except Exception as e:
            print(f"Error testing aggregator: {e}")
        return
    
    aggregator.run_as_server()

if __name__ == "__main__":
    main()