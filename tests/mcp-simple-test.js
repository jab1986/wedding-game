#!/usr/bin/env node

/**
 * Simple MCP Test - Just test what we can actually verify
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

class SimpleMCPTest {
    constructor() {
        this.passed = 0;
        this.failed = 0;
    }

    async test(name, fn) {
        process.stdout.write(`🧪 ${name}... `);
        try {
            await fn();
            console.log('✅ PASSED');
            this.passed++;
        } catch (error) {
            console.log(`❌ FAILED: ${error.message}`);
            this.failed++;
        }
    }

    async run() {
        console.log('🧪 Simple MCP Test Suite');
        console.log('========================');
        console.log('');

        await this.test('Configuration files exist', () => {
            const configs = ['mcp-config.json', 'mcp-simple.json', 'mcp-dev.json', 'mcp-test.json', 'mcp-ui.json'];
            for (const config of configs) {
                if (!fs.existsSync(config)) {
                    throw new Error(`${config} not found`);
                }
            }
        });

        await this.test('Configuration files are valid JSON', () => {
            const configs = ['mcp-config.json', 'mcp-simple.json', 'mcp-dev.json', 'mcp-test.json', 'mcp-ui.json'];
            for (const config of configs) {
                const content = fs.readFileSync(config, 'utf8');
                JSON.parse(content); // Will throw if invalid
            }
        });

        await this.test('Node.js is available', async () => {
            const result = await this.runCommand('node', ['--version']);
            if (result.code !== 0) throw new Error('Node.js not working');
        });

        await this.test('npm is available', async () => {
            const result = await this.runCommand('npm', ['--version']);
            if (result.code !== 0) throw new Error('npm not working');
        });

        await this.test('npx is available', async () => {
            const result = await this.runCommand('npx', ['--version']);
            if (result.code !== 0) throw new Error('npx not working');
        });

        await this.test('Claude Code can parse MCP config', async () => {
            const result = await this.runCommand('claude-code', ['--mcp-config', 'mcp-simple.json', '--help']);
            if (result.stderr.includes('Invalid') || result.stderr.includes('Error')) {
                throw new Error('Claude Code config parsing failed');
            }
        });

        await this.test('MCP packages are installed globally', async () => {
            const packages = [
                '@modelcontextprotocol/server-memory',
                '@modelcontextprotocol/server-sequential-thinking',
                '@magicuidesign/mcp',
                '@upstash/context7-mcp'
            ];
            
            for (const pkg of packages) {
                const result = await this.runCommand('npm', ['list', '-g', pkg]);
                if (result.code !== 0) {
                    throw new Error(`${pkg} not installed globally`);
                }
            }
        });

        console.log('\n📊 Results:');
        console.log(`✅ Passed: ${this.passed}`);
        console.log(`❌ Failed: ${this.failed}`);
        console.log(`Success Rate: ${Math.round((this.passed / (this.passed + this.failed)) * 100)}%`);
        
        return this.failed === 0;
    }

    async runCommand(command, args = []) {
        return new Promise((resolve) => {
            const child = spawn(command, args, { stdio: 'pipe' });
            let stdout = '';
            let stderr = '';

            child.stdout.on('data', (data) => stdout += data.toString());
            child.stderr.on('data', (data) => stderr += data.toString());

            child.on('close', (code) => {
                resolve({ code, stdout, stderr });
            });

            setTimeout(() => {
                child.kill();
                resolve({ code: 1, stdout, stderr: 'timeout' });
            }, 10000);
        });
    }
}

if (require.main === module) {
    const test = new SimpleMCPTest();
    test.run().then(success => {
        process.exit(success ? 0 : 1);
    });
}

module.exports = SimpleMCPTest;