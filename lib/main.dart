// ignore_for_file: must_be_immutable
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'controllers/profile_controller.dart';
import 'controllers/storage_controller.dart';
import 'controllers/home_controller.dart';
import 'routes/app_routes.dart';
import 'utils/constants/color_app.dart';
import 'utils/constants/style_app.dart';
import 'utils/constants/values_constant.dart';
import 'views/screens/auth/initial_loading.dart';
import 'services/fcm_notification_service.dart';

// import 'app/services/update_cureent.dart';

late Future<void> _initializationFuture;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetSecureStorage FIRST, before any storage operations
  // IMPORTANT: Password is required for encryption. Must match across app restarts.
  await GetSecureStorage.init(password: Values.passwordStorage);

  // Initialize Firebase only for mobile platforms
  try {
    // Only initialize Firebase on Android and iOS
    if (!kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully');
    } else {
      print('⚠️ Running on web - Firebase initialization skipped');
    }
  } catch (e, stackTrace) {
    print('❌ Firebase initialization error: $e');
    print('Stack: $stackTrace');
    // Don't crash - continue without Firebase
  }

  // Initialize the app
  _initializationFuture = _initializeApp();

  try {
    runApp(MyApp());
  } catch (e, stackTrace) {
    print('❌ FATAL: $e');
    print('Stack: $stackTrace');
    // Show error screen instead of crashing
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('App crashed: $e'),
              SizedBox(height: 8),
              Text('$stackTrace',
                   style: TextStyle(fontSize: 10, color: Colors.grey),
                   textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ));
  }
}

Future<void> _initializeApp() async {
  try {
    ProfileController d = ProfileController();
    try {
      await d.fetchDataProfile();
      var userData = d.userProfile.value?.userData;
      if (userData != null) {
        await StorageController.updateUserData(userData);
        print('✅ User data loaded');
        
        // Save FCM token after successful profile load (user is logged in)
        try {
          if (Firebase.apps.isNotEmpty) {
            await FCMNotificationService.saveTokenAfterLogin();
            print('✅ FCM token saved after login');
          }
        } catch (fcmError) {
          print('⚠️  FCM token save error (non-critical): $fcmError');
        }
      }
    } catch (e) {
      print('❌ Profile fetch error: $e');
      // Continue without profile data
    }

    // Initialize FCM in background (don't wait)
    try {
      // Only initialize FCM if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        await FCMNotificationService.initialize();
        print('✅ FCM initialized successfully');
      }
    } catch (e) {
      print('❌ FCM error (continuing without): $e');
    }
  } catch (e) {
    print('❌ App initialization error: $e');
    // Don't rethrow - let app continue
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Add this widget as a lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer when widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app resumes from background, check for role updates
    if (state == AppLifecycleState.resumed) {
      _checkForRoleUpdates();
    }
  }

  /// Checks if user role has changed and updates navigation if needed
  Future<void> _checkForRoleUpdates() async {
    print('🔍 App resumed - checking for role updates...');

    // Only check if user is logged in
    if (!StorageController.checkLoginStatus()) {
      return;
    }

    try {
      // Store current role status before refresh
      bool wasDoctor = StorageController.isDoctor();
      bool wasAdmin = StorageController.isAdmin();

      // Refresh user data from API
      bool refreshed = await StorageController.refreshUserDataFromAPI();

      if (refreshed) {
        // Check if role changed
        bool isDoctor = StorageController.isDoctor();
        bool isAdmin = StorageController.isAdmin();

        if (wasDoctor != isDoctor || wasAdmin != isAdmin) {
          print('🎉 User role changed! wasDoctor: $wasDoctor -> $isDoctor, wasAdmin: $wasAdmin -> $isAdmin');

          // Find HomeController if it exists and refresh navigation
          try {
            if (Get.isRegistered<HomeController>()) {
              final homeController = Get.find<HomeController>();
              homeController.refreshNavigationItems();
              print('✅ Navigation items refreshed');
            }
          } catch (e) {
            print('⚠️ Could not find HomeController: $e');
          }
        }
      }
    } catch (e) {
      print('❌ Error checking role updates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // تخزين حجم الشاشه للاستخدام في كل التبطيق
    // في واجهات اخرى
    Values.width = MediaQuery.sizeOf(context).width;
    Values.height = MediaQuery.sizeOf(context).height;
    return ScreenUtilInit(
        designSize:
            Size(Values.width, Values.height), // حجم التصميم (عرض × ارتفاع)
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.cupertino,
              theme: ThemeData(
                  useMaterial3: true,
                  textTheme: GoogleFonts.cairoTextTheme().apply(
                    bodyColor: ColorApp.textPrimaryColor,
                    displayColor: ColorApp.textPrimaryColor,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.transparent,
                  ),
                  // textTheme: GoogleFonts.readexProTextTheme(),
                  fontFamily: 'cairo',
                  scaffoldBackgroundColor: ColorApp.backgroundColor,
                  appBarTheme: AppBarTheme(
                      backgroundColor: ColorApp.backgroundColor,
                      titleTextStyle: StringStyle.headerStyle,
                      centerTitle: true),
                  colorScheme: ColorScheme.fromSwatch(
                      backgroundColor: ColorApp.primaryColor)),
              builder: (context, child) {
                final mediaQuery = MediaQuery.of(context);
                // احسب معامل التحجيم بناءً على عرض الشاشة
                double textScaleFactor = mediaQuery.size.width / 400;

                return MediaQuery(
                    data: mediaQuery.copyWith(
                        textScaler:
                            TextScaler.linear(textScaleFactor.clamp(0.9, 1))),
                    child: Directionality(
                        textDirection: TextDirection.rtl, child: child!));
              },
              title: 'طبيبي',
              home: FutureBuilder(
                future: _initializationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If there was an error, still continue to the app
                    if (snapshot.hasError) {
                      print('❌ Initialization error: ${snapshot.error}');
                    }
                    // Navigate to appropriate screen after initialization
                    Future.microtask(() {
                      try {
                        Get.offAllNamed(
                          StorageController.checkLoginStatus()
                              ? AppRoutes.home
                              : AppRoutes.login,
                        );
                      } catch (e) {
                        print('❌ Navigation error: $e');
                        // Navigate to login as fallback
                        Get.offAllNamed(AppRoutes.login);
                      }
                    });
                    return Container(); // Temporary widget during navigation
                  }
                  // Show custom loading screen with circular logo
                  return InitialLoadingScreen();
                },
              ),
              getPages: AppRoutes.routes);
        });
  }
}
