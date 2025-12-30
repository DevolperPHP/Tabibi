import 'package:get/get.dart';
import 'package:tabibi/data/models/notification_model.dart';
import 'package:tabibi/services/api_service.dart';
import 'package:tabibi/utils/constants/api_constants.dart';

class NotificationService {
  static Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final response = await ApiService.getData(
        '${ApiConstants.notificationsGet}/$userId',
      );

      if (response.isStateSucess < 3 && response.data != null) {
        return NotificationModel.fromJsonList(response.data['notifications']);
      }
      return [];
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  static Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await ApiService.putData(
        '${ApiConstants.notificationMarkRead}/$notificationId',
        {},
      );

      return response.isStateSucess < 3;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  static Future<bool> markAllAsRead(String userId) async {
    try {
      final response = await ApiService.putData(
        '${ApiConstants.notificationMarkAllRead}/$userId',
        {},
      );

      return response.isStateSucess < 3;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await ApiService.deleteData(
        '${ApiConstants.notificationDelete}/$notificationId',
      );

      return response.isStateSucess < 3;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  static Future<bool> sendNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    try {
      final response = await ApiService.postData(
        ApiConstants.notificationSend(),
        {
          'userId': userId,
          'title': title,
          'body': body,
          'type': type,
          'relatedId': relatedId,
        },
      );

      return response.isStateSucess < 3;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }

  static Future<bool> sendBulkNotifications({
    required List<String> userIds,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    try {
      final response = await ApiService.postData(
        ApiConstants.notificationSendBulk(),
        {
          'userIds': userIds,
          'title': title,
          'body': body,
          'type': type,
          'relatedId': relatedId,
        },
      );

      return response.isStateSucess < 3;
    } catch (e) {
      print('Error sending bulk notifications: $e');
      return false;
    }
  }

  // Helper method to get notification type constants
  static String get caseCreatedType => 'case_created';
  static String get caseAcceptedType => 'case_accepted';
  static String get caseRejectedType => 'case_rejected';
  static String get caseTakenType => 'case_taken';
  static String get caseCompletedType => 'case_completed';
  static String get doctorRoleAcceptedType => 'doctor_role_accepted';
  static String get doctorRoleRejectedType => 'doctor_role_rejected';
  static String get healthTipType => 'health_tip';
  static String get dailyHealthTipType => 'daily_health_tip';
  static String get appointmentReminderType => 'appointment_reminder';
}
