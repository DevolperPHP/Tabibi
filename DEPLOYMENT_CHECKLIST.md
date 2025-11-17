# ✅ DEPLOYMENT CHECKLIST

## Pre-Deployment Verification

### Firebase Configuration ✅
- [x] google-services.json → android/app/
- [x] GoogleService-Info.plist → ios/Runner/
- [x] serviceAccountKey.json → tabibi-backend/config/
- [x] Firebase dependencies installed
- [x] Firebase Admin tested successfully

### Backend Code ✅
- [x] FCM service created (services/fcmService.js)
- [x] FCM token route created (routes/user/fcm-token.js)
- [x] Notifications updated to send FCM
- [x] User model updated (fcmToken field)
- [x] Backend dependencies installed
- [x] All routes registered

### Flutter App ✅
- [x] FCM service created (fcm_notification_service.dart)
- [x] Firebase initialized in main.dart
- [x] Storage controller updated (getUserId)
- [x] API constants updated
- [x] All Flutter dependencies installed

### Security ✅
- [x] Firebase files added to .gitignore (root)
- [x] Firebase files added to .gitignore (backend)
- [x] Service account key in config directory
- [x] Proper file permissions set

## Deployment Steps

### 1. Deploy Backend to Production
**Run this command:**
```bash
./deploy_to_production.sh 165.232.78.163 root /var/www/tabibi-backend
```

**What it does:**
- Creates backup of existing deployment
- Copies backend files to server
- Installs dependencies
- Sets up PM2 process manager
- Tests Firebase Admin SDK
- Starts the service

**Expected output:**
```
🎉 DEPLOYMENT COMPLETE!
Backend URL: http://165.232.78.163:3000
```

### 2. Update Environment Variables
On your production server, edit `/var/www/tabibi-backend/.env`:
```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://username:password@host:port/database
JWT_SECRET=your-very-secure-jwt-secret
GOOGLE_APPLICATION_CREDENTIALS=/var/www/tabibi-backend/config/serviceAccountKey.json
```

**To edit:**
```bash
ssh root@165.232.78.163
nano /var/www/tabibi-backend/.env
# Update MONGODB_URI and JWT_SECRET
# Save and exit (Ctrl+X, Y, Enter)

# Restart backend
pm2 restart tabibi-backend
```

### 3. Build Flutter App
```bash
flutter build apk --release
```

### 4. Test Deployment
**Test backend is running:**
```bash
curl http://165.232.78.163:3000/notifications/test
```
Expected: `404` or JSON response

**Get a user ID from MongoDB:**
```bash
# Connect to your MongoDB
# Find a user and note their _id

# Then test notification:
python3 test_notifications.py test-single USER_ID_FROM_MONGODB
```

Expected: Notification sent successfully

## Manual Deployment (Alternative)

If the script doesn't work, deploy manually:

### Backend
```bash
# 1. Copy files
rsync -avz --exclude='node_modules' --exclude='.git' \
  ./tabibi-backend/ \
  root@165.232.78.163:/var/www/tabibi-backend/

# 2. SSH to server
ssh root@165.232.78.163

# 3. Install dependencies
cd /var/www/tabibi-backend
npm install --production

# 4. Update .env (see step 2 above)

# 5. Test Firebase
node -e "try { const admin = require('firebase-admin'); admin.initializeApp(); console.log('OK'); } catch(e) { console.log(e); }"

# 6. Start with PM2
pm2 start app.js --name tabibi-backend
pm2 save
```

### Flutter App
```bash
# 1. Clean
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Build
flutter build apk --release

# 4. Install
flutter install
```

## Verification Tests

### Test 1: Backend Health Check
```bash
curl http://165.232.78.163:3000/notifications/test
```
**Expected:** 404 or valid JSON response

### Test 2: Firebase Admin
On server:
```bash
ssh root@165.232.78.163
cd /var/www/tabibi-backend
node -e "const admin = require('firebase-admin'); const svc = require('./config/serviceAccountKey.json'); admin.initializeApp({ credential: admin.credential.cert(svc) }); console.log('✅ Firebase Admin Working');"
```
**Expected:** ✅ Firebase Admin Working

### Test 3: FCM Token Update
```bash
# Get user ID from MongoDB
# Update their FCM token
python3 test_notifications.py update-token USER_ID "test-fcm-token-123"
```
**Expected:** ✅ FCM token updated successfully!

### Test 4: Send Push Notification
```bash
python3 test_notifications.py test-single USER_ID
```
**Expected:** ✅ Notification sent successfully!

## Troubleshooting

### Backend Won't Start
```bash
# Check logs
pm2 logs tabibi-backend

# Check status
pm2 list

# Restart
pm2 restart tabibi-backend

# Check if port is in use
netstat -tulpn | grep 3000
```

### Firebase Errors
```bash
# Verify service account key exists
ls -la /var/www/tabibi-backend/config/

# Check permissions
chmod 600 /var/www/tabibi-backend/config/serviceAccountKey.json

# Test Firebase Admin
node -e "console.log(require('firebase-admin'))"
```

### Push Notifications Not Working
1. Check backend logs: `pm2 logs tabibi-backend`
2. Verify user has `fcmToken` in MongoDB
3. Check Firebase Console for message delivery
4. Test with: `python3 test_notifications.py test-single USER_ID`

## Success Criteria

**Backend:**
- [ ] Running on PM2: `pm2 list` shows "online"
- [ ] API responding: curl returns 200/404 (not 500)
- [ ] Firebase Admin working: Test script passes
- [ ] No errors in logs: `pm2 logs tabibi-backend`

**Flutter App:**
- [ ] Builds successfully: `flutter build apk` works
- [ ] Firebase initialized: No init errors
- [ ] FCM token generated: Check logs
- [ ] Token saved to backend: Verify in MongoDB

**Notifications:**
- [ ] Can send test notification: Python script succeeds
- [ ] User receives push notification on device
- [ ] Notification saved to MongoDB
- [ ] Works when app is in foreground
- [ ] Works when app is in background
- [ ] Works when app is closed

## Quick Commands Reference

```bash
# Deploy backend
./deploy_to_production.sh 165.232.78.163 root /var/www/tabibi-backend

# Check backend status
pm2 list

# View logs
pm2 logs tabibi-backend

# Restart backend
pm2 restart tabibi-backend

# Build Flutter app
flutter build apk --release

# Test notification
python3 test_notifications.py test-single USER_ID
```

## Final Checklist Before Going Live

- [ ] Backend deployed and running on production
- [ ] MongoDB URI updated in .env
- [ ] JWT secret updated in .env
- [ ] Firebase credentials working
- [ ] Test notification sent successfully
- [ ] Flutter app builds and installs
- [ ] FCM token saves to backend
- [ ] Users can receive push notifications
- [ ] Firewall configured (port 3000 open)
- [ ] HTTPS configured for production
- [ ] Monitoring set up (PM2 logs)

## Support

If something doesn't work:

1. Check logs: `pm2 logs tabibi-backend`
2. Check status: `pm2 list`
3. Test API: `curl http://165.232.78.163:3000/notifications/test`
4. Review documentation in `PRODUCTION_DEPLOYMENT_READY.md`

---

**Everything is ready! Run the deployment script and you're live!** 🚀
