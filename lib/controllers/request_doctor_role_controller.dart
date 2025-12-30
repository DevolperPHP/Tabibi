import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibi/views/widgets/message_snak.dart';
import 'package:dio/dio.dart' as dio;
import '../data/models/profile_model.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';
import '../views/widgets/more_widgets.dart';
import 'profile_controller.dart';

class RequestDoctorRoleController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController profileTelegram = TextEditingController();
  TextEditingController uni = TextEditingController(); // University name
  Rx<UserData?> userProfile = Rx(null);
  final formKey = GlobalKey<FormState>();
  ProfileController profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    fetchDataRouls();
  }

  Future<void> fetchDataRouls() async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.profileRoleDoctor);

      if (response.isStateSucess < 3) {
        userProfile(null);
        userProfile.value = UserData.fromJson(response.data);
        name.text = userProfile.value!.name;
        age.text = userProfile.value!.age.toString();
        // Default city to Baghdad (read-only)
        city.text = 'بغداد';
        gender.text = userProfile.value!.gender;
        // Auto-fill telegram from user data
        profileTelegram.text = userProfile.value!.telegram ?? '';
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }

// Insert image
  Rx<File?> image = Rx<File?>(null);

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);

      // cropImage(File(pickedFile.path));
    }
    Get.back();
  }

  void selectImage() {
    showImagePicker(
        onPressedCamera: (() => pickImage(ImageSource.camera)),
        onPressedGallery: () => pickImage(ImageSource.gallery));
  }

  void sendRequest() async {
    if (formKey.currentState!.validate()) {
      if (image.value != null) {
        isLoading(true);
        try {
          dio.FormData formData = dio.FormData.fromMap({
            'telegram': profileTelegram.text.trim(),
            'uni': uni.text.trim(), // University name
            "image": await dio.MultipartFile.fromFile(image.value!.path,
                filename: image.value!.path.split('/').last)
          });

          StateReturnData data = await ApiService.putData(
              ApiConstants.roleDoctorRequests, formData);
          if (data.isStateSucess <= 2) {
            await profileController.fetchDataProfile();
            Get.back();
            MessageSnak.message('تم اضافة الحالة', color: ColorApp.greenColor);
          } else {
            // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
            // print(data.data);
            MessageSnak.message('تم رفع الطلب مسبقا وما زال العمل عليه');
          }
        } catch (e) {
          MessageSnak.message('تأكد من الاتصال ');
        } finally {
          isLoading(false);
        }

        isLoading(false);
      } else {
        MessageSnak.message('يجيب اضافة صورة الشهادة او الهوية الجامعية');
      }
    }
  }
}
