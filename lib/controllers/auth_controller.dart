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
          await StorageController.storeData(data.data);
          ApiService.updateToken();
          MessageSnak.message('تم تسجيل الدخول', color: ColorApp.greenColor);
          await Future.delayed(Duration(seconds: 1));

          // Save FCM token after successful login
          await FCMNotificationService.saveTokenAfterLogin();

          isLoading(false);
          Get.offAndToNamed(AppRoutes.home);
        } else {
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

        // Determine the zone value to save
        String zoneValueToSave;
        if (zone.value.contains('في حال عدم وجود')) {
          zoneValueToSave = 'غير محدد';
        } else {
          zoneValueToSave = zone.value.trim();
        }

        StateReturnData data =
            await ApiService.postData(ApiConstants.register, {
          'name': fullName.text.trim(),
          'age': age.text.trim(),
          'city': city.value.trim(),
          'zone': zoneValueToSave,
          'email': email.text.trim(),
          'password': password.text.trim(),
          'phone': phone.text.trim(),
          'telegram': telegram.text.trim(),
          'gender': gender.value,
        });

        if (data.isStateSucess <= 2) {
          Get.back();
          Get.back();
          MessageSnak.message('تم أنشاء الحساب', color: ColorApp.greenColor);
          isLoading(false);
        } else {
          // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
          // print(data.data);
          if (data.data != null &&
              data.data is Map &&
              data.data.containsKey('message')) {
            MessageSnak.message(data.data['message'], color: ColorApp.redColor);
          } else {
            MessageSnak.message('حدث خطأ أثناء التسجيل',
                color: ColorApp.redColor);
          }
        }
      } catch (e) {
        MessageSnak.message('حصل خطا $e');
      } finally {
        await Future.delayed(Duration(seconds: 1));
        isLoading(false);
      }
    } else {
      MessageSnak.message('يرجى ملاء كل الحقول ');
    }
    isLoading(false);

    // Get.toNamed(AppRoutes.home);
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
    // تحرير الموارد عند إغلاق الـ Controller
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    fullName.dispose();
    age.dispose();
    jobTitle.dispose();
    nationality.dispose();
    phone.dispose();
    telegram.dispose();
    super.onClose();
  }
}
