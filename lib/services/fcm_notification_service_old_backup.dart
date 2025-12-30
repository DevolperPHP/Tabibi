import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tabibi/services/api_service.dart';
import 'package:tabibi/utils/constants/api_constants.dart';
import 'package:tabibi/controllers/storage_controller.dart';

/// FCM Notification Service - Rebuilt from scratch for iOS compatibility
/// Handles all push notifications with proper error handling and logging
class FCMNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Track if FCM is properly initialized
  static bool _isInitialized = false;
  static String? _currentToken;

  /// Notification channel configuration for Android
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'tabibi_high_importance_channel', // id
    'إشعارات طبيبي الهامة', // name
    description: 'قناة الإشعارات العاجلة والمهمة من تطبيق طبيبي',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'tabibi_high_importance_channel',
    'إشعارات طبيبي الهامة',
    channelDescription: 'قناة الإشعارات العاجلة والمهمة من تطبيق طبيبي',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    icon: '@mipmap/ic_launcher',
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'default',
    badgeNumber: 1,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  /// Initialize FCM and local notifications
  /// Call this once during app startup
  static Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️  FCM already initialized, skipping...');
      return;
    }

    try {
      print('🔄 Initializing FCM Notification Service...');

      // Step 1: Request iOS permissions first (critical for iOS)
      await _requestPermissions();

      // Step 2: Initialize local notifications
      await _initializeLocalNotifications();

      // Step 3: Create Android notification channel
      await _createAndroidNotificationChannel();

      // Step 4: Setup message handlers
      _setupMessageHandlers();

      // Step 5: Get and save FCM token
      await _initializeFCMToken();

      // Step 6: Setup token refresh listener
      _setupTokenRefreshListener();

      _isInitialized = true;
      print('✅ FCM Notification Service initialized successfully');
    } catch (e, stackTrace) {
      print('❌ FCM initialization error: $e');
      print('Stack trace: $stackTrace');
      // Don't throw - allow app to continue without notifications
    }
  }

  /// Request notification permissions (iOS requires explicit request)
  static Future<void> _requestPermissions() async {
    try {
      print('📱 Requesting notification permissions...');
      
      final NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('⚠️  User granted provisional permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ User denied notification permission');
      } else {
        print('⚠️  Notification permission status: ${settings.authorizationStatus}');
      }
    } catch (e) {
      print('❌ Error requesting permissions: $e');
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
    print('📱 Got a message whilst in the foreground!');
    print('📊 Message data: ${message.data}');
    print('🔔 Message notification title: ${message.notification?.title}');
    print('📝 Message notification body: ${message.notification?.body}');

    // Save notification to backend database
    if (message.data.isNotEmpty) {
      String? userId = StorageController.getUserId();
      if (userId != null && userId.isNotEmpty) {
        print('💾 Saving notification to backend database...');
        final success = await NotificationService.sendNotification(
          userId: userId,
          title: message.notification?.title ?? 'إشعار جديد',
          body: message.notification?.body ?? '',
          type: message.data['type'] ?? 'general',
          relatedId: message.data['relatedId'],
        );
        if (success) {
          print('✅ Notification saved to backend database');
        } else {
          print('❌ Failed to save notification to backend database');
        }
      } else {
        print('⚠️  No user ID found, skipping backend save');
      }
    } else {
      print('⚠️  Message data is empty, skipping backend save');
    }

    // Show local notification
    print('🔔 Showing local notification...');
    await _showLocalNotification(message);
    print('✅ Local notification shown');
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
      print('🔑 FCM Token: ${token?.substring(0, 10)}...');

      if (token != null) {
        String? userId = StorageController.getStoredUserId();
        print('👤 User ID for FCM token: $userId');
        if (userId != null && userId.isNotEmpty) {
          print('💾 Saving FCM token to backend...');
          // Save token to your backend
          // You can create an API endpoint to save this token
          await _sendTokenToBackend(userId, token);
        } else {
          print('⚠️  User not logged in, will retry later');
          // Try again after a delay when user might be logged in
          Future.delayed(Duration(seconds: 10), () {
            _saveFCMToken();
          });
        }
      } else {
        print('❌ Failed to get FCM token');
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  /// Send token to backend
  static Future<void> _sendTokenToBackend(String userId, String token) async {
    try {
      print('📤 Sending token to backend...');
      final response = await ApiService.putData(
        ApiConstants.fcmTokenUpdate(userId), 
        {'token': token}
      );
      if (response.isStateSucess < 3) {
        print('✅ Token saved to backend for user: $userId');
      } else {
        print('❌ Failed to save token to backend: State ${response.isStateSucess}');
      }
    } catch (e) {
      print('❌ Error saving FCM token to backend: $e');
      // Retry after a delay
      Future.delayed(Duration(seconds: 30), () {
        _sendTokenToBackend(userId, token);
      });
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
