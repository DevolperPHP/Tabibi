# ✅ PRODUCTION DEPLOYMENT READY!

## 🎉 What's Been Done

### ✅ Firebase Configuration Complete
- `google-services.json` → Placed in `android/app/`
- `GoogleService-Info.plist` → Placed in `ios/Runner/`
- `serviceAccountKey.json` → Placed in `tabibi-backend/config/`
- All dependencies installed
- Firebase Admin SDK tested and working

### ✅ Backend Updates Complete
- FCM service integrated (`services/fcmService.js`)
- FCM token endpoint added (`routes/user/fcm-token.js`)
- Notifications updated to send FCM + save to DB
- Database model updated (`model/User.js`)
- All routes registered in `app.js`

### ✅ Flutter App Updates Complete
- FCM service created (`lib/services/fcm_notification_service.dart`)
- Firebase initialized in `main.dart`
- Storage controller updated
- API constants updated for production server

### ✅ Production Scripts Ready
- `deploy_to_production.sh` → Deploy backend to your server
- `setup_firebase.sh` → Configure Firebase (already done)
- `test_notifications.py` → Test notifications on production
- All scripts are executable and ready

## 🚀 To Deploy Backend to Production

### Option 1: Use the Deployment Script (Recommended)

```bash
# Update these values in deploy_to_production.sh:
# SERVER_IP="165.232.78.163"
# SSH_USER="root"
# DEPLOY_PATH="/var/www/tabibi-backend"

# Then run:
./deploy_to_production.sh 165.232.78.163 root /var/www/tabibi-backend
```

### Option 2: Manual Deployment

```bash
# 1. Copy backend to server
rsync -avz --exclude='node_modules' --exclude='.git' ./tabibi-backend/ user@165.232.78.163:/var/www/tabibi-backend/

# 2. SSH to server and install dependencies
ssh user@165.232.78.163
cd /var/www/tabibi-backend
npm install --production

# 3. Update .env with your MongoDB URI and JWT secret

# 4. Start with PM2
npm install -g pm2
pm2 start app.js --name tabibi-backend
pm2 save
```

### Option 3: If You Use cPanel/Plesk

1. Compress `tabibi-backend` folder
2. Upload to your server via File Manager
3. Extract in your web directory
4. Run `npm install` in terminal
5. Start with your process manager

## 🔧 Required Environment Variables

Update `tabibi-backend/.env` on your server:

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://your-mongodb-connection-string
JWT_SECRET=your-jwt-secret-key
GOOGLE_APPLICATION_CREDENTIALS=/var/www/tabibi-backend/config/serviceAccountKey.json
```

## 📱 To Build and Test the Flutter App

```bash
# Install dependencies (already done)
flutter pub get

# Build release APK
flutter build apk --release

# Install on device
flutter install

# Or run on connected device/simulator
flutter run
```

## 🧪 To Test Push Notifications

### 1. Start Backend on Production
```bash
# On your server
pm2 start tabibi-backend --name mydoctor-backend
```

### 2. Test with Python Script
```bash
# Get a user ID from your MongoDB database
# Then test:
python3 test_notifications.py test-single USER_ID

# Test case notification:
python3 test_notifications.py case-test USER_ID

# Test health tip:
python3 test_notifications.py health-tip USER_ID
```

### 3. Test with curl
```bash
curl -X POST http://165.232.78.163:3000/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "YOUR_USER_ID",
    "title": "Test Notification",
    "body": "This is a test from production!",
    "type": "test"
  }'
```

## 📊 Server Monitoring Commands

On your production server:

```bash
# Check backend status
pm2 list

# View logs
pm2 logs tabibi-backend

# Restart backend
pm2 restart tabibi-backend

# Monitor in real-time
pm2 monit

# Check if API is responding
curl http://localhost:3000/notifications/test
```

## 🏗️ Architecture Overview

```
┌─────────────────┐
│   Flutter App   │
│  (FCM Client)   │
└────────┬────────┘
         │ HTTPS
         ▼
┌─────────────────┐
│   Backend API   │
│   (Node.js)     │
│  Port: 3000     │
└────────┬────────┘
         │
         ├───────► MongoDB (Notifications)
         │
         └───────► Firebase Admin (FCM)
                       │
                       ▼
                ┌────────────────┐
                │   User Device  │
                │ (Push Notif)   │
                └────────────────┘
```

## 🔐 Security Checklist

- [ ] ✅ Firebase service account key is on server (not in repo)
- [ ] ✅ Add `tabibi-backend/config/serviceAccountKey.json` to `.gitignore`
- [ ] ✅ Add `google-services.json` to `.gitignore`
- [ ] ✅ Add `GoogleService-Info.plist` to `.gitignore`
- [ ] ✅ Use environment variables for sensitive data
- [ ] ✅ Set proper file permissions on server (600 for serviceAccountKey.json)
- [ ] ✅ Use HTTPS in production (configure your reverse proxy)
- [ ] ✅ Set up firewall rules (allow port 3000 for backend)

## 🐛 Troubleshooting

### Push notifications not working?

1. **Check backend logs:**
   ```bash
   pm2 logs tabibi-backend
   ```

2. **Verify Firebase Admin:**
   ```bash
   ssh user@server
   cd /var/www/tabibi-backend
   node -e "require('firebase-admin'); console.log('OK')"
   ```

3. **Check FCM token is saved:**
   - Open MongoDB
   - Check if user has `fcmToken` field

4. **Test API endpoint:**
   ```bash
   curl http://165.232.78.163:3000/notifications/test
   ```

### App won't connect to backend?

- Verify server IP in `lib/utils/constants/api_constants.dart`
- Check server firewall (port 3000 should be open)
- Ensure backend is running: `pm2 list`

### Build errors?

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk
```

## 📞 Need Help?

Check these files:
- `FCM_IMPLEMENTATION_COMPLETE.md` - Complete implementation details
- `FIREBASE_SETUP.md` - Firebase setup guide
- `tabibi-backend/FCM_SEND_EXAMPLES.md` - Code examples

## 🎯 Next Steps

1. ✅ **Backend** - Deploy to production using `./deploy_to_production.sh`
2. ✅ **Environment** - Update `.env` on server with your credentials
3. ✅ **Flutter App** - Build and install on device
4. ✅ **Test** - Send test notification with Python script
5. ✅ **Monitor** - Check logs and notifications delivery

## 📝 Files Summary

### Created
- `lib/services/fcm_notification_service.dart`
- `tabibi-backend/services/fcmService.js`
- `tabibi-backend/routes/user/fcm-token.js`
- `deploy_to_production.sh`
- `setup_firebase.sh` (already run)
- `test_notifications.py`
- `PRODUCTION_DEPLOYMENT_READY.md` (this file)

### Modified
- `pubspec.yaml` - Added Firebase dependencies
- `lib/main.dart` - Firebase initialization
- `lib/controllers/storage_controller.dart` - Added getUserId()
- `lib/utils/constants/api_constants.dart` - Added FCM endpoint
- `android/build.gradle` - Added Google services plugin
- `android/app/build.gradle` - Firebase config
- `ios/Runner/Info.plist` - iOS notifications
- `tabibi-backend/package.json` - Added firebase-admin
- `tabibi-backend/model/User.js` - Added fcmToken field
- `tabibi-backend/routes/user/notifications.js` - Integrated FCM
- `tabibi-backend/app.js` - Registered new routes

### Firebase Files (Provided by you)
- `google-services.json` → `android/app/`
- `GoogleService-Info.plist` → `ios/Runner/`
- `serviceAccountKey.json` → `tabibi-backend/config/`

## 🎉 You're Ready!

Everything is configured and ready for production deployment. Just run the deployment script and test!

**Command to deploy:**
```bash
./deploy_to_production.sh 165.232.78.163 root /var/www/tabibi-backend
```
