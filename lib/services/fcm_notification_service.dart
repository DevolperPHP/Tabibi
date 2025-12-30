import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tabibi/services/api_service.dart';
import 'package:tabibi/utils/constants/api_constants.dart';
import 'package:tabibi/controllers/storage_controller.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📨 [Background] Handling message: ${message.messageId}');
  print('📊 [Background] Data: ${message.data}');
  print('🔔 [Background] Notification: ${message.notification?.title}');
}

/// FCM Notification Service - Rebuilt from scratch for iOS & Android
/// Senior Engineer Implementation with proper error handling
class FCMNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static String? _currentFCMToken;

  /// Android notification channel
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'tabibi_notifications', // id
    'إشعارات طبيبي', // name
    description: 'إشعارات التطبيق الهامة',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  /// Android notification details
  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    'tabibi_notifications',
    'إشعارات طبيبي',
    channelDescription: 'إشعارات التطبيق الهامة',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    icon: '@mipmap/ic_launcher',
  );

  /// iOS notification details
  static const DarwinNotificationDetails _iOSDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'default',
  );

  /// Combined notification details
  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidDetails,
    iOS: _iOSDetails,
  );

  /// =================================================================
  /// MAIN INITIALIZATION
  /// =================================================================
  
  /// Initialize FCM service - call once at app startup
  static Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️  FCM already initialized');
      return;
    }

    try {
      print('🚀 [FCM] Initializing notification service...');

      // 1. Request permissions (critical for iOS)
      await _requestPermissions();

      // 2. Initialize local notifications
      await _initializeLocalNotifications();

      // 3. Create Android notification channel
      if (Platform.isAndroid) {
        await _createAndroidChannel();
      }

      // 4. Setup message handlers
      _setupMessageHandlers();

      // 5. Get and save FCM token
      await _initializeFCMToken();

      // 6. Listen for token refresh
      _setupTokenRefreshListener();

      _isInitialized = true;
      print('✅ [FCM] Initialization complete');
    } catch (e, stack) {
      print('❌ [FCM] Initialization failed: $e');
      print('Stack: $stack');
    }
  }

  /// =================================================================
  /// PERMISSION HANDLING
  /// =================================================================
  
  static Future<void> _requestPermissions() async {
    try {
      print('📱 [FCM] Requesting notification permissions...');

      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          print('✅ [FCM] User granted permission');
          break;
        case AuthorizationStatus.provisional:
          print('⚠️  [FCM] User granted provisional permission');
          break;
        case AuthorizationStatus.denied:
          print('❌ [FCM] User denied permission');
          break;
        case AuthorizationStatus.notDetermined:
          print('⚠️  [FCM] Permission not determined');
          break;
      }

      // iOS specific: Set foreground notification presentation options
      if (Platform.isIOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        print('✅ [FCM] iOS foreground options set');
      }
    } catch (e) {
      print('❌ [FCM] Permission request error: $e');
    }
  }

  /// =================================================================
  /// LOCAL NOTIFICATIONS SETUP
  /// =================================================================
  
  static Future<void> _initializeLocalNotifications() async {
    try {
      print('📲 [FCM] Initializing local notifications...');

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iOSSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      print('✅ [FCM] Local notifications initialized');
    } catch (e) {
      print('❌ [FCM] Local notification init error: $e');
    }
  }

  static Future<void> _createAndroidChannel() async {
    try {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
      print('✅ [FCM] Android channel created');
    } catch (e) {
      print('❌ [FCM] Android channel error: $e');
    }
  }

  /// =================================================================
  /// MESSAGE HANDLERS
  /// =================================================================
  
  static void _setupMessageHandlers() {
    print('📡 [FCM] Setting up message handlers...');

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // When app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from terminated state
    _checkInitialMessage();

    print('✅ [FCM] Message handlers configured');
  }

  /// Handle messages when app is in foreground
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 [Foreground] Received: ${message.messageId}');
    print('📊 [Foreground] Data: ${message.data}');
    print('🔔 [Foreground] Title: ${message.notification?.title}');
    print('📝 [Foreground] Body: ${message.notification?.body}');

    // Show local notification
    await _showLocalNotification(message);
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    print('👆 [Tap] Notification tapped: ${message.messageId}');
    print('📊 [Tap] Data: ${message.data}');
    
    final type = message.data['type'] ?? '';
    final relatedId = message.data['relatedId'];
    
    _navigateBasedOnType(type, relatedId);
  }

  /// Handle tap on local notification
  static void _onNotificationTapped(NotificationResponse response) {
    print('👆 [Local Tap] Payload: ${response.payload}');
    // You can parse payload and navigate if needed
  }

  /// Check if app was opened from terminated state via notification
  static Future<void> _checkInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('📬 [Initial] App opened from notification: ${initialMessage.messageId}');
        _handleNotificationTap(initialMessage);
      }
    } catch (e) {
      print('❌ [Initial] Error checking initial message: $e');
    }
  }

  /// =================================================================
  /// SHOW LOCAL NOTIFICATION
  /// =================================================================
  
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ?? 'إشعار جديد';
      final body = message.notification?.body ?? '';
      
      await _localNotifications.show(
        message.hashCode,
        title,
        body,
        _notificationDetails,
        payload: message.data.toString(),
      );
      
      print('✅ [Local] Notification shown');
    } catch (e) {
      print('❌ [Local] Show notification error: $e');
    }
  }

  /// =================================================================
  /// FCM TOKEN MANAGEMENT
  /// =================================================================
  
  static Future<void> _initializeFCMToken() async {
    try {
      print('🔑 [FCM] Getting token...');
      
      final token = await _firebaseMessaging.getToken();
      
      if (token != null) {
        _currentFCMToken = token;
        print('🔑 [FCM] Token: ${token.substring(0, 20)}...');
        
        // Try to save token if user is logged in
        await _saveTokenToBackend(token);
      } else {
        print('⚠️  [FCM] Failed to get token');
      }
    } catch (e) {
      print('❌ [FCM] Token error: $e');
    }
  }

  static void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('🔄 [FCM] Token refreshed: ${newToken.substring(0, 20)}...');
      _currentFCMToken = newToken;
      _saveTokenToBackend(newToken);
    });
  }

  static Future<void> _saveTokenToBackend(String token) async {
    try {
      final userId = StorageController.getStoredUserId();
      
      if (userId == null || userId.isEmpty) {
        print('⚠️  [FCM] User not logged in, token not saved (will retry after login)');
        return;
      }

      print('💾 [FCM] Saving token to backend for user: $userId');

      final response = await ApiService.putData(
        ApiConstants.fcmTokenUpdate(userId),
        {'fcmToken': token},
      );

      if (response.isStateSucess < 3) {
        print('✅ [FCM] Token saved successfully');
      } else {
        print('❌ [FCM] Token save failed: State ${response.isStateSucess}');
        // Retry after 30 seconds
        Future.delayed(const Duration(seconds: 30), () {
          _saveTokenToBackend(token);
        });
      }
    } catch (e) {
      print('❌ [FCM] Error saving token: $e');
      // Retry after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        _saveTokenToBackend(token);
      });
    }
  }

  /// =================================================================
  /// PUBLIC METHODS
  /// =================================================================
  
  /// Call this after user logs in to save FCM token
  static Future<void> saveTokenAfterLogin() async {
    print('🔐 [FCM] User logged in, saving token...');
    if (_currentFCMToken != null) {
      await _saveTokenToBackend(_currentFCMToken!);
    } else {
      // Try to get token again
      await _initializeFCMToken();
    }
  }

  /// Get current FCM token
  static Future<String?> getToken() async {
    return _currentFCMToken ?? await _firebaseMessaging.getToken();
  }

  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ [FCM] Subscribed to topic: $topic');
    } catch (e) {
      print('❌ [FCM] Subscribe error: $e');
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ [FCM] Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ [FCM] Unsubscribe error: $e');
    }
  }

  /// Show local notification manually
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        _notificationDetails,
        payload: payload,
      );
    } catch (e) {
      print('❌ [FCM] Manual notification error: $e');
    }
  }

  /// =================================================================
  /// NAVIGATION
  /// =================================================================
  
  static void _navigateBasedOnType(String type, String? relatedId) {
    print('🧭 [Navigation] Type: $type, ID: $relatedId');
    
    switch (type) {
      case 'case_accepted':
      case 'case_rejected':
      case 'case_taken':
        // Navigate to case details or cases list
        try {
          Get.toNamed('/cases');
        } catch (e) {
          print('❌ [Navigation] Error: $e');
        }
        break;
        
      case 'case_created':
        // Navigate to admin cases
        try {
          Get.toNamed('/admin-cases');
        } catch (e) {
          print('❌ [Navigation] Error: $e');
        }
        break;
        
      case 'teeth_health_tip':
      case 'health_tip':
        // Navigate to health tips
        try {
          Get.toNamed('/health-tips');
        } catch (e) {
          print('❌ [Navigation] Error: $e');
        }
        break;
        
      case 'appointment_reminder':
        // Navigate to appointments
        try {
          Get.toNamed('/appointments');
        } catch (e) {
          print('❌ [Navigation] Error: $e');
        }
        break;
        
      default:
        // Navigate to notifications screen
        print('ℹ️  [Navigation] Unknown type, showing notification list');
    }
  }

  /// Force refresh token
  static Future<void> refreshToken() async {
    print('🔄 [FCM] Forcing token refresh...');
    try {
      await _firebaseMessaging.deleteToken();
      await _initializeFCMToken();
    } catch (e) {
      print('❌ [FCM] Refresh error: $e');
    }
  }
}
