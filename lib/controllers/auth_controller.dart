import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/fcm_notification_service.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';
import '../views/widgets/message_snak.dart';
import 'storage_controller.dart';

class AuthController extends GetxController {
  // خصائص
  RxBool isLoading = false.obs;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController nationality = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController telegram = TextEditingController();
  // OTP
  final TextEditingController otpController = TextEditingController();
  // اعادة ارسال ال OTP

  // City is now fixed to Baghdad only
  RxString city = 'بغداد'.obs;

  // Zone in Baghdad
  RxString zone = ''.obs;

  RxString gender = ''.obs;
  RxBool acceptTerms = false.obs;

  // OTP Related
  RxString otpMessageId = ''.obs;
  RxMap<String, dynamic> pendingRegistrationData = <String, dynamic>{}.obs;
  List<String> cites = [
    "بغداد",
    "البصرة",
    "نينوى",
    "أربيل",
    "السليمانية",
    "دهوك",
    "كركوك",
    "ذي قار",
    "واسط",
    "بابل",
    "كربلاء",
    "النجف",
    "المثنى",
    "ميسان",
    " ديالى",
    "صلاح الدين",
    " الأنبار",
    " القادسية",
  ];
  void submitFormOTP() async {
    isLoading(true);
    MessageSnak.message('تم التحقق من ال OTP', color: ColorApp.greenColor);
    await Future.delayed(Duration(seconds: 1));

    isLoading(false);
  }

  // Send OTP
  Future<void> sendOTP({required String phoneNumber}) async {
    isLoading(true);

    try {
      // Send phone number as-is (backend will format it)
      final response = await ApiService.postData(ApiConstants.sendOTP, {
        'phoneNumber': phoneNumber,
      });

      if (response.isStateSucess <= 2 && response.data != null) {
        otpMessageId.value = response.data['messageId'] ?? '';
        MessageSnak.message('تم إرسال رمز التحقق بنجاح',
            color: ColorApp.greenColor);
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      MessageSnak.message('فشل إرسال رمز التحقق', color: ColorApp.redColor);
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Verify OTP
  Future<void> verifyOTP({
    required String phoneNumber,
    required String otpCode,
  }) async {
    isLoading(true);

    try {
      final response = await ApiService.postData(ApiConstants.verifyOTP, {
        'messageId': otpMessageId.value,
        'code': otpCode,
      });

      if (response.isStateSucess <= 2 && response.data != null) {
        final verified = response.data['verified'] ?? false;

        if (verified) {
          // OTP verified successfully, now complete registration
          await _completeRegistration();
        } else {
          throw Exception('Invalid OTP');
        }
      } else {
        throw Exception('OTP verification failed');
      }
    } catch (e) {
      MessageSnak.message('رمز التحقق غير صحيح', color: ColorApp.redColor);
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Complete registration after OTP verification
  Future<void> _completeRegistration() async {
    try {
      final data = await ApiService.postData(ApiConstants.register, {
        'name': pendingRegistrationData['name'],
        'age': pendingRegistrationData['age'],
        'city': pendingRegistrationData['city'],
        'zone': pendingRegistrationData['zone'],
        'email': pendingRegistrationData['email'],
        'password': pendingRegistrationData['password'],
        'phone': pendingRegistrationData['phone'],
        'telegram': pendingRegistrationData['telegram'],
        'gender': pendingRegistrationData['gender'],
      });

      if (data.isStateSucess <= 2) {
        MessageSnak.message('تم إنشاء الحساب بنجاح',
            color: ColorApp.greenColor);
        // Clear form data before navigating
        clearForms();
        Get.offAllNamed(AppRoutes.login);
      } else {
        String errorMsg = 'حدث خطأ أثناء التسجيل';
        if (data.data != null &&
            data.data is Map &&
            data.data.containsKey('message')) {
          errorMsg = data.data['message'];
        }
        MessageSnak.message(errorMsg, color: ColorApp.redColor);
      }
    } catch (e) {
      MessageSnak.message('فشل إنشاء الحساب', color: ColorApp.redColor);
      rethrow;
    }
  }

  Rx<String?> selectedCountry = Rx('');
  void changeContry(String? newValue) {
    selectedCountry.value = newValue;
  }

  //تذكرني
  RxBool rememberMe = false.obs;
  void changeRememberMe(bool? value) {
    rememberMe.value = value!;
  }

  // مفتاح النموذج
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();
  final formKeyRePassword = GlobalKey<FormState>();
  void submitFormLogin() async {
    if (formKeyLogin.currentState!.validate()) {
      try {
        isLoading(true);

        StateReturnData data = await ApiService.postData(ApiConstants.login,
            {'email': email.text.trim(), 'password': password.text.trim()});

        if (data.isStateSucess <= 2) {
          // Check if user is banned
          if (data.data != null && data.data['isBanned'] == true) {
            isLoading(false);
            _showBannedUserDialog(data.data['banReason']);
            return;
          }

          await StorageController.storeData(data.data);
          ApiService.updateToken();
          MessageSnak.message('تم تسجيل الدخول', color: ColorApp.greenColor);
          await Future.delayed(Duration(seconds: 1));

          // Save FCM token after successful login
          await FCMNotificationService.saveTokenAfterLogin();

          isLoading(false);
          Get.offAndToNamed(AppRoutes.home);
        } else {
          // Check if user is banned (403 status)
          if (data.data != null && data.data['isBanned'] == true) {
            isLoading(false);
            _showBannedUserDialog(data.data['banReason']);
            return;
          }
          // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
          // print(data.data);
          MessageSnak.message('تأكد من بيانات الحساب',
              color: ColorApp.redColor);
        }
      } catch (e) {
        MessageSnak.message('يرجى تأكد من بيانات الحساب');
      } finally {
        await Future.delayed(Duration(seconds: 1));
        isLoading(false);
      }
    } else {
      MessageSnak.message('يرجى ملاء كل الحقول ');
    }
    isLoading(false);
  }

  // Show banned user dialog
  void _showBannedUserDialog(String? banReason) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.block, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text(
              'حسابك محظور',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'تم حظر حسابك. تواصل مع الدعم للمزيد من المعلومات',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'حسناً',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void submitFormRegister() async {
    // Validate form fields first
    if (formKeyRegister.currentState?.validate() ?? false) {
      // Manual validation for zone (not a FormField)
      if (zone.value.isEmpty) {
        MessageSnak.message('يرجى اختيار المنطقة', color: ColorApp.redColor);
        return;
      }

      // Manual validation for gender (not a FormField)
      if (gender.value.isEmpty) {
        MessageSnak.message('يرجى اختيار الجنس', color: ColorApp.redColor);
        return;
      }

      // Check terms acceptance
      if (!acceptTerms.value) {
        MessageSnak.message('يجب الموافقة على الشروط والأحكام',
            color: ColorApp.redColor);
        return;
      }

      try {
        isLoading(true);

        // Store pending registration data
        pendingRegistrationData.value = {
          'name': fullName.text.trim(),
          'age': age.text.trim(),
          'city': city.value.trim(),
          'zone': zone.value.contains('في حال عدم وجود')
              ? 'غير محدد'
              : zone.value.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'phone': phone.text.trim(),
          'telegram': telegram.text.trim(),
          'gender': gender.value,
        };

        // Send OTP to phone number
        await sendOTP(phoneNumber: phone.text.trim());

        // Navigate to OTP verification screen
        Get.toNamed(AppRoutes.otp);
      } catch (e) {
        MessageSnak.message('فشل إرسال رمز التحقق', color: ColorApp.redColor);
      } finally {
        await Future.delayed(Duration(seconds: 1));
        isLoading(false);
      }
    } else {
      MessageSnak.message('يرجى ملء كل الحقول المطلوبة',
          color: ColorApp.redColor);
    }
    isLoading(false);
  }

  void submitFormRePassword() async {
    isLoading(true);

    // MessageSnak.message('تم اعادة كلمة المرور   ', color: ColorApp.greenColor);

    await Future.delayed(Duration(seconds: 1));
    // Get.toNamed(AppRoutes.home);
    isLoading(false);
  }

  @override
  void onClose() {
    // Don't dispose controllers - fenix: true will reuse this controller
    // Just call super to complete the lifecycle
    super.onClose();
  }

  // Clear all form fields
  void clearForms() {
    email.clear();
    password.clear();
    confirmPassword.clear();
    fullName.clear();
    age.clear();
    jobTitle.clear();
    nationality.clear();
    phone.clear();
    telegram.clear();
    zone.value = '';
    gender.value = '';
    acceptTerms.value = false;
    otpMessageId.value = '';
    pendingRegistrationData.clear();
  }
}
