import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/screens/doctor/payment_webview.dart';
import 'doctor_case_controller.dart';

class PaymentGetwayController extends GetxController {
  // خصائص
  final formKey = GlobalKey<FormState>();
  DoctorCaseController doctorCaseController = Get.find<DoctorCaseController>();
  RxBool isLoading = false.obs;
  RxBool agreedToTerms = false.obs;
  final TextEditingController numberCard = TextEditingController();
  final TextEditingController expierDate = TextEditingController();
  final TextEditingController passwordCard = TextEditingController();
  final TextEditingController fullName = TextEditingController();
 
  void completeOrder() async {
    if (!agreedToTerms.value) {
      Get.snackbar(
        'تنبيه',
        'يجب الموافقة على الشروط والأحكام',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (doctorCaseController.doctorCase.value == null) {
      Get.snackbar(
        'خطأ',
        'لم يتم اختيار حالة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading(true);
    
    try {
      String caseId = doctorCaseController.doctorCase.value!.id;
      
      // Navigate to WebView payment page
      Get.to(() => PaymentWebView(caseId: caseId));
      
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء معالجة الدفع',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
