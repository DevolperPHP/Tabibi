import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tabibi/utils/constants/style_app.dart';

import '../../../controllers/category_controller.dart';
import '../../../data/models/category.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';

class CategoresScreen extends StatefulWidget {
  const CategoresScreen({super.key});

  @override
  State<CategoresScreen> createState() => _CategoresScreenState();
}

class _CategoresScreenState extends State<CategoresScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    categoryController.fetchDataCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: SafeArea(
            child: Obx(() {
              if (categoryController.isLoadingCategory.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(
                        radius: 16,
                        color: ModernTheme.primaryBlue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'جاري التحميل...',
                        style: ModernTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (categoryController.categores.isEmpty) {
                return _buildEmptyState();
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await categoryController.fetchDataCategory();
                  },
                  color: ModernTheme.primaryBlue,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 100,
                    ),
                    itemCount: categoryController.categores.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(
                        categoryController.categores[index],
                        index,
                      );
                    },
                  ),
                );
              }
            }),
          ),
        ),
        // Floating Action Buttons
        Positioned(
          bottom: 24,
          left: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRefreshButton(),
              SizedBox(height: 12),
              _buildAddButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.category_outlined,
              size: 60,
              color: ModernTheme.primaryBlue.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'لا توجد فئات',
            style: ModernTheme.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ابدأ بإضافة فئة جديدة',
            style: ModernTheme.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          _buildEmptyStateAddButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyStateAddButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF007AFF).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.addCategory),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'إضافة فئة جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => categoryController.fetchDataCategory(),
          customBorder: CircleBorder(),
          child: Center(
            child: Icon(
              Icons.refresh_rounded,
              color: ModernTheme.primaryBlue,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF007AFF).withOpacity(0.35),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.addCategory),
          customBorder: CircleBorder(),
          child: Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => categoryController.edtitCategorySelect(category),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Index Circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ModernTheme.primaryBlue.withOpacity(0.1),
                          ModernTheme.primaryBlue.withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: ModernTheme.primaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  
                  // Category Name
                  Expanded(
                    child: Text(
                      category.name,
                      style: ModernTheme.titleMedium.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: Icons.edit_outlined,
                        color: Color(0xFF007AFF),
                        onTap: () => categoryController.edtitCategorySelect(category),
                      ),
                      SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.delete_outline_rounded,
                        color: Color(0xFFFF3B30),
                        onTap: () => _showDeleteConfirmation(category.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String categoryId) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(
          'حذف الفئة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'هل أنت متأكد من حذف هذه الفئة؟',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(
              'حذف',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Get.back();
              categoryController.deleteCategory(categoryId);
            },
          ),
        ],
      ),
    );
  }
}
