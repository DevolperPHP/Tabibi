#!/usr/bin/env python3
"""
Test script to send push notifications to your production server
Run this after deployment to test if notifications are working
"""

import requests
import json
import sys

# TODO: Update these with your production server details
SERVER_URL = "http://165.232.78.163"  # Your production server (port 80)

def test_notification(user_id, title, body, notification_type="test"):
    """Send a test notification"""
    print(f"📤 Sending notification to user: {user_id}")
    print(f"   Title: {title}")
    print(f"   Body: {body}")
    print(f"   Type: {notification_type}")
    print()

    try:
        response = requests.post(
            f"{SERVER_URL}/notifications/send",
            json={
                "userId": user_id,
                "title": title,
                "body": body,
                "type": notification_type
            },
            headers={"Content-Type": "application/json"},
            timeout=10
        )

        if response.status_code == 200:
            data = response.json()
            print("✅ Notification sent successfully!")
            print(f"   Response: {json.dumps(data, indent=2)}")
            return True
        else:
            print(f"❌ Failed to send notification")
            print(f"   Status: {response.status_code}")
            print(f"   Response: {response.text}")
            return False

    except requests.exceptions.RequestException as e:
        print(f"❌ Error: {e}")
        return False

def test_bulk_notifications(user_ids, title, body):
    """Send bulk notifications"""
    print(f"📤 Sending bulk notifications to {len(user_ids)} users")
    print(f"   Title: {title}")
    print(f"   Body: {body}")
    print()

    try:
        response = requests.post(
            f"{SERVER_URL}/notifications/send-bulk",
            json={
                "userIds": user_ids,
                "title": title,
                "body": body,
                "type": "bulk_test"
            },
            headers={"Content-Type": "application/json"},
            timeout=10
        )

        if response.status_code == 200:
            data = response.json()
            print("✅ Bulk notifications sent successfully!")
            print(f"   Response: {json.dumps(data, indent=2)}")
            return True
        else:
            print(f"❌ Failed to send bulk notifications")
            print(f"   Status: {response.status_code}")
            return False

    except requests.exceptions.RequestException as e:
        print(f"❌ Error: {e}")
        return False

def test_fcm_token_update(user_id, token):
    """Test FCM token update"""
    print(f"📤 Updating FCM token for user: {user_id}")
    print(f"   Token: {token[:50]}...")
    print()

    try:
        response = requests.put(
            f"{SERVER_URL}/users/{user_id}/fcm-token",
            json={"token": token},
            headers={"Content-Type": "application/json"},
            timeout=10
        )

        if response.status_code == 200:
            data = response.json()
            print("✅ FCM token updated successfully!")
            print(f"   Response: {json.dumps(data, indent=2)}")
            return True
        else:
            print(f"❌ Failed to update FCM token")
            print(f"   Status: {response.status_code}")
            return False

    except requests.exceptions.RequestException as e:
        print(f"❌ Error: {e}")
        return False

def main():
    print("=" * 60)
    print("🔥 Firebase Cloud Messaging Test Script")
    print("=" * 60)
    print()

    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 test_notifications.py test-single <user_id>")
        print("  python3 test_notifications.py test-bulk <user_id_1> <user_id_2> ...")
        print("  python3 test_notifications.py update-token <user_id> <fcm_token>")
        print()
        print("Examples:")
        print("  python3 test_notifications.py test-single 64a7b8c9d1e2f34567890abc")
        print("  python3 test_notifications.py test-bulk 64a7b8c9d1e2f34567890abc 64a7b8c9d1e2f34567890def")
        print("  python3 test_notifications.py update-token 64a7b8c9d1e2f34567890abc d9f8g7h6j5k4l3...")
        sys.exit(1)

    command = sys.argv[1]

    if command == "test-single":
        if len(sys.argv) < 3:
            print("❌ Please provide user_id")
            sys.exit(1)
        user_id = sys.argv[2]
        test_notification(user_id, "Test Notification", "This is a test push notification!")

    elif command == "test-bulk":
        if len(sys.argv) < 3:
            print("❌ Please provide at least one user_id")
            sys.exit(1)
        user_ids = sys.argv[2:]
        test_bulk_notifications(user_ids, "Bulk Test", "This is a bulk notification test!")

    elif command == "update-token":
        if len(sys.argv) < 4:
            print("❌ Please provide user_id and token")
            sys.exit(1)
        user_id = sys.argv[2]
        token = sys.argv[3]
        test_fcm_token_update(user_id, token)

    elif command == "case-test":
        if len(sys.argv) < 3:
            print("❌ Please provide user_id")
            sys.exit(1)
        user_id = sys.argv[2]
        test_notification(
            user_id,
            "حالة جديدة",
            "تم إنشاء حالة جديدة من أحمد",
            "case_created"
        )

    elif command == "health-tip":
        if len(sys.argv) < 3:
            print("❌ Please provide user_id")
            sys.exit(1)
        user_id = sys.argv[2]
        test_notification(
            user_id,
            "نصائح صحية",
            "نصيحة اليوم: نظف أسنانك مرتين يومياً",
            "teeth_health_tip"
        )

    else:
        print(f"❌ Unknown command: {command}")
        sys.exit(1)

if __name__ == "__main__":
    main()
