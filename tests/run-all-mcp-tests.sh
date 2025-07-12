#!/bin/bash

# Comprehensive MCP Test Runner
# Runs all MCP-related tests and generates consolidated report

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[MCP-TEST]${NC} $1"
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

print_status "Starting comprehensive MCP test suite..."
echo ""

# Create reports directory
mkdir -p reports

# Track test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to run a test script
run_test_script() {
    local test_name="$1"
    local test_script="$2"
    local test_args="${3:-}"
    
    print_status "Running $test_name..."
    
    if [ -f "$test_script" ]; then
        if [ -x "$test_script" ]; then
            if $test_script $test_args; then
                print_success "$test_name completed successfully"
                return 0
            else
                print_error "$test_name failed"
                return 1
            fi
        else
            print_error "$test_script is not executable"
            return 1
        fi
    else
        print_error "$test_script not found"
        return 1
    fi
}

# Run configuration tests
print_status "Phase 1: Configuration and Setup Tests"
echo "========================================"

# Test MCP configuration files
print_status "Testing MCP configuration files..."
if [ -f "mcp-config.json" ] && [ -f "mcp-simple.json" ]; then
    print_success "Configuration files found"
    ((PASSED_TESTS++))
else
    print_error "Missing configuration files"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

# Test setup script
print_status "Testing MCP setup script..."
if [ -f "scripts/setup-mcp-servers.sh" ] && [ -x "scripts/setup-mcp-servers.sh" ]; then
    print_success "Setup script is available and executable"
    ((PASSED_TESTS++))
else
    print_error "Setup script not found or not executable"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

echo ""

# Run main test suites
print_status "Phase 2: Core MCP Tests"
echo "========================"

# Run configuration validation tests
if run_test_script "Configuration Tests" "node tests/mcp-server-tests.js"; then
    ((PASSED_TESTS++))
else
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

# Run functional tests
if run_test_script "Functional Tests" "node tests/mcp-functional-tests.js"; then
    ((PASSED_TESTS++))
else
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

echo ""

# Run integration tests
print_status "Phase 3: Integration Tests"
echo "=========================="

# Test Claude Code integration
print_status "Testing Claude Code with MCP configuration..."
if claude-code --mcp-config mcp-simple.json --help >/dev/null 2>&1; then
    print_success "Claude Code MCP integration works"
    ((PASSED_TESTS++))
else
    print_warning "Claude Code MCP integration test failed (may be expected)"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

# Test package availability
print_status "Testing package availability..."
if command -v npm >/dev/null 2>&1 && command -v npx >/dev/null 2>&1; then
    print_success "Package managers available"
    ((PASSED_TESTS++))
else
    print_error "Package managers not available"
    ((FAILED_TESTS++))
fi
((TOTAL_TESTS++))

echo ""

# Generate consolidated report
print_status "Phase 4: Report Generation"
echo "=========================="

REPORT_FILE="reports/mcp-test-consolidated-$(date +%Y%m%d-%H%M%S).json"

cat > "$REPORT_FILE" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "testSuite": "MCP Comprehensive Test Suite",
  "summary": {
    "totalTests": $TOTAL_TESTS,
    "passedTests": $PASSED_TESTS,
    "failedTests": $FAILED_TESTS,
    "successRate": $(echo "scale=2; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc -l 2>/dev/null || echo "0")
  },
  "environment": {
    "platform": "$(uname -s)",
    "architecture": "$(uname -m)",
    "nodeVersion": "$(node --version 2>/dev/null || echo 'not available')",
    "npmVersion": "$(npm --version 2>/dev/null || echo 'not available')",
    "projectRoot": "$PROJECT_ROOT"
  },
  "testPhases": [
    {
      "name": "Configuration and Setup Tests",
      "description": "Validates MCP configuration files and setup scripts"
    },
    {
      "name": "Core MCP Tests",
      "description": "Tests MCP server configurations and basic functionality"
    },
    {
      "name": "Integration Tests",
      "description": "Tests integration with Claude Code and package managers"
    }
  ],
  "availableReports": [
    "mcp-test-report.json",
    "mcp-functional-test-report.json"
  ]
}
EOF

print_success "Consolidated report generated: $REPORT_FILE"

# Display final summary
echo ""
print_status "Final Test Summary"
echo "=================="
echo "Total Tests: $TOTAL_TESTS"
echo "✅ Passed: $PASSED_TESTS"
echo "❌ Failed: $FAILED_TESTS"
echo "Success Rate: $(echo "scale=1; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc -l 2>/dev/null || echo "0")%"
echo ""

# Display recommendations
print_status "Recommendations"
echo "==============="

if [ $FAILED_TESTS -gt 0 ]; then
    echo "❌ Some tests failed. Consider:"
    echo "   1. Run './scripts/setup-mcp-servers.sh' to install missing servers"
    echo "   2. Check individual test reports in the reports/ directory"
    echo "   3. Verify network connectivity for package downloads"
    echo "   4. Install missing MCP servers manually if needed"
else
    echo "✅ All tests passed! Your MCP configuration is ready to use."
fi

echo ""
print_status "Available MCP configurations:"
echo "- mcp-simple.json    - Basic configuration (filesystem + memory)"
echo "- mcp-config.json    - Full configuration (all servers)"
echo "- mcp-dev.json       - Development-focused configuration"
echo "- mcp-test.json      - Testing-focused configuration"
echo ""

print_status "Usage example:"
echo "claude-code --mcp-config mcp-simple.json"
echo ""

# Exit with appropriate code
if [ $FAILED_TESTS -gt 0 ]; then
    print_warning "Tests completed with failures"
    exit 1
else
    print_success "All tests completed successfully"
    exit 0
fi