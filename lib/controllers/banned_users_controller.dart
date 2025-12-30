import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../views/widgets/message_snak.dart';
import '../utils/constants/color_app.dart';

class BannedUsersController extends GetxController {
  // Loading states
  RxBool isLoading = RxBool(false);
  RxBool isBanning = RxBool(false);
  RxBool isUnbanning = RxBool(false);

  // Users list
  RxList<UserItem> users = <UserItem>[].obs;
  RxList<UserItem> filteredUsers = <UserItem>[].obs;

  // Search query
  RxString searchQuery = ''.obs;

  // Filter by banned status
  RxString filterStatus = 'all'.obs; // all, banned, active

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalUsers = 0.obs;
  RxInt pageSize = 50.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Fetch users from API
  Future<void> fetchUsers({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
    }

    isLoading(true);
    isError(false);

    try {
      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': currentPage.value.toString(),
        'limit': pageSize.value.toString(),
      };

      // Add search query if exists
      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      // Add banned status filter if not 'all'
      if (filterStatus.value == 'banned') {
        queryParams['isBanned'] = 'true';
      } else if (filterStatus.value == 'active') {
        queryParams['isBanned'] = 'false';
      }

      // Build query string
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      final endpoint = '${ApiConstants.usersList}?$queryString';

      final response = await ApiService.getData(endpoint);

      if (response.isStateSucess < 3 && response.data != null) {
        // Parse users
        if (response.data['users'] != null) {
          final List<dynamic> usersList = response.data['users'];
          users.value = usersList.map((json) => UserItem.fromJson(json)).toList();
          filteredUsers.value = users;
        }

        // Parse pagination
        if (response.data['pagination'] != null) {
          totalPages.value = response.data['pagination']['totalPages'] ?? 1;
          totalUsers.value = response.data['pagination']['totalUsers'] ?? 0;
        }
      } else {
        isError(true);
      }
    } catch (e) {
      isError(true);
      print('Error fetching users: $e');
    }

    isLoading.value = false;
  }

  // Search users
  void searchUsers(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    fetchUsers();
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    currentPage.value = 1;
    fetchUsers();
  }

  // Filter by status
  void filterByStatus(String status) {
    filterStatus.value = status;
    currentPage.value = 1;
    fetchUsers();
  }

  // Load next page
  void loadNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchUsers();
    }
  }

  // Load previous page
  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchUsers();
    }
  }

  // Ban user
  Future<void> banUser(String userId, String userName, {String? reason}) async {
    isBanning(true);

    try {
      final response = await ApiService.putData(
        ApiConstants.usersBan(userId),
        {'reason': reason ?? 'Violation of terms'},
      );

      if (response.isStateSucess < 3) {
        MessageSnak.message(
          'تم حظر المستخدم $userName بنجاح',
          color: ColorApp.greenColor,
        );
        // Refresh users list
        await fetchUsers();
      } else {
        MessageSnak.message(
          response.data['message'] ?? 'فشل حظر المستخدم',
          color: ColorApp.redColor,
        );
      }
    } catch (e) {
      MessageSnak.message(
        'خطأ في حظر المستخدم: $e',
        color: ColorApp.redColor,
      );
      print('Error banning user: $e');
    }

    isBanning.value = false;
  }

  // Unban user
  Future<void> unbanUser(String userId, String userName) async {
    isUnbanning(true);

    try {
      final response = await ApiService.putData(
        ApiConstants.usersUnban(userId),
        {},
      );

      if (response.isStateSucess < 3) {
        MessageSnak.message(
          'تم إلغاء حظر المستخدم $userName بنجاح',
          color: ColorApp.greenColor,
        );
        // Refresh users list
        await fetchUsers();
      } else {
        MessageSnak.message(
          response.data['message'] ?? 'فشل إلغاء حظر المستخدم',
          color: ColorApp.redColor,
        );
      }
    } catch (e) {
      MessageSnak.message(
        'خطأ في إلغاء حظر المستخدم: $e',
        color: ColorApp.redColor,
      );
      print('Error unbanning user: $e');
    }

    isUnbanning.value = false;
  }

  // Delete user
  Future<void> deleteUser(String userId, String userName) async {
    try {
      final response = await ApiService.deleteData(
        ApiConstants.usersDelete(userId),
      );

      if (response.isStateSucess < 3) {
        MessageSnak.message(
          'تم حذف المستخدم $userName بنجاح',
          color: ColorApp.greenColor,
        );
        // Refresh users list
        await fetchUsers();
      } else {
        MessageSnak.message(
          response.data['message'] ?? 'فشل حذف المستخدم',
          color: ColorApp.redColor,
        );
      }
    } catch (e) {
      MessageSnak.message(
        'خطأ في حذف المستخدم: $e',
        color: ColorApp.redColor,
      );
      print('Error deleting user: $e');
    }
  }

  // Show ban confirmation dialog
  void showBanDialog(String userId, String userName, String userEmail) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('حظر المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('سيتم حظر المستخدم:'),
            const SizedBox(height: 8),
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              userEmail,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Text('سبب الحظر:'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'أدخل سبب الحظر...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          Obx(() => isBanning.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    Get.back();
                    banUser(userId, userName,
                        reason: reasonController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('حظر', style: TextStyle(color: Colors.white)),
                )),
        ],
      ),
    );
  }

  // Show unban confirmation dialog
  void showUnbanDialog(String userId, String userName) {
    Get.dialog(
      AlertDialog(
        title: const Text('إلغاء الحظر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('سيتم إلغاء حظر المستخدم:'),
            const SizedBox(height: 8),
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('هل أنت متأكد من إلغاء حظر هذا المستخدم؟'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          Obx(() => isUnbanning.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    Get.back();
                    unbanUser(userId, userName);
                  },
                  child: const Text('إلغاء الحظر'),
                )),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  void showDeleteDialog(String userId, String userName, String userEmail) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('سيتم حذف المستخدم بشكل نهائي:'),
            const SizedBox(height: 8),
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              userEmail,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Text(
              '⚠️ هذا الإجراء لا يمكن التراجع عنه',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteUser(userId, userName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Error state
  RxBool isError = RxBool(false);
}

// User item model for the list
class UserItem {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? city;
  final String? age;
  final bool isBanned;
  final DateTime? bannedAt;
  final String? banReason;
  final String? bannedByName;
  final bool isDoctor;
  final bool isAdmin;
  final DateTime createdAt;

  UserItem({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.city,
    this.age,
    required this.isBanned,
    this.bannedAt,
    this.banReason,
    this.bannedByName,
    required this.isDoctor,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      city: json['city'],
      age: json['age']?.toString(),
      isBanned: json['isBanned'] ?? false,
      bannedAt: json['bannedAt'] != null
          ? DateTime.parse(json['bannedAt'])
          : null,
      banReason: json['banReason'],
      bannedByName: json['bannedByName'],
      isDoctor: json['isDoctor'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'age': age,
      'isBanned': isBanned,
      'bannedAt': bannedAt?.toIso8601String(),
      'banReason': banReason,
      'bannedByName': bannedByName,
      'isDoctor': isDoctor,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
