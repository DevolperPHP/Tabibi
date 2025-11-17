# FCM Notification Sending Examples

## Using the FCM Service Directly

### Single User Notification
```javascript
const FCMService = require('./services/fcmService');

// Send to specific user
async function sendCaseNotification() {
  const user = await User.findById(userId);
  if (user.fcmToken) {
    await FCMService.sendCaseNotification(
      [user.fcmToken],
      caseId,
      'case_accepted',
      'Ahmed Ali'
    );
  }
}
```

### Multiple Users
```javascript
const FCMService = require('./services/fcmService');

// Send to multiple users
async function sendHealthTipToAll() {
  const users = await User.find({ fcmToken: { $ne: null } });
  const tokens = users.map(user => user.fcmToken);

  await FCMService.sendHealthTipNotification(
    tokens,
    tipId,
    'نصيحة صحية: نظف أسنانك مرتين يومياً'
  );
}
```

### Health Tip Notification
```javascript
const FCMService = require('./services/fcmService');

async function sendDailyHealthTip() {
  const users = await User.find({ fcmToken: { $exists: true } });
  const tokens = users.map(u => u.fcmToken).filter(t => t);

  if (tokens.length > 0) {
    await FCMService.sendToMultipleDevices(
      tokens,
      'نصائح صحية',
      'نصيحة اليوم: تجنب السكريات للحفاظ على أسنانك',
      { type: 'teeth_health_tip', relatedId: 'today-tip-id' }
    );
  }
}
```

## Using the API Routes

### Send to Single User
```bash
curl -X POST http://localhost:80/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "64a7b8c9d1e2f34567890abc",
    "title": "حالة جديدة",
    "body": "تم إنشاء حالة جديدة من أحمد",
    "type": "case_created",
    "relatedId": "64a7b8c9d1e2f34567890def"
  }'
```

### Send to Multiple Users
```bash
curl -X POST http://localhost:80/notifications/send-bulk \
  -H "Content-Type: application/json" \
  -d '{
    "userIds": [
      "64a7b8c9d1e2f34567890abc",
      "64a7b8c9d1e2f34567890def",
      "64a7b8c9d1e2f34567890ghi"
    ],
    "title": "تذكير",
    "body": "لا تنس زيارة طبيب الأسنان",
    "type": "appointment_reminder",
    "relatedId": "64a7b8c9d1e2f34567890xyz"
  }'
```

### Save FCM Token
```bash
curl -X PUT http://localhost:80/users/64a7b8c9d1e2f34567890abc/fcm-token \
  -H "Content-Type: application/json" \
  -d '{
    "token": "d9f8g7h6j5k4l3m2n1o0p9q8r7s6t5u4v3w2x1y0z"
  }'
```

## Using Postman

### 1. Create Notification Request
- **Method**: POST
- **URL**: `http://localhost:80/notifications/send`
- **Headers**: `Content-Type: application/json`
- **Body** (select "raw" and "JSON"):
```json
{
  "userId": "USER_ID_FROM_DATABASE",
  "title": "Test Notification",
  "body": "Hello from My Doctor app!",
  "type": "general",
  "relatedId": "optional-related-id"
}
```

### 2. Bulk Notifications
- **Method**: POST
- **URL**: `http://localhost:80/notifications/send-bulk`
- **Body**:
```json
{
  "userIds": ["id1", "id2", "id3"],
  "title": "Bulk Notification",
  "body": "Sent to multiple users",
  "type": "general"
}
```

## Automatic Integration

The notification system now works automatically when you:
- Create a case → Automatically sends `case_created` notification
- Accept a case → Automatically sends `case_accepted` notification
- Send health tips → Automatically sends to all users with FCM tokens

Just use the existing `NotificationService.sendNotification()` in your Flutter code, and it will:
1. Save to MongoDB (existing functionality)
2. Send FCM push notification (NEW!)

## Testing with curl

Test from terminal:

```bash
# Test single notification
curl -X POST http://localhost:80/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "PUT_USER_ID_HERE",
    "title": "Test from curl",
    "body": "This is a test notification",
    "type": "test"
  }'
```

## Response Format

Success response:
```json
{
  "msg": "Notification sent successfully",
  "notification": {
    "_id": "64a7b8c9d1e2f34567890abc",
    "userId": "64a7b8c9d1e2f34567890def",
    "title": "Test",
    "body": "Message",
    "type": "test",
    "isRead": false,
    "createdAt": "2025-01-01T00:00:00.000Z"
  }
}
```

Bulk notification response:
```json
{
  "msg": "Bulk notifications sent successfully",
  "count": 3,
  "pushNotificationsSent": 2
}
```

## Important Notes

1. **Token Required**: Users must have `fcmToken` in their User document
2. **Multiple Attempts**: If one device fails, others still receive
3. **Silent Failures**: Check backend logs for FCM errors
4. **Token Refresh**: Tokens change periodically - app handles this automatically

## Production Tips

1. **Monitor FCM Stats**: Check Firebase Console for delivery rates
2. **Error Handling**: Check `sendMulticast` response for failed tokens
3. **Rate Limits**: FCM has rate limits - batch notifications if needed
4. **Token Cleanup**: Remove invalid tokens from database periodically
