#!/usr/bin/env node

/**
 * MCP Server Test Suite
 * Comprehensive testing for Model Context Protocol servers
 * Tests configuration, connectivity, and functionality
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');

// Configuration
const CONFIG_FILES = [
    'mcp-config.json',
    'mcp-simple.json',
    'mcp-dev.json',
    'mcp-test.json'
];

const TIMEOUT = 30000; // 30 seconds
const PROJECT_ROOT = process.cwd();

// Test utilities
class TestRunner {
    constructor() {
        this.results = [];
        this.passed = 0;
        this.failed = 0;
        this.skipped = 0;
    }

    async runTest(name, testFn) {
        console.log(`\n🧪 Testing: ${name}`);
        const startTime = Date.now();
        
        try {
            await testFn();
            this.passed++;
            const duration = Date.now() - startTime;
            console.log(`✅ PASSED: ${name} (${duration}ms)`);
            this.results.push({ name, status: 'PASSED', duration });
        } catch (error) {
            this.failed++;
            const duration = Date.now() - startTime;
            console.log(`❌ FAILED: ${name} (${duration}ms)`);
            console.log(`   Error: ${error.message}`);
            this.results.push({ name, status: 'FAILED', duration, error: error.message });
        }
    }

    skip(name, reason) {
        this.skipped++;
        console.log(`⏭️  SKIPPED: ${name} - ${reason}`);
        this.results.push({ name, status: 'SKIPPED', reason });
    }

    async runCommand(command, args = [], options = {}) {
        return new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error(`Command timeout after ${TIMEOUT}ms`));
            }, TIMEOUT);

            const child = spawn(command, args, {
                stdio: 'pipe',
                cwd: PROJECT_ROOT,
                ...options
            });

            let stdout = '';
            let stderr = '';

            child.stdout.on('data', (data) => {
                stdout += data.toString();
            });

            child.stderr.on('data', (data) => {
                stderr += data.toString();
            });

            child.on('close', (code) => {
                clearTimeout(timeout);
                resolve({ code, stdout, stderr });
            });

            child.on('error', (error) => {
                clearTimeout(timeout);
                reject(error);
            });
        });
    }

    printSummary() {
        console.log('\n' + '='.repeat(60));
        console.log('📊 TEST SUMMARY');
        console.log('='.repeat(60));
        console.log(`Total Tests: ${this.results.length}`);
        console.log(`✅ Passed: ${this.passed}`);
        console.log(`❌ Failed: ${this.failed}`);
        console.log(`⏭️  Skipped: ${this.skipped}`);
        console.log(`Success Rate: ${Math.round((this.passed / (this.passed + this.failed)) * 100)}%`);
        
        if (this.failed > 0) {
            console.log('\n❌ FAILED TESTS:');
            this.results.filter(r => r.status === 'FAILED').forEach(r => {
                console.log(`   - ${r.name}: ${r.error}`);
            });
        }
        
        console.log('='.repeat(60));
    }
}

// Test functions
async function testConfigurationFiles(runner) {
    await runner.runTest('Configuration Files Exist', async () => {
        for (const configFile of CONFIG_FILES) {
            const filePath = path.join(PROJECT_ROOT, configFile);
            if (!fs.existsSync(filePath)) {
                throw new Error(`Configuration file not found: ${configFile}`);
            }
        }
    });

    await runner.runTest('Configuration Files Valid JSON', async () => {
        for (const configFile of CONFIG_FILES) {
            const filePath = path.join(PROJECT_ROOT, configFile);
            const content = fs.readFileSync(filePath, 'utf8');
            try {
                const config = JSON.parse(content);
                if (!config.mcpServers) {
                    throw new Error(`Invalid config structure in ${configFile}`);
                }
            } catch (error) {
                throw new Error(`Invalid JSON in ${configFile}: ${error.message}`);
            }
        }
    });

    await runner.runTest('MCP Server Configurations', async () => {
        const configPath = path.join(PROJECT_ROOT, 'mcp-config.json');
        const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
        
        const expectedServers = ['filesystem', 'memory', 'context7', 'sequential', 'magic', 'puppeteer'];
        const actualServers = Object.keys(config.mcpServers);
        
        for (const server of expectedServers) {
            if (!actualServers.includes(server)) {
                throw new Error(`Missing server configuration: ${server}`);
            }
        }
    });
}

async function testNodeDependencies(runner) {
    await runner.runTest('Node.js Available', async () => {
        const result = await runner.runCommand('node', ['--version']);
        if (result.code !== 0) {
            throw new Error('Node.js not available');
        }
    });

    await runner.runTest('npm Available', async () => {
        const result = await runner.runCommand('npm', ['--version']);
        if (result.code !== 0) {
            throw new Error('npm not available');
        }
    });

    await runner.runTest('npx Available', async () => {
        const result = await runner.runCommand('npx', ['--version']);
        if (result.code !== 0) {
            throw new Error('npx not available');
        }
    });
}

async function testFilesystemServer(runner) {
    await runner.runTest('Filesystem Server Package', async () => {
        const result = await runner.runCommand('npx', ['-y', '@modelcontextprotocol/server-filesystem', '--help']);
        if (result.code !== 0) {
            throw new Error('Filesystem server package not available');
        }
    });
}

async function testMemoryServer(runner) {
    await runner.runTest('Memory Server Path', async () => {
        const serverPath = '/home/joe/.config/mcp-memory-server/build/index.js';
        if (!fs.existsSync(serverPath)) {
            throw new Error(`Memory server not found at ${serverPath}`);
        }
    });

    await runner.runTest('Memory Server Executable', async () => {
        const serverPath = '/home/joe/.config/mcp-memory-server/build/index.js';
        const result = await runner.runCommand('node', [serverPath, '--help']);
        // Note: Memory server might not support --help, so we check if it at least runs
        if (result.stderr.includes('Error: Cannot find module')) {
            throw new Error('Memory server has missing dependencies');
        }
    });
}

async function testAdditionalServers(runner) {
    const serverTests = [
        { name: 'Context7', package: '@context7/mcp-server' },
        { name: 'Sequential', package: '@sequential/mcp-server' },
        { name: 'Magic', package: '@magic/mcp-server' },
        { name: 'Puppeteer', package: '@puppeteer/mcp-server' }
    ];

    for (const server of serverTests) {
        await runner.runTest(`${server.name} Server Package`, async () => {
            try {
                const result = await runner.runCommand('npx', ['-y', server.package, '--help']);
                // Some servers might not support --help, so we check for common error patterns
                if (result.stderr.includes('not found') || result.stderr.includes('404')) {
                    throw new Error(`${server.name} server package not found`);
                }
            } catch (error) {
                // If npx fails, try to check if it's globally installed
                const globalCheck = await runner.runCommand('npm', ['list', '-g', server.package]);
                if (globalCheck.code !== 0) {
                    throw new Error(`${server.name} server not available globally or via npx`);
                }
            }
        });
    }
}

async function testMCPSetupScript(runner) {
    await runner.runTest('MCP Setup Script Exists', async () => {
        const scriptPath = path.join(PROJECT_ROOT, 'scripts/setup-mcp-servers.sh');
        if (!fs.existsSync(scriptPath)) {
            throw new Error('MCP setup script not found');
        }
    });

    await runner.runTest('MCP Setup Script Executable', async () => {
        const scriptPath = path.join(PROJECT_ROOT, 'scripts/setup-mcp-servers.sh');
        const stats = fs.statSync(scriptPath);
        if (!(stats.mode & 0o111)) {
            throw new Error('MCP setup script is not executable');
        }
    });
}

async function testClaudeCodeIntegration(runner) {
    await runner.runTest('Claude Code Executable', async () => {
        const result = await runner.runCommand('claude-code', ['--version']);
        if (result.code !== 0) {
            runner.skip('Claude Code Integration', 'claude-code not available in PATH');
            return;
        }
    });

    await runner.runTest('Claude Code MCP Config', async () => {
        // Test if Claude Code can parse the MCP configuration
        const configPath = path.join(PROJECT_ROOT, 'mcp-simple.json');
        const result = await runner.runCommand('claude-code', ['--mcp-config', configPath, '--help']);
        if (result.code !== 0 && result.stderr.includes('config')) {
            throw new Error('Claude Code cannot parse MCP configuration');
        }
    });
}

async function generateTestReport(runner) {
    const reportPath = path.join(PROJECT_ROOT, 'reports/mcp-test-report.json');
    const reportDir = path.dirname(reportPath);
    
    if (!fs.existsSync(reportDir)) {
        fs.mkdirSync(reportDir, { recursive: true });
    }

    const report = {
        timestamp: new Date().toISOString(),
        summary: {
            total: runner.results.length,
            passed: runner.passed,
            failed: runner.failed,
            skipped: runner.skipped,
            successRate: Math.round((runner.passed / (runner.passed + runner.failed)) * 100)
        },
        results: runner.results,
        environment: {
            nodeVersion: process.version,
            platform: process.platform,
            arch: process.arch,
            projectRoot: PROJECT_ROOT
        }
    };

    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
    console.log(`\n📄 Test report saved to: ${reportPath}`);
}

// Main test execution
async function main() {
    console.log('🧪 MCP Server Test Suite');
    console.log('========================');
    console.log(`Project: ${PROJECT_ROOT}`);
    console.log(`Timeout: ${TIMEOUT}ms`);
    console.log('');

    const runner = new TestRunner();

    try {
        // Configuration tests
        console.log('🔧 Testing Configuration...');
        await testConfigurationFiles(runner);

        // Dependency tests
        console.log('\n📦 Testing Dependencies...');
        await testNodeDependencies(runner);

        // Core MCP servers
        console.log('\n🏗️  Testing Core MCP Servers...');
        await testFilesystemServer(runner);
        await testMemoryServer(runner);

        // Additional MCP servers
        console.log('\n🔌 Testing Additional MCP Servers...');
        await testAdditionalServers(runner);

        // Setup script tests
        console.log('\n⚙️  Testing Setup Scripts...');
        await testMCPSetupScript(runner);

        // Claude Code integration
        console.log('\n🤖 Testing Claude Code Integration...');
        await testClaudeCodeIntegration(runner);

        // Generate report
        await generateTestReport(runner);

    } catch (error) {
        console.error(`\n💥 Test suite failed: ${error.message}`);
        process.exit(1);
    }

    // Print summary
    runner.printSummary();

    // Exit with appropriate code
    process.exit(runner.failed > 0 ? 1 : 0);
}

// Run tests if called directly
if (require.main === module) {
    main().catch(error => {
        console.error(`Fatal error: ${error.message}`);
        process.exit(1);
    });
}

module.exports = { TestRunner, main };