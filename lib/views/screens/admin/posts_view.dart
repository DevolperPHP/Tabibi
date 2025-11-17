import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/routes/app_routes.dart';
import '../../../controllers/admin_controller.dart';
import '../../../data/models/post_model.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../../utils/design_system/animations.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/more_widgets.dart';
import '../home/post_details_screen.dart';

class PostsView extends StatelessWidget {
  PostsView({super.key});
  AdminController adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          color: ModernTheme.primaryBlue,
          onRefresh: () async => adminController.fetchDataPosts(),
          child: Obx(() => adminController.isLoading.value
              ? LoadingIndicator()
              : adminController.posts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(ModernTheme.spaceMD),
                      itemBuilder: (context, index) => viewPost(index),
                      itemCount: adminController.posts.length)),
        ),
        // Floating Action Button
        Positioned(
          bottom: ModernTheme.spaceLG,
          left: ModernTheme.spaceMD,
          child: Container(
            decoration: BoxDecoration(
              gradient: ModernTheme.primaryGradient,
              borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
              boxShadow: ModernTheme.shadowLG,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.postNew),
                borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                child: Container(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.add, size: 32, color: Colors.white),
                ),
              ),
            ),
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
          Icon(
            Icons.article_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          Text(
            'لم يتم إضافة منشورات بعد',
            style: ModernTheme.titleLarge.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ModernTheme.spaceSM),
          Text(
            'اضغط على + لإضافة منشور جديد',
            style: ModernTheme.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget viewPost(int index) {
    Post post = adminController.posts[index];
    return AppAnimations.fadeSlideIn(
      duration: Duration(milliseconds: 300 + (index * 50)),
      offset: 30,
      child: GestureDetector(
        onTap: () => Get.to(() => PostDetailsScreen(post: post)),
        child: Container(
          margin: EdgeInsets.only(bottom: ModernTheme.spaceMD),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
            boxShadow: ModernTheme.shadowMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image with gradient overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ModernTheme.radiusLG),
                      topRight: Radius.circular(ModernTheme.radiusLG),
                    ),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: imageCached(post.image),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ModernTheme.radiusLG),
                          topRight: Radius.circular(ModernTheme.radiusLG),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Action buttons (Edit & Delete)
                  Positioned(
                    top: ModernTheme.spaceMD,
                    right: ModernTheme.spaceMD,
                    child: Row(
                      children: [
                        // Edit button
                        GestureDetector(
                          onTap: () {
                            adminController.postSelect(post);
                            adminController.fullUpdata();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ModernTheme.spaceSM,
                              vertical: ModernTheme.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                              boxShadow: ModernTheme.shadowSM,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: ModernTheme.primaryBlue,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'تعديل',
                                  style: ModernTheme.labelMedium.copyWith(
                                    color: ModernTheme.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: ModernTheme.spaceXS),
                        // Delete button
                        GestureDetector(
                          onTap: () {
                            adminController.postSelect(post);
                            _showDeleteDialog();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ModernTheme.spaceSM,
                              vertical: ModernTheme.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                              boxShadow: ModernTheme.shadowSM,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'حذف',
                                  style: ModernTheme.labelMedium.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Content
              Padding(
                padding: EdgeInsets.all(ModernTheme.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      post.title,
                      style: ModernTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ModernTheme.spaceSM),
                    // Description
                    Text(
                      post.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: ModernTheme.bodyMedium.copyWith(
                        color: ModernTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: ModernTheme.spaceSM),
                    // Action row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'معاينة',
                              style: ModernTheme.labelMedium.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: ModernTheme.primaryBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      titleStyle: ModernTheme.headlineMedium.copyWith(
        color: ModernTheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      middleText: 'هل أنت متأكد من حذف هذا المنشور؟\nلن تتمكن من التراجع عن هذا الإجراء.',
      middleTextStyle: ModernTheme.bodyLarge.copyWith(
        color: ModernTheme.textSecondary,
      ),
      textConfirm: 'نعم، حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      cancelTextColor: ModernTheme.textPrimary,
      buttonColor: Colors.red,
      radius: ModernTheme.radiusMD,
      onConfirm: () async {
        Get.back(); // Close dialog
        await adminController.submitDelete();
      },
    );
  }
}
