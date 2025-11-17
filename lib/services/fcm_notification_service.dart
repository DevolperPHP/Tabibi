import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:my_doctor/services/notification_service.dart';
import 'package:my_doctor/services/api_service.dart';
import 'package:my_doctor/utils/constants/api_constants.dart';
import 'package:my_doctor/controllers/storage_controller.dart';

class FCMNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'high_importance_channel',
    'إشعارات عالية الأهمية',
    channelDescription: 'هذه القناة للرسائل والتذكيرات المهمة',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  /// Initialize FCM and local notifications
  static Future<void> initialize() async {
    // Request permission for iOS
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Get initial message (when app is closed and opened from notification)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Get and save FCM token
    await _saveFCMToken();
  }

  /// Request notification permissions
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');

    // Save notification to backend database
    if (message.data.isNotEmpty) {
      String? userId = StorageController.getUserId();
      if (userId != null && userId.isNotEmpty) {
        await NotificationService.sendNotification(
          userId: userId,
          title: message.notification?.title ?? 'إشعار جديد',
          body: message.notification?.body ?? '',
          type: message.data['type'] ?? 'general',
          relatedId: message.data['relatedId'],
        );
      }
    }

    // Show local notification
    await _showLocalNotification(message);
  }

  /// Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped!');
    print('Message data: ${message.data}');

    // Navigate to relevant screen based on notification type
    String notificationType = message.data['type'] ?? '';
    _navigateBasedOnType(notificationType, message.data['relatedId']);
  }

  /// Handle local notification response
  static void _onDidReceiveNotificationResponse(
      NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    // Handle local notification tap if needed
  }

  /// Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      _notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// Save FCM token to backend
  static Future<void> _saveFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      if (token != null) {
        String? userId = StorageController.getStoredUserId();
        print('User ID for FCM token: $userId');
        if (userId != null && userId.isNotEmpty) {
          // Save token to your backend
          // You can create an API endpoint to save this token
          await _sendTokenToBackend(userId, token);
        } else {
          print('User not logged in, will retry later');
        }
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Send token to backend
  static Future<void> _sendTokenToBackend(String userId, String token) async {
    try {
      await ApiService.putData(ApiConstants.fcmTokenUpdate(userId), {'token': token});
      print('Token saved to backend for user: $userId');
    } catch (e) {
      print('Error saving FCM token to backend: $e');
    }
  }

  /// Navigate based on notification type
  static void _navigateBasedOnType(String type, String? relatedId) {
    switch (type) {
      case 'case_created':
        // Navigate to case details
        Get.toNamed('/case-details', arguments: relatedId);
        break;
      case 'case_accepted':
        // Navigate to case details
        Get.toNamed('/case-details', arguments: relatedId);
        break;
      case 'case_rejected':
        // Navigate to case details
        Get.toNamed('/case-details', arguments: relatedId);
        break;
      case 'case_taken':
        // Navigate to case details
        Get.toNamed('/case-details', arguments: relatedId);
        break;
      case 'teeth_health_tip':
        // Navigate to health tips
        Get.toNamed('/health-tips');
        break;
      case 'appointment_reminder':
        // Navigate to appointments
        Get.toNamed('/appointments');
        break;
      default:
        // Navigate to notifications screen
        Get.toNamed('/notifications');
    }
  }

  /// Get current FCM token
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Save FCM token after login
  static Future<void> saveTokenAfterLogin() async {
    await _saveFCMToken();
  }

  /// Refresh FCM token
  static Future<void> refreshToken() async {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      String? userId = StorageController.getStoredUserId();
      if (userId != null && userId.isNotEmpty) {
        _sendTokenToBackend(userId, newToken);
      }
    });
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Show local notification manually
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }
}
