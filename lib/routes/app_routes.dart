import 'package:get/get.dart';

import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../views/screens/admin/edit_post.dart';
import '../views/screens/admin/new_post.dart';
import '../views/screens/admin/post_view.dart';
import '../views/screens/admin/view_details_role.dart';
import '../views/screens/auth/login.dart';
import '../views/screens/auth/re_password.dart';
import '../views/screens/auth/register.dart';
import '../views/screens/auth/modern_register.dart';
import '../views/screens/auth/register_test.dart';
import '../views/screens/auth/otp_verification_screen.dart';
import '../views/screens/categores_and_cases/accept_case_screen.dart';
import '../views/screens/categores_and_cases/add_category.dart';
import '../views/screens/categores_and_cases/case_details_screen.dart';
import '../views/screens/categores_and_cases/edit_category.dart';
import '../views/screens/categores_and_cases/reject_case_screen.dart';
import '../views/screens/doctor/complete_case.dart';
import '../views/screens/doctor/create_case.dart';
import '../views/screens/doctor/payment_gateway.dart';
import '../views/screens/doctor/request_doctor_role.dart';
import '../views/screens/doctor/select_care_required.dart';
import '../views/screens/doctor/payment_return.dart';
import '../views/screens/doctor/view_case.dart';
import '../views/screens/doctor/view_cases.dart';
import '../views/screens/home/home_screen.dart';
import '../views/screens/notifications/notifications_screen.dart';
import '../views/screens/admin/health_tips_screen.dart';
import '../views/screens/profile/profile_edit.dart';
import '../views/screens/profile/faq_screen.dart';
import '../views/screens/user/user_case_details_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/Register';
  static const modernRegister = '/modern-register';
  static const registerTest = '/register-test';
  static const otp = '/otp';
  static const rePassword = '/rePassword';
  static const home = '/home';
  static const badgeScreen = '/badge-screen';
  static const createCase = '/Create-Case';
  static const completeCase = '/Complete-Case';

  static const locations = '/locations';
  static const viewDetailsFood = '/ViewDetailsFood';
  static const profileScreen = '/ProfileScreen';
  static const viewDoctorCases = '/View-Doctor-Cases';
  static const viewDoctorCase = '/View-Doctor-Case';
  static const paymentGateway = '/Payment-Gateway';
  static const paymentReturn = '/doctor/payment/return';
  static const postView = '/Post-View';
  static const postNew = '/Post-New';
  static const postEdit = '/Post-Edit';
  static const profileEdit = '/Profile-Edit';
  static const requestDoctorRole = '/Request-Doctor-Role';
  static const viewDetailsRole = '/View-Details-Role';
  static const addCategory = '/Add-Category';
  static const editCategory = '/Edit-Category';
  static const caseDetailsScreen = '/Case-Details-Screen';
  static const acceptCaseScreen = '/Accept-Case-Screen';
  static const rejectCaseScreen = '/Reject-Case-Screen';
  static const selectCareRequired = '/Select-Care-Required';
  static const userCaseDetails = '/User-Case-Details';
  static const faqScreen = '/FAQ-Screen';
  static const notifications = '/notifications';
  static const healthTips = '/admin/health-tips';

  static final routes = [
    GetPage(
        name: selectCareRequired,
        page: () => SelectCareRequired(),
        binding: HomeBinding()),
    GetPage(name: login, page: () => Login(), binding: LoginBinding()),
    GetPage(name: register, page: () => Register(), binding: LoginBinding()),
    GetPage(name: modernRegister, page: () => ModernRegister(), binding: LoginBinding()),
    GetPage(name: registerTest, page: () => RegisterTest(), binding: LoginBinding()),
    GetPage(name: otp, page: () => const OTPVerificationScreen(), binding: LoginBinding()),
    GetPage(
        name: rePassword, page: () => RePassword(), binding: LoginBinding()),
    GetPage(name: home, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(name: createCase, page: () => CreateCase()),
    GetPage(name: completeCase, page: () => CompleteCase()),
    GetPage(name: viewDoctorCases, page: () => ViewCases()),
    GetPage(name: viewDoctorCase, page: () => ViewCase()),
    GetPage(name: postView, page: () => PostView()),
    GetPage(name: postNew, page: () => NewPost()),
    GetPage(name: postEdit, page: () => EditPost()),
    GetPage(name: paymentGateway, page: () => PaymentGateway()),
    GetPage(name: paymentReturn, page: () => PaymentReturn()),
    GetPage(name: profileEdit, page: () => ProfileEdit()),
    GetPage(name: requestDoctorRole, page: () => RequestDoctorRole()),
    GetPage(name: viewDetailsRole, page: () => ViewDetailsRole()),
    GetPage(name: addCategory, page: () => AddCategory()),
    GetPage(name: editCategory, page: () => EditCategory()),
    GetPage(name: caseDetailsScreen, page: () => CaseDetailsScreen()),
    GetPage(name: acceptCaseScreen, page: () => AcceptCaseScreen()),
    GetPage(name: rejectCaseScreen, page: () => RejectCaseScreen()),
    GetPage(name: userCaseDetails, page: () => UserCaseDetailsScreen()),
    GetPage(name: AppRoutes.faqScreen, page: () => FAQScreen()),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(name: healthTips, page: () => const HealthTipsScreen()),
  ];
}
