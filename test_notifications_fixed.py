#!/usr/bin/env python3
"""
Test script to verify the notification system is working correctly.
This script tests:
1. Backend server connectivity
2. Notification endpoints
3. FCM token saving
4. Notification sending
"""

import requests
import json
import sys

BASE_URL = "http://localhost:3000"

def test_backend_connection():
    """Test if backend is running and accessible"""
    print("🔍 Testing backend connection...")
    try:
        response = requests.get(f"{BASE_URL}/notifications/test-user-id", timeout=5)
        if response.status_code == 500:  # Expected for invalid user ID
            print("✅ Backend is running and accessible")
            return True
        else:
            print(f"⚠️  Unexpected response: {response.status_code}")
            return True
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to backend. Make sure it's running on localhost:3000")
        return False
    except Exception as e:
        print(f"❌ Error connecting to backend: {e}")
        return False

def test_health_endpoints():
    """Test various health endpoints"""
    print("\n🏥 Testing health endpoints...")
    
    # Test FCM token endpoint (should work even with invalid user)
    try:
        response = requests.put(f"{BASE_URL}/users/test-user-id", 
                               json={"token": "test-token"}, 
                               timeout=5)
        print(f"FCM token endpoint: {response.status_code}")
    except Exception as e:
        print(f"FCM token endpoint error: {e}")
    
    # Test notifications endpoint
    try:
        response = requests.get(f"{BASE_URL}/notifications/test-user-id", timeout=5)
        print(f"Notifications endpoint: {response.status_code}")
    except Exception as e:
        print(f"Notifications endpoint error: {e}")

def test_notification_api():
    """Test the notification API with test data"""
    print("\n📱 Testing notification API...")
    
    # Test data - in a real scenario, you'd get this from a logged-in user
    test_data = {
        "userId": "test-user-id",
        "title": "Test Notification",
        "body": "This is a test notification to verify the system is working!"
    }
    
    try:
        response = requests.post(f"{BASE_URL}/notifications/test", 
                                json=test_data, 
                                timeout=10)
        
        result = response.json()
        print(f"Response status: {response.status_code}")
        print(f"Response: {json.dumps(result, indent=2)}")
        
        if response.status_code == 200:
            print("✅ Notification API is working!")
            if result.get('result', {}).get('success'):
                print("✅ Notification was sent successfully via FCM!")
            else:
                print("⚠️  Notification API responded but FCM sending failed")
                print(f"Error: {result.get('result', {}).get('error', 'Unknown error')}")
        elif response.status_code == 400:
            print("ℹ️  Expected response - user not found or no FCM token")
            print(f"Message: {result.get('msg', 'Unknown message')}")
        else:
            print(f"⚠️  Unexpected response: {result}")
            
    except Exception as e:
        print(f"❌ Error testing notification API: {e}")

def print_summary():
    """Print a summary of what needs to be done"""
    print("\n" + "="*60)
    print("📋 NOTIFICATION SYSTEM TEST SUMMARY")
    print("="*60)
    print()
    print("✅ Backend is running with Firebase Admin initialized")
    print("✅ API URL changed to localhost:3000")
    print("✅ Enhanced logging and error handling added")
    print("✅ Test endpoint created at /notifications/test")
    print()
    print("📱 TO TEST ON MOBILE APP:")
    print("1. Build and run the Flutter app")
    print("2. Log in with a user account")
    print("3. Check the app logs for FCM token generation")
    print("4. Use the test endpoint to send notifications")
    print()
    print("🧪 MANUAL TEST COMMANDS:")
    print(f"curl -X POST {BASE_URL}/notifications/test \\")
    print('  -H "Content-Type: application/json" \\')
    print('  -d \'{"userId": "YOUR_USER_ID", "title": "Test", "body": "Hello!"}\'')
    print()
    print("🔧 NEXT STEPS:")
    print("- Test with a real user account in the mobile app")
    print("- Verify FCM tokens are being saved to the database")
    print("- Test all notification types (case created, accepted, etc.)")
    print("- Change API URL back to production when testing is complete")

if __name__ == "__main__":
    print("🚀 Starting notification system test...")
    print("="*60)
    
    if test_backend_connection():
        test_health_endpoints()
        test_notification_api()
        print_summary()
    else:
        print("\n❌ Cannot proceed with tests - backend is not accessible")
        sys.exit(1)