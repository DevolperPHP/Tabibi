const axios = require('axios');

const API_URL = 'http://165.232.78.163';

async function testAuth() {
    try {
        // Test registration
        console.log('Testing registration...');
        const registerResponse = await axios.post(`${API_URL}/passport/register`, {
            name: 'Test User',
            age: 30,
            city: 'بغداد',
            zone: 'الكاظمية',
            email: 'test@example.com',
            password: 'test123456',
            phone: '1234567890',
            telegram: 'testuser',
            gender: 'male'
        });

        console.log('Registration response:', registerResponse.data);

        // Test login
        console.log('\nTesting login...');
        const loginResponse = await axios.post(`${API_URL}/passport/login`, {
            email: 'test@example.com',
            password: 'test123456'
        });

        console.log('\nLogin response:', JSON.stringify(loginResponse.data, null, 2));

        const token = loginResponse.data.token;
        console.log('\nToken:', token);

        // Test profile endpoint
        console.log('\nTesting profile endpoint...');
        const profileResponse = await axios.get(`${API_URL}/profile`, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });

        console.log('\nProfile response:', JSON.stringify(profileResponse.data, null, 2));

    } catch (error) {
        console.error('Error:', error.response?.data || error.message);
    }
}

testAuth();
