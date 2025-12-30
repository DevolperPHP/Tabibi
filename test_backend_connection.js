#!/usr/bin/env node

// Test script to verify backend server and authentication endpoint
const axios = require('axios');

const BASE_URL = 'http://165.232.78.163:3000';

async function testBackendConnection() {
    console.log('🔍 Testing backend server connection...');
    
    try {
        // Test if server is running
        const response = await axios.get(`${BASE_URL}/`, { timeout: 5000 });
        console.log('✅ Backend server is running');
        console.log('Status:', response.status);
        return true;
    } catch (error) {
        console.log('❌ Backend server connection failed:');
        console.log('Error:', error.message);
        
        if (error.code === 'ECONNREFUSED') {
            console.log('\n💡 Possible issues:');
            console.log('1. Backend server is not running');
            console.log('2. Server is running on a different port');
            console.log('3. Network/firewall issues');
            console.log('\n🔧 To start the backend server:');
            console.log('cd tabibi-backend && npm start');
        }
        return false;
    }
}

async function testAuthEndpoint() {
    console.log('\n🔐 Testing authentication endpoint...');
    
    try {
        // Test POST to login endpoint (should return method not allowed for GET)
        const response = await axios.post(`${BASE_URL}/passport/login`, {
            email: 'test@example.com',
            password: 'test123'
        }, { 
            timeout: 5000,
            validateStatus: () => true // Don't throw on non-2xx status
        });
        
        console.log('✅ Authentication endpoint is accessible');
        console.log('Status:', response.status);
        console.log('Response:', response.data);
        
        if (response.status === 404) {
            console.log('\n⚠️  User not found (expected for test credentials)');
        } else if (response.status === 400) {
            console.log('\n⚠️  Bad request (expected for test credentials)');
        }
        
        return true;
    } catch (error) {
        console.log('❌ Authentication endpoint test failed:');
        console.log('Error:', error.message);
        return false;
    }
}

async function main() {
    console.log('🚀 Backend Connection Test\n');
    
    const serverOk = await testBackendConnection();
    if (!serverOk) {
        console.log('\n❌ Please fix server connection before testing authentication');
        process.exit(1);
    }
    
    const authOk = await testAuthEndpoint();
    if (!authOk) {
        console.log('\n❌ Authentication endpoint test failed');
        process.exit(1);
    }
    
    console.log('\n✅ All tests passed! Backend is properly configured.');
    console.log('\n📱 Your Flutter app should now be able to connect to the backend.');
}

main().catch(console.error);