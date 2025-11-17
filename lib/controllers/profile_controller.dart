import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/controllers/storage_controller.dart';
import 'package:my_doctor/utils/constants/color_app.dart';

import '../data/models/profile_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../views/widgets/message_snak.dart';

class ProfileController extends GetxController {
  RxBool isLoading = RxBool(false);
  RxBool isError = RxBool(false);
  Rx<UserModel?> userProfile = Rx(null);
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController telegram = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxString city = ''.obs;
  RxString zone = ''.obs;
  RxString bp = 'no'.obs;
  RxString diabetic = 'no'.obs;
  RxString toothRemoved = 'no'.obs;
  RxString tf = 'no'.obs;
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

  //
  @override
  void onInit() {
    super.onInit();
    fetchDataProfile();
  }

  void fullDataUpdate() {
    name.text = userProfile.value!.userData.name;
    age.text = userProfile.value!.userData.age.toString();
    city.value = userProfile.value!.userData.city;
    zone.value = userProfile.value!.userData.zone ?? '';
    phone.text = userProfile.value!.userData.phone ?? '';
    telegram.text = userProfile.value!.userData.telegram ?? '';
    bp.value = userProfile.value!.userData.bp;
    diabetic.value = userProfile.value!.userData.diabetic;
    toothRemoved.value = userProfile.value!.userData.toothRemoved;
    tf.value = userProfile.value!.userData.tf;
    Get.toNamed(AppRoutes.profileEdit);
  }

  void logout() {
    Get.offAllNamed(AppRoutes.login);
  }

//Update profile
  Future<void> updataProfile() async {
    isLoading(true);

    try {
      // Determine the zone value to save
      String zoneValueToSave;
      if (zone.value.contains('في حال عدم وجود')) {
        zoneValueToSave = 'غير محدد';
      } else {
        zoneValueToSave = zone.value.trim();
      }

      final StateReturnData response = await ApiService.putData(
          ApiConstants.profileUpdate, {
        'name': name.text.trim(),
        'age': age.text.trim(),
        'city': city.value.trim(),
        'zone': zoneValueToSave,
        'phone': phone.text.trim(),
        'telegram': telegram.text.trim(),
        'bp': bp.value,
        'diabetic': diabetic.value,
        'toothRemoved': toothRemoved.value,
        'tf': tf.value,
      });

      if (response.isStateSucess < 3) {
        fetchDataProfile();
        Get.back();
        MessageSnak.message("تم تحديث البيانات بنجاح",
            color: ColorApp.greenColor);
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }

//Delete account
  void deleteConfig() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد حذف الحساب'),
        content: Text('هل أنت متأكد أنك تريد حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('إلغاء'),
          ),
          Obx(() {
            return isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: () async {
                      isLoading(true);
                      await deleteAccount();
                    },
                    child: const Text('حذف', style: TextStyle(color: Colors.red)),
                  );
          }),
        ],
      ),
    );
  }
  
  // Logout function
  void logoutConfig() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجل الخروج'),
        content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              StorageController.deleteAllData();
              Get.offAllNamed(AppRoutes.login);
            },
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.deleteData(ApiConstants.profileDelete);

      print(response.data);

      if (response.isStateSucess < 3) {
        Get.offAllNamed(AppRoutes.login);
        MessageSnak.message("تم حذف الحساب بنجاح", color: ColorApp.greenColor);
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }

// Cancel case
  Future<void> cancelCase(String caseId) async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.deleteData(ApiConstants.caseCancel(caseId));

      if (response.isStateSucess < 3) {
        await fetchDataProfile();
        MessageSnak.message("تم إلغاء الحالة بنجاح", color: ColorApp.greenColor);
      }
    } catch (e) {
      MessageSnak.message("خطأ في إلغاء الحالة: $e");
      print("خطأ في إلغاء الحالة: $e");
    }

    isLoading.value = false;
  }

//Cases
  Future<void> fetchDataProfile() async {
    isError(false);
    isLoading(true);

    // Debug: Check if token exists
    print("Fetching profile data...");
    print("Check login status: ${StorageController.checkLoginStatus()}");
    print("Token: ${StorageController.getToken()}");

    try {
      // Update token before making request
      ApiService.updateToken();

      final StateReturnData response =
          await ApiService.getData(ApiConstants.profile);

      print("Profile API response state: ${response.isStateSucess}");
      print("Profile API response data: ${response.data}");

      if (response.isStateSucess < 3) {
        userProfile(null);
        userProfile.value = UserModel.fromJson(response.data);
      } else {
        // API returned an error state
        isError(true);
        print("Profile API returned error state");
      }
    } catch (e) {
      // Network error or exception
      isError(true);
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }
}
