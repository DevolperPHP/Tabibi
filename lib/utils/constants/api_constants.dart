class ApiConstants {
  static String baseUrl = 'http://165.232.78.163/';
  static String baseUrlImage = '${baseUrl}upload/images/';
  // Auth User
  static const String login = 'passport/login';
  static const String register = 'passport/register';
  // Admin
  static const String roleRequests = 'admin/role/requests';
  static String roleRequestsGet(String id) => 'admin/role/requests/get/$id';
  static const String categoryNew = 'admin/category/new';
  static const String adminCases = 'admin/case';
  static String adminCasesGet(String id) => 'admin/case/get/$id';
  static String adminCasesAccept(String id) => 'admin/case/accept/$id';
  static String adminCasesReject(String id) => 'admin/case/reject/$id';
  static String adminCasesDelete(String id) => 'admin/case/delete/$id';
  static String adminCasesReReview(String id) => 'admin/case/review-again/$id';
  static String adminCasesReAccept(String id) => 'admin/case/accept-again/$id';
  static String categoryDelete(String id) => 'admin/category/delete/$id';

  // Notification endpoints
  static String notificationsGet(String userId) => 'notifications/$userId';
  static String notificationMarkRead(String id) => 'notifications/$id/mark-read';
  static String notificationMarkAllRead(String userId) => 'notifications/$userId/mark-all-read';
  static String notificationDelete(String id) => 'notifications/$id/delete';
  static String notificationSend() => 'notifications/send';
  static String notificationSendBulk() => 'notifications/send-bulk';

  // FCM Token endpoints
  static String fcmTokenUpdate(String userId) => 'users/$userId';

  // Health tips endpoints
  static String healthTipsGetAll() => 'admin/health-tips';
  static String healthTipsSendToAll() => 'admin/health-tips/send-to-all';
  static String healthTipsSend() => 'admin/health-tips/send';
  static String healthTipsDelete(String id) => 'admin/health-tips/$id';

  static String categoryEdit(String id) => 'admin/category/edit/$id';
  static String roleAccept(String id) =>
      'admin/role/requests/update/accept/$id';
  static String roleReject(String id) =>
      'admin/role/requests/update/reject/$id';
  static const String roleDoctorRequests = 'profile/role/doctor';

  //  profile
  static const String profile = 'profile';
  static const String profileUpdate = 'profile/info/update';
  static const String profileDelete = 'profile/info/delete';
  static const String profileRoleDoctor = 'profile/role/doctor';

  //case
  static const String caseNew = 'case/new';
  static String caseCancel(String id) => 'case/cancel/$id';
  static String caseEdit(String id) => 'case/edit/$id';
  static const String casesAndCategory = 'doctor/cases';
  static String casesByCategory(String category) =>
      'doctor/cases/category/$category';
  //
  static const String postNew = 'admin/post/new';
  static const String posts = 'admin/post/posts';
  static const String homePost = 'home';
  static String postsEditId(String id) => 'admin/post/edit/$id';
  static String postsDeleteId(String id) => 'admin/post/delete/$id';

  static const String doctorCases = 'doctor/cases';
  static String doctorTakeCase(String id) => 'doctor/case/take/$id';
  static const String doctorOmeCases = 'doctor/my-cases';
  static String doctorMarkCaseDone(String id) => 'doctor/my-case/done/$id';
}
