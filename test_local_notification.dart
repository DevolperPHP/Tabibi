import 'package:my_doctor/services/fcm_notification_service.dart';

// Test local notification
void testLocalNotification() async {
  await FCMNotificationService.showLocalNotification(
    title: 'Test Notification',
    body: 'This is a local notification test!',
    payload: 'test-payload',
  );
  print('✅ Local notification sent!');
}
