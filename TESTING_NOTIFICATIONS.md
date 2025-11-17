# 🔔 Testing Push Notifications

## ❌ Simulators Don't Support FCM

**Important:** iOS and Android simulators **cannot receive** Firebase push notifications (FCM). This is a platform limitation, not a bug.

## ✅ Testing Methods

### Method 1: Test on Physical Device (Recommended)

#### iOS Device:
```bash
# Connect iPhone/iPad via USB or WiFi
flutter run -d "Your iPhone Name"

# Or install directly
# flutter run --release
```

#### Android Device:
```bash
# Enable Developer Options + USB Debugging
flutter run -d "Your Android Device"

# Or install APK directly
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Method 2: Test Backend FCM Service

**Verify backend can send notifications:**

```bash
# 1. Deploy backend
./deploy_to_production.sh 165.232.78.163 root /var/www/tabibi-backend

# 2. Test API
curl http://165.232.78.163/notifications/test

# 3. Send test notification
python3 test_notifications.py test-single USER_ID

# 4. Check logs
ssh root@165.232.78.163 "pm2 logs tabibi-backend"
```

### Method 3: Test Local Notifications

**Test local notifications (work on simulators):**

```dart
// In your Flutter code
import 'package:my_doctor/services/fcm_notification_service.dart';

// Trigger local notification
FCMNotificationService.showLocalNotification(
  title: 'Test',
  body: 'Local notification works!',
  payload: 'test',
);
```

## 🔍 How to Verify It's Working

### On Physical Device:

1. **App receives FCM token:**
   - Check console logs: `Token: d9f8g7h6j5k4...`
   - Verify saved in backend: Check MongoDB user document

2. **Notification received:**
   - App shows notification banner
   - Notification sound plays
   - Tapping notification opens app

3. **Backend logs show:**
   ```
   ✅ Successfully sent message: projects/xxx/messages/yyy
   ```

### In Firebase Console:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → Cloud Messaging
3. Check "Sending" tab for delivery status

## 🚨 Common Issues

### Issue 1: "Notifications not working on simulator"
**Solution:** This is expected! Use a real device.

### Issue 2: "FCM token is null"
**Solution:** Ensure Firebase is initialized correctly:
```dart
// Check logs for:
print('✅ Firebase initialized successfully');
```

### Issue 3: "User not receiving push"
**Check:**
1. User has `fcmToken` in MongoDB
2. Backend is deployed with Firebase Admin
3. Physical device (not simulator)

### Issue 4: "Build fails with Firebase error"
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Testing Checklist

### Backend:
- [ ] Deployed with Firebase Admin
- [ ] `serviceAccountKey.json` on server
- [ ] MongoDB connected
- [ ] API responding: `curl http://165.232.78.163/notifications/test`

### Flutter App:
- [ ] Firebase config files present
- [ ] Builds successfully: `flutter build apk`
- [ ] Runs on device (not simulator)
- [ ] Firebase initialized (check logs)

### Notifications:
- [ ] FCM token generated
- [ ] Token saved to backend
- [ ] Can send test notification
- [ ] User receives push on device

## 🎯 Quick Test Commands

```bash
# 1. Deploy backend
./deploy_to_production.sh 165.232.78.163 root /var/www/tabibi-backend

# 2. Check backend status
ssh root@165.232.78.163 "pm2 list"

# 3. Test notification
python3 test_notifications.py test-single YOUR_USER_ID

# 4. Run app on physical device
flutter run -d "YOUR_DEVICE_NAME"
```

## 💡 Pro Tips

1. **Use Firebase Console** to check delivery stats
2. **Check backend logs** for FCM errors
3. **Test local notifications** first to verify app logic
4. **Use real devices** for final testing
5. **Monitor FCM quotas** to avoid hitting limits

## 📞 Troubleshooting

### Push not received?
```bash
# Check backend logs
ssh root@165.232.78.163
pm2 logs tabibi-backend --lines 50

# Check if token exists
mongo tabibi
db.users.findOne({_id: ObjectId("USER_ID")})
```

### Build fails?
```bash
flutter clean
flutter pub get
cd ios && pod install --repo-update && cd ..
flutter run
```

---

## 🎉 Bottom Line

**For real testing:** Use a physical device!

Simulators are great for UI testing but can't receive push notifications. Once you deploy the backend and install the app on a real device, everything will work perfectly! 🚀
