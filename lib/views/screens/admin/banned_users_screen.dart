import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/controllers/banned_users_controller.dart';
import 'package:tabibi/utils/constants/modern_theme.dart';

import '../../widgets/modern/modern_app_bar.dart';
import '../../widgets/modern/modern_card.dart';

class BannedUsersScreen extends StatelessWidget {
  BannedUsersScreen({super.key});
  final BannedUsersController controller = Get.put(BannedUsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      appBar: ModernAppBar(
        title: 'إدارة المستخدمين',
        showLogo: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: ModernTheme.spaceMD),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              tooltip: 'رجوع',
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchAndFilterSection(),

          // Users List Section
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.users.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.isError.value || controller.users.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchUsers(refresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.all(ModernTheme.spaceLG),
                  itemCount: controller.users.length + 1,
                  itemBuilder: (context, index) {
                    // Load more indicator at the end
                    if (index == controller.users.length) {
                      return _buildLoadMoreIndicator();
                    }
                    final user = controller.users[index];
                    return _buildUserCard(user);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return ModernCard(
      margin: const EdgeInsets.all(ModernTheme.spaceLG),
      padding: const EdgeInsets.all(ModernTheme.spaceMD),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'البحث بالاسم أو البريد الإلكتروني...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                      borderSide: BorderSide(color: ModernTheme.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                      borderSide: BorderSide(color: ModernTheme.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                      borderSide: BorderSide(color: ModernTheme.primaryBlue, width: 2),
                    ),
                    filled: true,
                    fillColor: ModernTheme.surface,
                  ),
                  onChanged: (value) {
                    // Debounce search
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (controller.searchQuery.value != value) {
                        controller.searchUsers(value);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: controller.clearSearch,
                    )
                  : const SizedBox.shrink()),
            ],
          ),

          const SizedBox(height: ModernTheme.spaceMD),

          // Filter Chips
          Row(
            children: [
              _buildFilterChip('الكل', 'all', Icons.list),
              const SizedBox(width: ModernTheme.spaceSM),
              _buildFilterChip('محظورين', 'banned', Icons.block),
              const SizedBox(width: ModernTheme.spaceSM),
              _buildFilterChip('نشطين', 'active', Icons.check_circle),
            ],
          ),

          const SizedBox(height: ModernTheme.spaceSM),

          // Stats
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إجمالي المستخدمين: ${controller.totalUsers.value}',
                    style: ModernTheme.bodySmall.copyWith(
                      color: ModernTheme.textSecondary,
                    ),
                  ),
                  if (controller.totalPages.value > 1)
                    Text(
                      'صفحة ${controller.currentPage.value} من ${controller.totalPages.value}',
                      style: ModernTheme.bodySmall.copyWith(
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    return Obx(() {
      final isSelected = controller.filterStatus.value == value;
      return FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : null),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => controller.filterByStatus(value),
        selectedColor: ModernTheme.primaryBlue,
        checkmarkColor: Colors.white,
        backgroundColor: ModernTheme.surface,
        labelStyle: ModernTheme.bodySmall.copyWith(
          color: isSelected ? Colors.white : ModernTheme.textPrimary,
        ),
        side: BorderSide(
          color: isSelected ? ModernTheme.primaryBlue : ModernTheme.divider,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
          side: BorderSide(
            color: isSelected ? ModernTheme.primaryBlue : ModernTheme.divider,
          ),
        ),
      );
    });
  }

  Widget _buildUserCard(UserItem user) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: ModernTheme.spaceMD),
      padding: const EdgeInsets.all(ModernTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: user.isBanned
                      ? LinearGradient(colors: [Colors.red.shade400, Colors.red.shade600])
                      : ModernTheme.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: ModernTheme.spaceMD),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: ModernTheme.headline4.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (user.isDoctor)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'طبيب',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: ModernTheme.bodySmall.copyWith(
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (user.phone != null) ...[
                          const Icon(Icons.phone, size: 12, color: ModernTheme.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            user.phone!,
                            style: ModernTheme.bodySmall.copyWith(
                              color: ModernTheme.textTertiary,
                            ),
                          ),
                          const SizedBox(width: ModernTheme.spaceMD),
                        ],
                        if (user.city != null) ...[
                          const Icon(Icons.location_on, size: 12, color: ModernTheme.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            user.city!,
                            style: ModernTheme.bodySmall.copyWith(
                              color: ModernTheme.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Ban Status Badge
              if (user.isBanned)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, size: 12, color: Colors.red.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'محظور',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'نشط',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Ban Info (if banned)
          if (user.isBanned && user.banReason != null) ...[
            const SizedBox(height: ModernTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(ModernTheme.spaceSM),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: Colors.red.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'سبب الحظر',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.banReason!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade900,
                    ),
                  ),
                  if (user.bannedByName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'من قبل: ${user.bannedByName}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: ModernTheme.spaceMD),

          // Action Buttons
          Row(
            children: [
              if (user.isBanned) ...[
                // Unban Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.showUnbanDialog(user.id, user.name),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('إلغاء الحظر'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade300),
                    ),
                  ),
                ),
                const SizedBox(width: ModernTheme.spaceSM),
                // Delete Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.showDeleteDialog(user.id, user.name, user.email),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('حذف'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade300),
                    ),
                  ),
                ),
              ] else ...[
                // Ban Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.showBanDialog(user.id, user.name, user.email),
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('حظر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: ModernTheme.spaceSM),
                // Delete Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.showDeleteDialog(user.id, user.name, user.email),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('حذف'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade300),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.currentPage.value < controller.totalPages.value) {
        return Padding(
          padding: const EdgeInsets.all(ModernTheme.spaceLG),
          child: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: controller.loadNextPage,
                    child: const Text('تحميل المزيد'),
                  ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            controller.filterStatus.value == 'banned'
                ? Icons.block
                : Icons.people_outline,
            size: 80,
            color: ModernTheme.textTertiary,
          ),
          const SizedBox(height: ModernTheme.spaceLG),
          Text(
            controller.filterStatus.value == 'banned'
                ? 'لا يوجد مستخدمين محظورين'
                : 'لا يوجد مستخدمين',
            style: ModernTheme.headline4.copyWith(
              color: ModernTheme.textSecondary,
            ),
          ),
          const SizedBox(height: ModernTheme.spaceSM),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'جرب البحث بكلمات مختلفة'
                : 'المستخدمين الذين تقوم بإضافتهم سيظهرون هنا',
            style: ModernTheme.bodyMedium.copyWith(
              color: ModernTheme.textTertiary,
            ),
          ),
          const SizedBox(height: ModernTheme.spaceLG),
          if (controller.searchQuery.value.isNotEmpty ||
              controller.filterStatus.value != 'all')
            ElevatedButton.icon(
              onPressed: () {
                controller.clearSearch();
                controller.filterByStatus('all');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('تحديث'),
            ),
        ],
      ),
    );
  }
}
