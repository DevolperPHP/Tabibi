import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/data/models/notification_model.dart';
import 'package:tabibi/services/notification_service.dart';
import 'package:tabibi/views/widgets/message_snak.dart';
import 'package:tabibi/controllers/storage_controller.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = RxList<NotificationModel>([]);
  final RxBool isLoading = RxBool(false);
  final RxBool hasUnread = RxBool(false);

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchNotifications(String userId) async {
    isLoading(true);
    try {
      final notificationsList = await NotificationService.getNotifications(userId);
      notifications(notificationsList);

      // Check if there are unread notifications
      hasUnread(notifications.any((notif) => !notif.isRead));
    } catch (e) {
      MessageSnak.message('فشل في جلب الإشعارات', color: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    final success = await NotificationService.markAsRead(notification.id);
    if (success) {
      // Update local state
      final index = notifications.indexOf(notification);
      if (index != -1) {
        notifications[index] = notification.copyWith(isRead: true);
        notifications.refresh();

        // Update unread status
        hasUnread(notifications.any((notif) => !notif.isRead));
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userData = StorageController.getUserData();
      if (userData == null) {
        MessageSnak.message('لم يتم العثور على بيانات المستخدم', color: Colors.red);
        return;
      }

      final success = await NotificationService.markAllAsRead(userData.id);

      if (success) {
        // Update all notifications as read
        for (int i = 0; i < notifications.length; i++) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
        notifications.refresh();
        hasUnread(false);
        MessageSnak.message('تم تحديد جميع الإشعارات كمقروءة',
            color: Colors.green);
      }
    } catch (e) {
      MessageSnak.message('فشل في تحديد الإشعارات', color: Colors.red);
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    final success = await NotificationService.deleteNotification(notification.id);
    if (success) {
      notifications.remove(notification);
      notifications.refresh();

      // Update unread status
      hasUnread(notifications.any((notif) => !notif.isRead));
      MessageSnak.message('تم حذف الإشعار', color: Colors.green);
    }
  }

  Future<void> sendNotificationToAdmins({
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    try {
      // Get all admin user IDs (this should be implemented in the service)
      List<String> adminIds = await _getAdminUserIds();

      await NotificationService.sendBulkNotifications(
        userIds: adminIds,
        title: title,
        body: body,
        type: type,
        relatedId: relatedId,
      );
    } catch (e) {
      print('Error sending notification to admins: $e');
    }
  }

  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    try {
      await NotificationService.sendNotification(
        userId: userId,
        title: title,
        body: body,
        type: type,
        relatedId: relatedId,
      );
    } catch (e) {
      print('Error sending notification to user: $e');
    }
  }

  // Helper method to get admin user IDs
  // This should be implemented based on your auth system
  Future<List<String>> _getAdminUserIds() async {
    // TODO: Replace with actual admin IDs retrieval
    // For example, from an API call to get all admin users
    return [];
  }

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return notifications
        .where((notif) => notif.type == type)
        .toList();
  }

  // Get unread count
  int get unreadCount {
    return notifications.where((notif) => !notif.isRead).length;
  }

  // Clear all notifications
  void clearNotifications() {
    notifications([]);
    hasUnread(false);
  }
}
