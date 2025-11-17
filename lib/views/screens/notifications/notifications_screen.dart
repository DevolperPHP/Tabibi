import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/notification_controller.dart';
import '../../../controllers/storage_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    // Load notifications when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  void _loadNotifications() {
    final userData = StorageController.getUserData();
    if (userData != null) {
      notificationController.fetchNotifications(userData.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2196F3),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Obx(() {
            final int unreadCount = notificationController.unreadCount;
            if (unreadCount > 0) {
              return IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.done_all, size: 26),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  await notificationController.markAllAsRead();
                },
              );
            }
            return IconButton(
              icon: Icon(Icons.done_all, size: 26),
              onPressed: () async {
                await notificationController.markAllAsRead();
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (notificationController.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async => _loadNotifications(),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, int index) {
              final notification = notificationController.notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ستظهر هنا جميع الإشعارات الخاصة بك',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    final bool isRead = notification.isRead ?? false;
    final Color backgroundColor = isRead ? Colors.white : Color(0xFFE3F2FD);
    final Color borderColor = isRead ? Colors.grey[300]! : Color(0xFF2196F3);

    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'case_created':
        iconData = Icons.add_circle_outline;
        iconColor = Colors.blue;
        break;
      case 'case_accepted':
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case 'case_rejected':
        iconData = Icons.cancel_outlined;
        iconColor = Colors.red;
        break;
      case 'case_taken':
        iconData = Icons.medical_services_outlined;
        iconColor = Colors.purple;
        break;
      case 'health_tip':
        iconData = Icons.favorite_outline;
        iconColor = Colors.pink;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = Colors.grey;
    }

    String timeAgo = '';
    if (notification.createdAt != null) {
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(notification.createdAt!);
      if (diff.inMinutes < 1) {
        timeAgo = 'الآن';
      } else if (diff.inHours < 1) {
        timeAgo = 'منذ ${diff.inMinutes} دقيقة';
      } else if (diff.inDays < 1) {
        timeAgo = 'منذ ${diff.inHours} ساعة';
      } else {
        timeAgo = 'منذ ${diff.inDays} يوم';
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: isRead ? 1 : 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            if (!isRead) {
              await notificationController.markAsRead(notification);
            }

            // Handle notification tap based on type
            _handleNotificationTap(notification);
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: isRead ? 1 : 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    size: 24,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.body ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF2196F3),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(dynamic notification) {
    // Navigate to relevant screen based on notification type
    switch (notification.type) {
      case 'case_created':
      case 'case_accepted':
      case 'case_rejected':
      case 'case_taken':
        // Navigate to case details
        Get.toNamed('/case-details', arguments: notification.relatedId);
        break;
      case 'health_tip':
        // Navigate to health tips or home
        Get.toNamed('/home');
        break;
      default:
        break;
    }
  }
}
