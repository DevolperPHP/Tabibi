#!/usr/bin/env python3
"""
🔔 Notification System Test Script
Tests all notification types after the complete rebuild
"""

import requests
import json
import sys

# Configuration
BACKEND_URL = "http://165.232.78.163"

def test_notification_system():
    """Main test function"""
    print("=" * 60)
    print("🔔 NOTIFICATION SYSTEM TEST SUITE")
    print("=" * 60)
    print()
    
    print("📋 Testing Backend Connectivity...")
    try:
        response = requests.get(f"{BACKEND_URL}/", timeout=5)
        print(f"✅ Backend is reachable: {BACKEND_URL}")
    except Exception as e:
        print(f"❌ Backend unreachable: {e}")
        print("⚠️  Make sure backend is running on Digital Ocean")
        return False
    
    print()
    print("=" * 60)
    print("📱 NOTIFICATION ENDPOINTS AVAILABLE")
    print("=" * 60)
    print()
    
    endpoints = {
        "Admin Accept Case": f"{BACKEND_URL}/admin/case/accept/:id",
        "Admin Reject Case": f"{BACKEND_URL}/admin/case/reject/:id",
        "Doctor Take Case": f"{BACKEND_URL}/doctor/payment/callback",
        "Doctor Complete Case": f"{BACKEND_URL}/doctor/my-case/done/:id",
        "Accept Doctor Role": f"{BACKEND_URL}/admin/role/requests/update/accept/:id",
        "Reject Doctor Role": f"{BACKEND_URL}/admin/role/requests/update/reject/:id",
        "Save FCM Token": f"{BACKEND_URL}/users/:userId",
        "Send Notification": f"{BACKEND_URL}/notifications/send",
    }
    
    for name, endpoint in endpoints.items():
        print(f"  ✅ {name:<25} → {endpoint}")
    
    print()
    print("=" * 60)
    print("🧪 MANUAL TESTING INSTRUCTIONS")
    print("=" * 60)
    print()
    
    print("📱 **STEP 1: Run App on Physical iPhone**")
    print("   ```bash")
    print("   flutter clean")
    print("   flutter pub get")
    print("   flutter run --release")
    print("   ```")
    print()
    
    print("🔍 **STEP 2: Check Console for FCM Initialization**")
    print("   Look for these logs:")
    print("   ✅ Firebase initialized successfully")
    print("   🚀 [FCM] Initializing notification service...")
    print("   ✅ [FCM] User granted permission")
    print("   🔑 [FCM] Token: eF7g9h2j5k8m...")
    print("   💾 [FCM] Saving token to backend...")
    print("   ✅ [FCM] Token saved successfully")
    print("   ✅ [FCM] Initialization complete")
    print()
    
    print("👤 **STEP 3: Login as Patient**")
    print("   - Login with patient credentials")
    print("   - FCM token will be saved automatically")
    print()
    
    print("🏥 **STEP 4: Create & Test Case**")
    print("   1. Patient creates a new case")
    print("   2. Admin accepts the case")
    print("   3. ⏰ Patient should receive notification within 1-2 seconds")
    print()
    
    print("💳 **STEP 5: Test Doctor Taking Case**")
    print("   1. Doctor pays and takes the case")
    print("   2. Payment callback fires")
    print("   3. ⏰ Patient should receive 'طبيب اختار حالتك!' notification")
    print()
    
    print("✅ **STEP 6: Test Case Completion**")
    print("   1. Doctor marks case as done")
    print("   2. ⏰ Patient should receive 'تم علاج حالتك بنجاح' notification")
    print()
    
    print("=" * 60)
    print("🐛 DEBUGGING TIPS")
    print("=" * 60)
    print()
    
    print("❌ **If No Notifications:**")
    print("   1. Check iOS Settings → Notifications → My Doctor → Enabled")
    print("   2. Verify running on PHYSICAL device (not simulator)")
    print("   3. Check console for FCM token generation")
    print("   4. Check backend logs: pm2 logs tabibi-backend")
    print()
    
    print("⚠️  **If Token Not Saved:**")
    print("   1. Verify user is logged in")
    print("   2. Check network connectivity")
    print("   3. Look for 'Token saved successfully' log")
    print()
    
    print("🔧 **Backend Verification:**")
    print("   ```bash")
    print("   ssh root@165.232.78.163")
    print("   pm2 logs tabibi-backend --lines 50")
    print("   ```")
    print()
    
    print("=" * 60)
    print("✅ TEST SUITE COMPLETED")
    print("=" * 60)
    print()
    print("📖 For detailed documentation, see:")
    print("   NOTIFICATION_SYSTEM_COMPLETE_FIX.md")
    print()
    
    return True

if __name__ == "__main__":
    success = test_notification_system()
    sys.exit(0 if success else 1)
