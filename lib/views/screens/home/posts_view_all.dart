import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/models/post_model.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../../utils/design_system/animations.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/more_widgets.dart';
import 'post_details_screen.dart';

HomeController homeController = Get.find<HomeController>();

class PostsViewAll extends StatelessWidget {
  const PostsViewAll({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: ModernTheme.primaryBlue,
        onRefresh: () async => homeController.fetchDataPosts(),
        child: Obx(() => homeController.isLoading.value
            ? LoadingIndicator()
            : homeController.posts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(ModernTheme.spaceMD),
                    itemBuilder: (context, index) => viewPost(index),
                    itemCount: homeController.posts.length)));
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
        ],
      ),
    );
  }

  Widget viewPost(int index) {
    Post post = homeController.posts[index];
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
                  // Read more indicator
                  Row(
                    children: [
                      Text(
                        'اقرأ المزيد',
                        style: ModernTheme.labelMedium.copyWith(
                          color: ModernTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: ModernTheme.spaceXS),
                      Icon(
                        Icons.arrow_back,
                        size: 16,
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
}
