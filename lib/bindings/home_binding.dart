import 'package:get/get.dart';
import 'package:tabibi/controllers/request_doctor_role_controller.dart'
    show RequestDoctorRoleController;

import '../controllers/admin_controller.dart';
import '../controllers/case_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/doctor_case_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/payment_getway_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/request_admin_role_controller.dart';
import '../services/guid_image/app_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CaseController>(() => CaseController(), fenix: true);
    Get.lazyPut<AdminController>(() => AdminController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<RequestAdminRoleController>(() => RequestAdminRoleController(),
        fenix: true);
    Get.lazyPut<RequestDoctorRoleController>(
        () => RequestDoctorRoleController(),
        fenix: true);
    Get.lazyPut<PaymentGetwayController>(() => PaymentGetwayController(),
        fenix: true);
    Get.lazyPut<DoctorCaseController>(() => DoctorCaseController(),
        fenix: true);
  }
}
